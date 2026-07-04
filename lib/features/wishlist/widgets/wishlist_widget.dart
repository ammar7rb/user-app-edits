import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/discount_tag_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/domain/models/wishlist_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/widgets/remove_from_wishlist_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';

class WishListWidget extends StatelessWidget {
  final WishlistModel? wishlistModel;
  final int? index;
  const WishListWidget({super.key, this.wishlistModel, this.index});

  @override
  Widget build(BuildContext context) {
    double ratting = (wishlistModel?.productFullInfo?.reviewsAvgRating != null) ?  double.parse('${wishlistModel?.productFullInfo?.reviewsAvgRating}') : 0;

    bool hasDiscount() => (wishlistModel?.productFullInfo != null &&  wishlistModel?.productFullInfo?.discount != null && (wishlistModel?.productFullInfo?.discount ?? 0) > 0) || (wishlistModel?.productFullInfo?.clearanceSale?.discountAmount ?? 0) > 0;
    return InkWell(
      onTap: () {
        RouterHelper.getProductDetailsRoute(
          action: RouteAction.push,
          productId: wishlistModel?.productFullInfo?.id,
          slug: wishlistModel?.productFullInfo?.slug,
          isFromWishList: true,
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.05),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 1)
                ),
              ],
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            ),

            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0, right: 5,
                    child: InkWell(
                      onTap: () {
                        RouterHelper.getProductDetailsRoute(
                          action: RouteAction.push,
                          productId: wishlistModel?.productFullInfo?.id,
                          slug: wishlistModel?.productFullInfo?.slug,
                          isFromWishList: true,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeEight),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                        ),
                        child: Icon(Icons.shopping_cart, color: Theme.of(context).primaryColor, size: Dimensions.paddingSizeLarge),
                      ),
                    ),
                  ),



                  Row(mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                            border: Border.all(width: 1, color: Colors.black.withValues(alpha: 0.1)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                            child: CustomImageWidget(
                              width: 70,
                              height: 70,
                              image: '${wishlistModel?.productFullInfo?.thumbnailFullUrl?.path}',
                            ),
                          ),
                        ),

                        if((wishlistModel?.productFullInfo?.currentStock ?? 0) < 1)
                          Positioned.fill(child: Align(alignment: Alignment.center,
                            child: Stack(children: [
                              Container(decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.30),
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                              )),

                              Center(child: Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                  getTranslated('stock_out', context)!,
                                  textAlign: TextAlign.center,
                                  style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                ),
                              ))
                            ]),
                          )),

                          if(hasDiscount())
                            DiscountTagWidget(productModel: wishlistModel!.productFullInfo! , positionedTop: 0, topLeftBorderRadius: Dimensions.radiusDefault, bottomRightBorderRadius: Dimensions.radiusDefault)
                      ]),


                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(
                            wishlistModel?.productFullInfo?.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                          )),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context, builder: (_) => RemoveFromWishlistBottomSheet(
                                productId : wishlistModel?.productFullInfo?.id, index: index)
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeEight),
                              child: CustomAssetImageWidget(Images.delete, color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Row(children: [
                          (hasDiscount()) ?
                          CustomDirectionalityWidget(
                            child: Text(
                              wishlistModel?.productFullInfo?.unitPrice != null ?
                              PriceConverter.convertPrice(context, wishlistModel?.productFullInfo?.unitPrice) : '',
                              style: titilliumSemiBold.copyWith(
                                color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                              ),
                            ),
                          ) : const SizedBox(),


                          (hasDiscount()) ?
                          const SizedBox(width: Dimensions.paddingSizeSmall) : const SizedBox(),

                          Flexible(child: CustomDirectionalityWidget(
                            child: Text(
                              _getProductPrice(context),
                              style: robotoBold.copyWith(color: Theme.of(context).primaryColor),
                            ),
                          )),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        if(ratting > 0) Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          const Icon(Icons.star_rate_rounded, color: Colors.orange, size: Dimensions.paddingSizeDefault),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Text(ratting.toStringAsFixed(1), style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            )),
                          ),

                          Text('(${PriceConverter.longToShortPrice(wishlistModel?.productFullInfo?.reviewCount?.toDouble() ?? 0, withDecimalPoint: false)})',
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                          ),
                        ]),

                        const Spacer(),
                      ])),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }



  String _getProductPrice(BuildContext context) {
    return PriceConverter.convertPrice(
      context, wishlistModel?.productFullInfo?.unitPrice,
      discountType: (wishlistModel?.productFullInfo?.clearanceSale?.discountAmount ?? 0)  > 0
        ? wishlistModel?.productFullInfo?.clearanceSale?.discountType
        : wishlistModel?.productFullInfo?.discountType,
      discount: (wishlistModel!.productFullInfo?.clearanceSale?.discountAmount ?? 0)  > 0
        ? wishlistModel?.productFullInfo?.clearanceSale?.discountAmount
        : wishlistModel?.productFullInfo?.discount,
    );
  }

}