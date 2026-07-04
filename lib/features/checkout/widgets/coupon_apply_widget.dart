import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/controllers/coupon_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/coupon_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

class CouponApplyWidget extends StatelessWidget {
  final TextEditingController couponController;
  final double orderAmount;
  const CouponApplyWidget({super.key, required this.couponController, required this.orderAmount});

  @override
  Widget build(BuildContext context) {
    return Consumer<CouponController>(
      builder: (context, couponProvider, _) {
        return Padding(padding: const EdgeInsets.only(left:0),

          child: Container(width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color:Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.2), spreadRadius:3, blurRadius: 3)],
            ),

            child: (couponProvider.discount != null && couponProvider.discount != 0)?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomAssetImageWidget(Images.addCouponIcon, height: 20, width: 20,),
                      SizedBox(width: Dimensions.paddingSizeDefault),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Dimensions.paddingSizeSmall),

                          Text(
                            '${getTranslated('coupon_applied', context)}',
                            style: textMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                  couponProvider.couponCode,
                                  style: textRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).textTheme.titleMedium?.color,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                  '(-${PriceConverter.convertPrice(context, couponProvider.discount)} off)',
                                  style: textBold.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: Dimensions.paddingSizeSmall),
                        ],
                      ),
                    ],
                  ),

                  InkWell(
                    onTap: ()=> couponProvider.removeCoupon(),
                    child: Icon(Icons.clear, size: 20, color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
            ):


            InkWell(onTap: ()=> showModalBottomSheet(context: context,
              isScrollControlled: true, backgroundColor: Colors.transparent,
              builder: (c) =>   CouponBottomSheetWidget(orderAmount: orderAmount)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomAssetImageWidget(Images.addCouponIcon, height: 20, width: 20,),
                        SizedBox(width: Dimensions.paddingSizeSmall),

                        Text(
                          '${getTranslated('add_coupon', context)}',
                          style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      '${getTranslated('add_more', context)}',
                      style: textMedium.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
