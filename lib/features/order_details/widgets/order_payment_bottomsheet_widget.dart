import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/wallet_payment_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/offline_payment/domain/models/offline_payment_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class OrderPaymentMethodBottomSheetWidget extends StatefulWidget {
  final String orderId;
  final double payableAmount;
  final bool onlyDigital;
  const OrderPaymentMethodBottomSheetWidget({super.key, required this.onlyDigital, required this.orderId, required this.payableAmount});
  @override
  OrderPaymentMethodBottomSheetWidgetState createState() => OrderPaymentMethodBottomSheetWidgetState();
}

class OrderPaymentMethodBottomSheetWidgetState extends State<OrderPaymentMethodBottomSheetWidget> {
  String? _orderId;
  final TextEditingController changeAmountTextController = TextEditingController();
  final ConfigModel? configModel = Provider.of<SplashController>(Get.context!, listen: false).configModel;
  CheckoutController checkoutController = Provider.of<CheckoutController>(Get.context!, listen: false);

  @override
  void initState() {
    changeAmountTextController.text = '${Provider.of<CheckoutController>(context, listen: false).cashChangesAmount ?? ''}';
    if((configModel?.cashOnDelivery ?? false) && !widget.onlyDigital && !checkoutController.isCODChecked) {
      checkoutController.setOfflineChecked('cod', notify: false);
    }
    _orderId = widget.orderId;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final ConfigModel? configModel = Provider.of<SplashController>(context, listen: false).configModel;
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;

    return Consumer<CheckoutController>(
      builder: (context, checkoutController, _) {
        return Consumer<OrderDetailsController>(
          builder: (context, orderDetailsController, _) {
            return PopScope(
              onPopInvokedWithResult: (_, __){

              },
              child: Container(constraints : BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7,
                  minHeight: MediaQuery.of(context).size.height * 0.5),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),

                child: Column(mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                            child: Center(child: Container(width: 35,height: 4,decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                              color: Theme.of(context).hintColor.withValues(alpha:.5))))
                          ),

                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                getTranslated('choose_payment_method', context)??'',
                                style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                              ),

                              Expanded(child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                  '${getTranslated('click_one_of_the_option_below', context)}',
                                  style: textRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                                ),
                              )),
                            ]),
                          ),


                          _isPaymentMethodsAvailable(Get.context!, checkoutController.offlinePaymentModel?.offlineMethods) ?
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min, children: [
                              Row(children: [
                                if((configModel?.cashOnDelivery ?? false) && !widget.onlyDigital) Expanded(child: CustomButton(
                                  isBorder: true,
                                  leftIcon: Images.cod,
                                  backgroundColor: orderDetailsController.isCODChecked? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                  textColor:  orderDetailsController.isCODChecked? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                                  fontSize: Dimensions.fontSizeSmall,
                                  onTap: () => orderDetailsController.setOfflineChecked('cod'),
                                  buttonText: '${getTranslated('cash_on_delivery', context)}',
                                )),
                                const SizedBox(width: Dimensions.paddingSizeDefault),

                                if(configModel?.walletStatus == 1 && Provider.of<AuthController>(context, listen: false).isLoggedIn())
                                  Expanded(child: CustomButton(
                                    onTap: () => orderDetailsController.setOfflineChecked('wallet'),
                                    isBorder: true,
                                    leftIcon: Images.payWallet,
                                    backgroundColor: orderDetailsController.isWalletChecked ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                    textColor:  orderDetailsController.isWalletChecked? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                                    fontSize: Dimensions.fontSizeSmall,
                                    buttonText: '${getTranslated('pay_via_wallet', context)}',
                                  )),
                              ]),


                              ///change amount
                              ChangeAmountWidget(changeAmountTextController: changeAmountTextController),


                              if((configModel?.digitalPayment ?? false) && (configModel?.paymentMethods?.isNotEmpty ?? false) && !checkoutController.isCODChecked)
                                SizedBox(height: Dimensions.paddingSizeSmall),


                              if((configModel?.digitalPayment ?? false) && (configModel?.paymentMethods?.isNotEmpty ?? false))
                                Container(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    border: Border.all(width: 1, color: Theme.of(context).hintColor.withValues(alpha: .125),
                                    ),
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                  ),

                                  child: Column(
                                    children: [
                                      if((configModel?.digitalPayment ?? false) && (configModel?.paymentMethods?.isNotEmpty ?? false))
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeDefault),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${getTranslated('pay_via_online', context)}', style: titilliumBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                            ],
                                          ),
                                        ),

                                      if((configModel?.digitalPayment ?? false) && (configModel?.paymentMethods?.isNotEmpty ?? false))
                                        Consumer<SplashController>(builder: (context, configProvider,_) {
                                          return ListView.separated(
                                            padding: EdgeInsets.zero,
                                            itemCount: configProvider.configModel?.paymentMethods?.length??0,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return  CustomCheckBoxWidget(
                                                index: index, padding: 0,
                                                icon: '${configProvider.configModel?.paymentMethodImagePath}/'
                                                  '${configProvider.configModel?.paymentMethods?[index].additionalDatas?.gatewayImage??''}',
                                                name: configProvider.configModel!.paymentMethods![index].keyName!,
                                                title: configProvider.configModel!.paymentMethods![index].additionalDatas?.gatewayTitle??'',
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return SizedBox(height: Dimensions.paddingSizeSmall);
                                            },
                                          );
                                        }),

                                    ],
                                  ),
                                ),

                              if((configModel?.digitalPayment ?? false) && (configModel?.paymentMethods?.isNotEmpty ?? false))
                                SizedBox(height: Dimensions.paddingSizeSmall),



                              if(configModel?.offlinePayment != null && (checkoutController.offlinePaymentModel?.offlineMethods?.isNotEmpty ?? false))
                                Container(
                                  decoration: BoxDecoration(
                                    color: checkoutController.isOfflineChecked?Theme.of(context).primaryColor.withValues(alpha:.15): null,
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  ),
                                  child: Column(children: [

                                    InkWell(
                                      onTap: () {
                                        if(checkoutController.offlinePaymentModel?.offlineMethods != null && checkoutController.offlinePaymentModel!.offlineMethods!.isNotEmpty) {
                                          orderDetailsController.setOfflineChecked('offline');
                                          checkoutController.setOfflineChecked('offline');
                                        }
                                      },
                                      child: Padding(padding: const EdgeInsets.all(8.0), child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                                        child: Row(children: [
                                          Theme(
                                            data: Theme.of(context).copyWith(unselectedWidgetColor: Theme.of(context).primaryColor.withValues(alpha:.25)),
                                            child: Checkbox(
                                              visualDensity: VisualDensity.compact,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge)),
                                              checkColor: Colors.white,
                                              value: orderDetailsController.isOfflineChecked, activeColor: Colors.green,
                                              onChanged: (bool? isChecked) {
                                                if(checkoutController.offlinePaymentModel?.offlineMethods?.isNotEmpty ?? false){
                                                  checkoutController.setOfflineChecked('offline', notify: true);
                                                  orderDetailsController.setOfflineChecked('offline', notify: true);
                                                }},
                                            ),
                                          ),

                                          Text('${getTranslated('pay_offline', context)}', style: textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                        ]),
                                      )),
                                    ),


                                    if((checkoutController.offlinePaymentModel?.offlineMethods?.isNotEmpty ?? false) && checkoutController.isOfflineChecked)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: isLtr ? Dimensions.paddingSizeDefault : 0,
                                          bottom: Dimensions.paddingSizeDefault,
                                          right: isLtr ? 0 : Dimensions.paddingSizeDefault,
                                          top: Dimensions.paddingSizeSmall,
                                        ),
                                        child: SizedBox(height: 40, child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: checkoutController.offlinePaymentModel!.offlineMethods!.length,
                                          itemBuilder: (context, index){
                                            return InkWell(
                                              onTap: () {
                                                if(checkoutController.offlinePaymentModel?.offlineMethods?.isNotEmpty ?? false) {
                                                  orderDetailsController.setOfflinePaymentMethodSelectedIndex(index, checkoutController.offlinePaymentModel);
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).cardColor,
                                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                                    border: orderDetailsController.offlineMethodSelectedIndex == index
                                                      ? Border.all(color: Theme.of(context).primaryColor, width: 1)
                                                      : Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.5), width: .25),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                                    child: Center(child: Text(checkoutController.offlinePaymentModel?.offlineMethods?[index].methodName ??'')),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                      ),
                                  ])
                                ),

                            ],
                          ) : const NoInternetOrDataScreenWidget(isNoInternet: false, message: 'no_payment_method_available_right_now',),

                        ]),
                      ),
                    ),

                    CustomButton(
                      isLoading: orderDetailsController.isLoading,
                      buttonText: '${getTranslated('proceed_text', context)}',
                      onTap: () async {
                        if(orderDetailsController.isCODChecked) {
                          await orderDetailsController.duePaymentByCod(int.parse(widget.orderId), 'cash_on_delivery', changeAmountTextController.text);
                        } else if (orderDetailsController.paymentMethodIndex != -1) {
                          await orderDetailsController.duePaymentByDigitalPayment(
                            int.parse(widget.orderId),
                            orderDetailsController.selectedDigitalPaymentMethodName,
                            'cash_on_delivery',
                            ''
                          );
                        } else if (orderDetailsController.isWalletChecked && (Provider.of<ProfileController>(context, listen: false).balance ?? 0) >= widget.payableAmount) {
                          print('--->>122234');
                          // Navigator.of(Get.context!).pop();

                          showDialog(
                            context: context,
                            builder: (context) {
                              return  WalletPaymentWidget(
                              currentBalance: Provider.of<ProfileController>(context, listen: false).balance  ?? 0,
                              orderAmount: widget.payableAmount,
                              onTap: () async {
                                Navigator.of(context).pop();

                                await orderDetailsController.duePaymentByWallet(int.parse(widget.orderId), 'wallet');
                                Navigator.of(Get.context!).pop();
                              });
                            }
                          );
                        } else if (orderDetailsController.isWalletChecked && (Provider.of<ProfileController>(context, listen: false).balance ?? 0) < widget.payableAmount) {
                          showCustomSnackBarWidget('wallet_balance_is_insufficient_to_pay', context, snackBarType: SnackBarType.error);
                        } else if (orderDetailsController.isOfflineChecked) {
                          Navigator.of(context).pop();

                          RouterHelper.getOrderOfflinePaymentScreen(
                            payableAmount: orderDetailsController.orderDetails![0].latestEditHistory!.orderDueAmount!,
                            callback: () {},
                            orderId: int.parse(orderDetailsController.orderDetails![0].orderId.toString()),
                          );
                        }


                        if((configModel?.cashOnDelivery ?? false) && !widget.onlyDigital) {
                          checkoutController.updatePaymentSelection();
                        }


                      },
                    ),

                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}



bool _isPaymentMethodsAvailable(BuildContext context, List<OfflineMethods>? offlineMethods) {
  final ConfigModel? configModel = Provider.of<SplashController>(context, listen: false).configModel;

  bool isCashOnDeliveryOn = configModel?.cashOnDelivery ?? false;
  bool isWalletOn = configModel?.walletStatus == 1 && Provider.of<AuthController>(context, listen: false).isLoggedIn();
  bool isOnlinePaymentMethodsOn = configModel?.paymentMethods?.isNotEmpty ?? false;
  bool isOfflinePaymentMethodsOn = offlineMethods?.isNotEmpty ?? false;

  return isCashOnDeliveryOn || isWalletOn || isOnlinePaymentMethodsOn || isOfflinePaymentMethodsOn;
}



class CustomCheckBoxWidget extends StatelessWidget {
  final int index;
  final bool isDigital;
  final String? icon;
  final String name;
  final String title;
  final double? padding;
  const CustomCheckBoxWidget({super.key,  required this.index, this.isDigital =  false, this.icon, required this.name, required this.title, this.padding});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsController>(
      builder: (context, order, child) {
        return InkWell(onTap: () => order.setDigitalPaymentMethodName(index, name),
          child: Padding(padding: EdgeInsets.all(padding ?? Dimensions.paddingSizeDefault),
            child: Container(
              //padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(height: 40, child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: CustomImageWidget(image : icon!))),

                Expanded(child: Text(title, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color))),


                Theme(data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Provider.of<ThemeController>(context, listen: false).darkTheme?
                  Theme.of(context).hintColor.withValues(alpha:.5) : Theme.of(context).primaryColor.withValues(alpha:.25),),
                    child: Checkbox(visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge)),
                      value: order.paymentMethodIndex == index,
                      activeColor: Colors.green,
                      checkColor: Theme.of(context).cardColor,
                      onChanged: (bool? isChecked) => order.setDigitalPaymentMethodName(index, name)
                    )
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}


class ChangeAmountWidget extends StatefulWidget {
  final TextEditingController changeAmountTextController;
  const ChangeAmountWidget({super.key, required this.changeAmountTextController});

  @override
  State<ChangeAmountWidget> createState() => _ChangeAmountWidgetState();
}

class _ChangeAmountWidgetState extends State<ChangeAmountWidget> with SingleTickerProviderStateMixin {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Provider.of<SplashController>(context, listen: false);

    return Selector<OrderDetailsController, bool>(
      selector: (context, orderDetailsController) => orderDetailsController.isCODChecked,
      builder: (context, isCodChecked, _) {
        if (!isCodChecked) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Smooth top-to-bottom open and bottom-to-top close animation
              ClipRect(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter, // ensures animation starts from top
                  child: _isExpanded
                      ? Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withValues(alpha: .05),
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).hintColor.withValues(alpha: .125),
                      ),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text(
                            getTranslated('change_amount', context) ?? '',
                            style: textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                          Text(
                            ' (${splashController.myCurrency?.symbol ?? ''})',
                            style: titilliumSemiBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Text(
                          getTranslated('insert_amount_if_you_need', context) ?? '',
                          style: textRegular.copyWith(
                            color: Theme.of(context).hintColor,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        SizedBox(
                          height: 40,
                          child: Center(
                            child: TextField(
                              controller: widget.changeAmountTextController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,' +
                                      (splashController.configModel?.decimalPointSettings ?? 0).toString() +
                                      r'}$'),
                                ),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).highlightColor,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).hintColor.withValues(alpha: .5),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).hintColor.withValues(alpha: .5),
                                    width: 1,
                                  ),
                                ),
                                hintText: getTranslated('amount', context) ?? '',
                                hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeExtraSmall,
                                  horizontal: Dimensions.paddingSizeDefault,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ),

              const SizedBox(height: 10),

              // Center-aligned See More / See Less
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isExpanded
                          ? getTranslated('see_less', context) ?? 'See Less'
                          : getTranslated('see_more', context) ?? 'See More',
                      style: textMedium.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}