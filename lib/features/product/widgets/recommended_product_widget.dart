import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/discount_tag_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/recommended_product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:provider/provider.dart';


class RecommendedProductWidget extends StatelessWidget {
  final bool fromAsterTheme;
  const RecommendedProductWidget({super.key,  this.fromAsterTheme = false});


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final bool isLtr  = Provider.of<LocalizationController>(context, listen: false).isLtr;
    return Container(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault),
      color: Theme.of(context).colorScheme.onTertiary,
      child: Column(children: [
        Consumer<ProductController>(
          builder: (context, recommended, child) {
            String? ratting = recommended.recommendedProduct != null && recommended.recommendedProduct!.rating != null &&
              recommended.recommendedProduct!.rating!.isNotEmpty? recommended.recommendedProduct!.rating![0].average : "0";

            return  (recommended.recommendedProduct != null) ?
            recommended.recommendedProduct?.id != -1 ?
            InkWell(onTap: () {
              RouterHelper.getProductDetailsRoute(action: RouteAction.push, productId: recommended.recommendedProduct!.id, slug: recommended.recommendedProduct!.slug);
            },
              child: Stack(children: [
                  Positioned(top: -10, left: MediaQuery.of(context).size.width*0.35,
                    child: Image.asset(Images.dealOfTheDay, width: 150, height: 150, opacity: const AlwaysStoppedAnimation(0.25))
                  ),

                  Column(children: [
                    fromAsterTheme?
                      Column(children: [
                        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: Text(getTranslated('dont_miss_the_chance', context)??'',
                            style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall,
                              color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                              Theme.of(context).hintColor : Theme.of(context).primaryColor),),
                        ),

                        Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                          child: Text(getTranslated('lets_shopping_today', context)??'',
                            style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                              color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                              Theme.of(context).hintColor : Theme.of(context).primaryColor)))]
                      ) :

                      Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault,
                          top: Dimensions.paddingSizeExtraSmall),
                        child: Text(getTranslated('deal_of_the_day', context)??'',
                          style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                            color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                            Theme.of(context).hintColor : Theme.of(context).primaryColor),),),


                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius:  const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                                  color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                  Theme.of(context).highlightColor : Theme.of(context).highlightColor
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    recommended.recommendedProduct !=null && recommended.recommendedProduct!.thumbnail !=null?
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).highlightColor,
                                        border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.5), width: .5),
                                        borderRadius: const BorderRadius.all(Radius.circular(5))
                                      ),
                                        child: LayoutBuilder(builder: (context, boxConstraint)=> ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                          child: Stack(
                                            children: [
                                              CustomImageWidget(
                                                height: ResponsiveHelper.isTab(context) ? 250 : 100,
                                                width: ResponsiveHelper.isTab(context) ? 230 : 100,
                                                image: '${recommended.recommendedProduct?.thumbnailFullUrl?.path}',
                                              ),

                                              if(recommended.recommendedProduct!.currentStock! == 0 &&
                                                  recommended.recommendedProduct!.productType == 'physical')
                                                Positioned.fill(child: Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    width: ResponsiveHelper.isTab(context) ? 230 : size.width * 0.4,
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
                                      )) : const SizedBox(),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                    Expanded(
                                      child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          if((recommended.recommendedProduct?.reviewCount ?? 0) < 0 || double.parse(ratting!) > 0 )...[
                                            Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center, children: [
                                              Icon(Icons.star, color: Provider.of<ThemeController>(context).darkTheme ?
                                              Colors.white : Colors.orange, size: 12),

                                              Text(double.parse(ratting!).toStringAsFixed(1),
                                                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)
                                              ),

                                              Text('(${ recommended.recommendedProduct?.reviewCount ?? '0'})', style:
                                              textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                                  color: Theme.of(context).hintColor)),
                                            ]),
                                          ],

                                          SizedBox(width: MediaQuery.of(context).size.width / 2.5,
                                            child: Text(recommended.recommendedProduct!.name??'',maxLines: 2, overflow: TextOverflow.ellipsis,
                                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color ))
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  recommended.recommendedProduct !=null && recommended.recommendedProduct!.discount!= null &&
                                                      recommended.recommendedProduct!.discount! > 0 || (recommended.recommendedProduct?.clearanceSale?.discountAmount ?? 0) > 0 ?
                                                  Text(
                                                    PriceConverter.convertPrice(context, recommended.recommendedProduct!.unitPrice),
                                                    style: textRegular.copyWith(color: Theme.of(context).hintColor,
                                                      decoration: TextDecoration.lineThrough, fontSize: Dimensions.fontSizeSmall,),
                                                  ) : const SizedBox.shrink(),
                                                  const SizedBox(height: Dimensions.paddingSizeExtraExtraSmall,
                                                      width: Dimensions.paddingSizeExtraSmall),

                                                  recommended.recommendedProduct != null && recommended.recommendedProduct!.unitPrice != null?
                                                  Text(
                                                    PriceConverter.convertPrice(context, recommended.recommendedProduct!.unitPrice,
                                                    discountType: (recommended.recommendedProduct?.clearanceSale?.discountAmount ?? 0) > 0
                                                      ? recommended.recommendedProduct?.clearanceSale?.discountType
                                                      : recommended.recommendedProduct?.discountType,

                                                    discount: (recommended.recommendedProduct?.clearanceSale?.discountAmount ?? 0) > 0
                                                       ?  recommended.recommendedProduct?.clearanceSale?.discountAmount
                                                       : recommended.recommendedProduct?.discount),
                                                    style: textBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color,
                                                      fontSize: Dimensions.fontSizeDefault)) : const SizedBox(),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Positioned(top: 8, right: isLtr ? 10 : null, left: !isLtr ? 10 : null, child: FavouriteButtonWidget(
                                backgroundColor:  Provider.of<ThemeController>(context).darkTheme ?
                                Theme.of(context).cardColor : Theme.of(context).primaryColor,
                                productId: recommended.recommendedProduct?.id)
                              ),


                              recommended.recommendedProduct !=null && recommended.recommendedProduct!.discount!= null &&
                                  ((recommended.recommendedProduct!.discount! > 0) || (recommended.recommendedProduct?.clearanceSale?.discountAmount ?? 0) > 0)  ?
                              DiscountTagWidget(
                                productModel: recommended.recommendedProduct!,
                                positionedTop: 0,
                                topLeftBorderRadius: Dimensions.radiusDefault,
                                bottomRightBorderRadius: Dimensions.radiusDefault
                              ) : const SizedBox.shrink(),


                              Positioned(
                                bottom: 10,
                                right: isLtr ? 10 : null,
                                left: isLtr ? null : 10,

                                child: Container(width: 110,height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeOverLarge)),
                                    color: Theme.of(context).primaryColor),
                                  child: Center(child: Text(getTranslated('grab_this_deal', context)!,
                                    style: titleRegular.copyWith(color: Theme.of(context).colorScheme.secondaryContainer, fontSize: Dimensions.fontSizeDefault)))
                                )
                              )


                            ],
                          ),
                        ),


                    ],
                  ),
                ],
              ),
            ) : const SizedBox() : const RecommendedProductShimmer();
          },
        ),
      ],
      ),
    );
  }
}

