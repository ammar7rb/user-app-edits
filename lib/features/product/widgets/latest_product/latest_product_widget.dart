import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/discount_tag_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

class LatestProductWidget extends StatelessWidget {
  final Product productModel;
  const LatestProductWidget({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    final bool isLtr  = Provider.of<LocalizationController>(context, listen: false).isLtr;

    String ratting = productModel.rating != null && productModel.rating!.isNotEmpty? productModel.rating![0].average! : "0";

    return InkWell(onTap: () {
      RouterHelper.getProductDetailsRoute(action: RouteAction.push, productId: productModel.id, slug: productModel.slug!);
      },

      child: Padding(padding: EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                borderRadius:  const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                Theme.of(context).highlightColor : Theme.of(context).highlightColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withValues(alpha:0.075),
                      spreadRadius: 1, blurRadius: 1, offset: const Offset(0,1)
                    )
                  ]
              ),
              child: SizedBox(
                height: ResponsiveHelper.isTab(context) ? 250 : 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productModel.thumbnail != null?
                    Container(
                      // height: (recommended.recommendedProduct!.currentStock! < recommended.recommendedProduct!.minimumOrderQuantity! &&
                      //     recommended.recommendedProduct!.productType == 'physical')? 170:150,
                      decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                        border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.08), width: .5),
                        borderRadius: const BorderRadius.all(Radius.circular(5))
                      ),
                      child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          child: Stack(
                            children: [
                              CustomImageWidget(
                                height: ResponsiveHelper.isTab(context) ? 250 : 100,
                                width: ResponsiveHelper.isTab(context) ? 230 : 100,
                                image: '${productModel.thumbnailFullUrl?.path}',
                              ),

                              if(productModel.currentStock! == 0 &&
                                  productModel.productType == 'physical')
                                Positioned.fill(child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: ResponsiveHelper.isTab(context) ? 230 : 100,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.error.withValues(alpha:0.4),
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
                          )
                      )
                    ) : const SizedBox(),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          if((productModel.reviewCount ?? 0) < 0 || double.parse(ratting) > 0 )...[
                            Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Icon(Icons.star, color: Provider.of<ThemeController>(context).darkTheme ?
                              Colors.white : Colors.orange, size: 12),

                              Text(double.parse(ratting).toStringAsFixed(1),
                                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)
                              ),

                              Text('(${ productModel.reviewCount ?? '0'})', style:
                              textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).hintColor)),
                            ]),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          ],

                          SizedBox(width: MediaQuery.of(context).size.width/3.0,
                              child: Text(productModel.name??'',maxLines: 2, overflow: TextOverflow.ellipsis,
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color )
                              )
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  productModel.discount!= null &&
                                      productModel.discount! > 0 || (productModel.clearanceSale?.discountAmount ?? 0) > 0 ?
                                  Text(
                                    PriceConverter.convertPrice(context, productModel.unitPrice),
                                    style: textRegular.copyWith(color: Theme.of(context).hintColor,
                                      decoration: TextDecoration.lineThrough, fontSize: Dimensions.fontSizeSmall,),
                                  ) : const SizedBox.shrink(),
                                  const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall,
                                      width: Dimensions.paddingSizeExtraSmall),

                                  productModel.unitPrice != null?
                                  Text(PriceConverter.convertPrice(context, productModel.unitPrice,
                                      discountType: (productModel.clearanceSale?.discountAmount ?? 0) > 0
                                          ? productModel.clearanceSale?.discountType
                                          : productModel.discountType,

                                      discount: (productModel.clearanceSale?.discountAmount ?? 0) > 0
                                          ?  productModel.clearanceSale?.discountAmount
                                          : productModel.discount),
                                      style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color,
                                          fontSize: Dimensions.fontSizeDefault)) : const SizedBox(),
                                ],
                              ),
                            ],
                          ),

                        ],),
                    ),


                  ],
                ),
              ),
            ),

            Positioned(top: 8, right: isLtr ? 10 : null, left: !isLtr ? 10 : null, child: FavouriteButtonWidget(
              backgroundColor:  Provider.of<ThemeController>(context).darkTheme ?
              Theme.of(context).cardColor : Theme.of(context).primaryColor,
              productId: productModel.id)
            ),


            productModel.discount!= null &&
                ((productModel.discount! > 0) || (productModel.clearanceSale?.discountAmount ?? 0) > 0)  ?
            DiscountTagWidget(
                productModel: productModel,
                positionedTop: 0,
                topLeftBorderRadius: Dimensions.radiusDefault,
                bottomRightBorderRadius: Dimensions.radiusDefault
            ) : const SizedBox.shrink(),

          ],
        ),
      ),
    );
  }
}
