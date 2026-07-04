import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class OrderPaymentInfoWidget extends StatelessWidget {
  const OrderPaymentInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsController>(
      builder: (context, orderProvider, child) {
        ConfigModel? configModel = Provider.of<SplashController>(context, listen: false).configModel;

        return Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.2), spreadRadius:1.5, blurRadius: 3)],
            color: Theme.of(context).cardColor,
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault),

                if(configModel?.orderVerification == 1 && orderProvider.orders!.orderType != 'POS')...[
                  Container(
                    color: Theme.of(context).cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated('order_verification_code', context) ?? '',
                          style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                        ),

                        Text(
                          orderProvider.orders?.verificationCode ?? '',
                          style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)
                        ),
                      ],
                    ),
                  ),

                  if(configModel?.orderVerification == 1 && orderProvider.orders!.orderType != 'POS')
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                  SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
                ],


                if(configModel?.orderVerification == 1 && orderProvider.orders!.orderType != 'POS')
                  const SizedBox(height: Dimensions.paddingSizeSmall),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        getTranslated('order_date_details', context) ?? '',
                        style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                    ),

                    Text(
                      DateConverter.localDateToIsoStringAMPMOrder(DateTime.parse(orderProvider.orders!.createdAt!)),
                      style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeDefault)
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
                const SizedBox(height: Dimensions.paddingSizeSmall),



                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTranslated('order_type', context) ?? '',
                      style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Text(
                          orderProvider.orders!.orderType == 'POS' ?
                          getTranslated('pos_order_small', context) ?? '' :
                          getTranslated('regular', context) ?? ' ',
                          style: textMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
                const SizedBox(height: Dimensions.paddingSizeSmall),



                ///todo: remove payment status and method from here as per new design
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       getTranslated('payment_status_title', context) ?? '',
                //       style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                //     ),
                //
                //     Text((orderProvider.orders?.paymentStatus != null && orderProvider.orders!.paymentStatus!.isNotEmpty) ?
                //     getTranslated(orderProvider.orders!.paymentStatus, context) ?? orderProvider.orders!.paymentStatus!
                //       : 'Digital Payment',
                //       style: titilliumSemiBold.copyWith(
                //         fontSize: Dimensions.fontSizeDefault,
                //         color: orderProvider.orders?.paymentStatus == 'paid' ?
                //         Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.error
                //       )
                //     )
                //   ],
                // ),
                // const SizedBox(height: Dimensions.paddingSizeSmall),
                // SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
                // const SizedBox(height: Dimensions.paddingSizeSmall),
                //
                //
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       getTranslated('payment_method', context) ?? '',
                //       style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                //     ),
                //
                //     Text(orderProvider.orders!.paymentMethod!.replaceAll('_', ' ').capitalize(),
                //         style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)
                //     )
                //   ],
                // ),
                // const SizedBox(height: Dimensions.paddingSizeSmall),
                // SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),
                // const SizedBox(height: Dimensions.paddingSizeSmall),





                if(orderProvider.orders?.bringChangeAmount != null && orderProvider.orders!.bringChangeAmount! > 0)...[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.2), spreadRadius:3, blurRadius: 3)],
                      color: Theme.of(context).cardColor,
                    ),
                    padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated('change_request', context) ?? '',
                          style: textBold.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                        ),
                        SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
                          ),
                          child:  RichText(text: TextSpan(children: [
                            TextSpan(text: getTranslated('please_bring', context),
                              style: titilliumRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.titleLarge?.color,
                                fontWeight: FontWeight.w400,
                              ),
                            ),


                            TextSpan(text: '${PriceConverter.convertPrice(context, orderProvider.orders?.bringChangeAmount ?? 0)} ',
                              style: titilliumBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.titleLarge?.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            TextSpan(text: getTranslated('in_change_when_making_the_delivery', context),
                              style: titilliumRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.titleLarge?.color,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                          ])
                          ),
                        )



                      ],
                    )
                  ),
                  SizedBox(height: Dimensions.paddingSizeDefault),
                ]

              ],
            ),
          ),
        );
      }
    );
  }
}
