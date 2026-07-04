import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/discount_tag_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/shop_navigation_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:provider/provider.dart';


class ProductWidget extends StatelessWidget {
  final Product productModel;
  final int productNameLine;
  final double? margin;
  final SellerNavigationModel? sellerNavigationModel;
  const ProductWidget({super.key, required this.productModel, this.productNameLine = 1, this.margin, this.sellerNavigationModel});

  @override
  Widget build(BuildContext context) {
    final bool isLtr  = Provider.of<LocalizationController>(context, listen: false).isLtr;
    double ratting = (productModel.rating?.isNotEmpty ?? false) ?  double.parse('${productModel.rating?[0].average}') : 0;

    return InkWell(
      onTap: () {
        RouterHelper.getProductDetailsRoute(
          action: RouteAction.push,
          productId: productModel.id,
          slug: productModel.slug,
        );
      },
      child: Container(
        margin: EdgeInsets.all(margin ?? Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.10), width: 1),
          color: Theme.of(context).highlightColor,
          boxShadow: [BoxShadow(
            color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.06),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          )],
        ),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            LayoutBuilder(builder: (context, boxConstraint)=> ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusDefault),
                topRight: Radius.circular(Dimensions.radiusDefault),
              ),
              child: Stack(children: [

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.05), width: 1),
                    color: Theme.of(context).highlightColor,
                  ),
                  margin: const EdgeInsets.all(Dimensions.paddingSizeSmall).copyWith(bottom: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    child: CustomImageWidget(
                      image: '${productModel.thumbnailFullUrl?.path}',
                      fit: BoxFit.cover,
                      height: boxConstraint.maxWidth * 0.82,
                      width: boxConstraint.maxWidth,
                    ),
                  ),
                ),

                if(productModel.currentStock! == 0 && productModel.productType == 'physical')...[
                  Container(
                    height: boxConstraint.maxWidth * 0.82,
                    width: boxConstraint.maxWidth,
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.4),
                  ),

                  Positioned.fill(child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: boxConstraint.maxWidth,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.4),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radiusSmall),
                            topRight: Radius.circular(Dimensions.radiusSmall),
                          )
                      ),
                      child: Text(
                        getTranslated('out_of_stock', context)??'',
                        style: textBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
                ],
              ]),
            )),

            // Product Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                if(ratting > 0) Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const Icon(Icons.star_rate_rounded, color: Colors.orange, size: Dimensions.paddingSizeDefault),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(ratting.toStringAsFixed(1), style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    )),
                  ),

                  Text('(${PriceConverter.longToShortPrice(productModel.reviewCount?.toDouble() ?? 0, withDecimalPoint: false)})',
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                  ),
                ]),

                Text(productModel.name ?? '', textAlign: TextAlign.center, style: textMedium.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ), maxLines: productNameLine, overflow: TextOverflow.ellipsis),

                if(hasDiscount())
                  Text(PriceConverter.convertPrice(context, productModel.unitPrice), style: titleRegular.copyWith(
                    color: Theme.of(context).hintColor,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Theme.of(context).hintColor,
                    fontSize: Dimensions.fontSizeSmall,
                  )),

                Text(
                  PriceConverter.convertPrice(
                    context, productModel.unitPrice,
                    discountType: (productModel.clearanceSale?.discountAmount ?? 0) > 0
                      ? productModel.clearanceSale?.discountType
                      : productModel.discountType,
                    discount: (productModel.clearanceSale?.discountAmount ?? 0) > 0
                      ? productModel.clearanceSale?.discountAmount
                      : productModel.discount,
                  ),
                  style: robotoBold.copyWith(color:  Provider.of<ThemeController>(context).darkTheme ?
                  Theme.of(context).textTheme.bodyLarge?.color :
                  Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeDefault),
                ),

              ]),
            ),
          ]),

          if(hasDiscount())
            DiscountTagWidget(productModel: productModel, positionedTop: 0, topLeftBorderRadius: Dimensions.radiusDefault, bottomRightBorderRadius: Dimensions.radiusDefault),

          Positioned(top: Dimensions.paddingSizeDefault, right: isLtr ? Dimensions.paddingSizeDefault : null, left: !isLtr ? Dimensions.paddingSizeDefault : null,
            child: FavouriteButtonWidget(
              sellerNavigationModel: sellerNavigationModel,
              backgroundColor: Provider.of<ThemeController>(context).darkTheme
                ? Theme.of(context).cardColor
                : Theme.of(context).primaryColor,
              productId: productModel.id,
            ),
          ),
        ]),
      ),
    );
  }

  bool hasDiscount() => (productModel.discount != null && productModel.discount! > 0) || (productModel.clearanceSale?.discountAmount ?? 0) > 0;
}
