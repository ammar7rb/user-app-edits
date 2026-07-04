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

class ClearanceSaleWidget extends StatelessWidget {
  final Product product;
  final bool? isCenterElement;
  final SellerNavigationModel? sellerNavigationModel;
  const ClearanceSaleWidget({super.key, required this.product, this.isCenterElement, this.sellerNavigationModel});

  @override
  Widget build(BuildContext context) {
    final bool isLtr  = Provider.of<LocalizationController>(context, listen: false).isLtr;

    return InkWell(
      onTap: () => RouterHelper.getProductDetailsRoute(action: RouteAction.push, productId: product.id, slug: product.slug),

      child: LayoutBuilder(
          builder: (context, constrains) {
            return AnimatedContainer(
              margin: isCenterElement == null ? null :  EdgeInsets.symmetric(vertical : isCenterElement! ? 0 : Dimensions.paddingSizeEight),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).colorScheme.onTertiary),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha:0.05), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, 5)),
                ]),

              duration: const Duration(milliseconds: 600),
              child: Stack(
                children: [
                  AnimatedContainer(
                    margin: isCenterElement == null ? null :  EdgeInsets.symmetric(vertical : isCenterElement! ? 0 : 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).colorScheme.onTertiary),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).primaryColor.withValues(alpha:0.05), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, 5)),
                      ]
                    ),

                    duration: const Duration(milliseconds: 600),
                    child: Stack(children: [
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                              border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.05), width: 1),
                              color: Theme.of(context).highlightColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              child: CustomImageWidget(
                                image: '${product.thumbnailFullUrl?.path}',
                                height: constrains.maxHeight * 0.8,
                                width: constrains.maxHeight * 0.8,
                              ),
                            ),
                          ),
                        ),

                        Expanded(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(product.currentStock! == 0 && product.productType == 'physical')
                                Text(getTranslated('out_of_stock', context) ?? '',
                                    style: textRegular.copyWith(color: const Color(0xFFF36A6A))
                                ),

                              if((int.tryParse(product.reviewCount.toString()) ?? 0) > 0)
                                Row(children: [
                                  Icon(Icons.star_rate_rounded, color: Provider.of<ThemeController>(context).darkTheme ?
                                  Colors.white : Colors.orange, size: 15),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: Text(
                                      product.rating != null && product.rating!.isNotEmpty ? double.parse(product.rating![0].average!).toStringAsFixed(1) : '0.0',
                                      style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                                    ),
                                  ),

                                  Text('(${product.reviewCount.toString()})', style: textMedium.copyWith(
                                    color: Theme.of(context).hintColor,
                                    fontSize: Dimensions.fontSizeDefault,
                                  )),
                                ]),



                              Row(children: [
                                Flexible(child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    product.name ?? '', style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                                    maxLines: ((isCenterElement ?? false)) ? 2 : 1, overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                              ]),

                              FittedBox(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                    ((product.discount!= null && product.discount! > 0) || (product.clearanceSale?.discountAmount ?? 0) > 0) ?
                                    PriceConverter.convertPrice(context, product.unitPrice!.toDouble()) : '',
                                    style: textRegular.copyWith(color: Theme.of(context).hintColor,
                                        decoration: TextDecoration.lineThrough, fontSize: Dimensions.fontSizeSmall)),

                                // ((product.discount!= null && product.discount! > 0) || (product.clearanceSale?.discountAmount ?? 0) > 0)
                                //     ? const SizedBox(height: Dimensions.paddingSizeExtraSmall): const SizedBox(),

                                Text(
                                  PriceConverter.convertPrice(
                                    context, product.unitPrice!.toDouble(),
                                    discountType: (product.clearanceSale?.discountAmount ?? 0) > 0
                                      ? product.clearanceSale?.discountType
                                      : product.discountType,
                                    discount: (product.clearanceSale?.discountAmount ?? 0) > 0
                                      ?  product.clearanceSale?.discountAmount
                                      : product.discount
                                  ),
                                  style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault,),
                                ),

                              ]))],
                          ),
                        )),
                      ]),




                      Positioned(top: 10, right: isLtr ? 10 : null, left: !isLtr ? 10 : null, child: FavouriteButtonWidget(
                        sellerNavigationModel: sellerNavigationModel,
                        backgroundColor:  Provider.of<ThemeController>(context).darkTheme ?
                        Theme.of(context).cardColor : Theme.of(context).primaryColor, productId: product.id)),
                    ]),
                  ),

                  ((product.discount! > 0) || (product.clearanceSale?.discountAmount ?? 0) > 0) ?
                  DiscountTagWidget(productModel: product, positionedTop: 0, positionedLeft: 2,
                      topLeftBorderRadius: Dimensions.radiusDefault, bottomRightBorderRadius: Dimensions.radiusDefault)
                      : const SizedBox.shrink(),

                ],
              ),
            );
          }
      ),
    );
  }
}
