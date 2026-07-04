
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wallet/controllers/wallet_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/custom_check_box_widget.dart';
import 'package:provider/provider.dart';


class AddFundDialogueWidget extends StatelessWidget {
  const AddFundDialogueWidget({super.key, required this.focusNode, required this.inputAmountController});
  final FocusNode focusNode;
  final TextEditingController inputAmountController;

  @override
  Widget build(BuildContext context) {

    return Material(color: Colors.transparent,
      child: Center(
        child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeEight),
          child: Consumer<CheckoutController>(
            builder: (context, digitalPaymentProvider,_) {
              return Consumer<SplashController>(
                builder: (context, configProvider,_) {
                  return SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Stack(
                        children: [
                          Container(decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
                            child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
                                Dimensions.paddingSizeExtraLarge, Dimensions.paddingSizeSmall,
                                Dimensions.paddingSizeDefault),
                              child: Column(children: [
                                Text(getTranslated('add_fund_to_wallet', context)!,
                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall,
                                    bottom: Dimensions.paddingSizeDefault),
                                    child: Text(getTranslated('add_fund_form_secured_digital_payment_gateways', context)!,
                                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5)), textAlign: TextAlign.center)),

                                Container(
                                  padding: const EdgeInsets.all(Dimensions.homePagePadding),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).hintColor.withValues(alpha: 0.20),
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeTwelve),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: TextField(
                                          controller: inputAmountController,
                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: 'Ex 150',
                                            hintStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.only(left: Dimensions.homePagePadding, right: Dimensions.paddingSizeEight),
                                              child: Text(
                                                configProvider.myCurrency?.symbol ?? '\$',
                                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                                              ),
                                            ),
                                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeTwelve),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Theme.of(context).cardColor,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeDefaultAddress),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: Dimensions.paddingSizeEight),

                                      Text(
                                        getTranslated('min_max_add_fund_amount', context)!.replaceAll('{min}', PriceConverter.convertPrice(context, configProvider.configModel?.minimumAddFundAmount)).replaceAll('{max}', PriceConverter.convertPrice(context, configProvider.configModel?.maximumAddFundAmount ?? double.infinity)),
                                        textAlign: TextAlign.center,
                                        style: textRegular,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).hintColor, width: 1),
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeTwelve),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: Dimensions.paddingSizeSmall,
                                          top: Dimensions.paddingSizeDefault,
                                          left: Dimensions.paddingSizeDefault,
                                          right: Dimensions.paddingSizeDefault,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              getTranslated('add_money_via_online', context)!,
                                              style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                                            ),
                                            Expanded(
                                              child: Text(
                                                getTranslated('fast_and_secure', context)!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: textRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeExtraSmall,
                                                  color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Payment Methods List
                                      Consumer<SplashController>(
                                        builder: (context, configProvider, _) {
                                          return ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: configProvider.configModel?.paymentMethods?.length ?? 0,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final method = configProvider.configModel!.paymentMethods![index];
                                              return CustomCheckBoxWidget(
                                                index: index,
                                                icon: '${configProvider.configModel?.paymentMethodImagePath}/${method.additionalDatas?.gatewayImage ?? ''}',
                                                name: method.keyName ?? '',
                                                title: method.additionalDatas?.gatewayTitle ?? '',
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                  child: CustomButton(
                                    buttonText: getTranslated('add_fund', context)!,
                                    onTap: () {
                                      if(digitalPaymentProvider.selectedDigitalPaymentMethodName.isEmpty) {
                                        digitalPaymentProvider.setDigitalPaymentMethodName(0,
                                            configProvider.configModel!.paymentMethods![0].keyName!);
                                      }
                                      if(inputAmountController.text.trim().isEmpty){
                                        showCustomSnackBarWidget(getTranslated('please_input_amount', context), context, snackBarType: SnackBarType.warning);
                                      }else if(double.parse(inputAmountController.text.trim()) <= 0){
                                        showCustomSnackBarWidget(getTranslated('please_input_amount', context), context, snackBarType: SnackBarType.warning);
                                      }else if(digitalPaymentProvider.paymentMethodIndex == -1){
                                        showCustomSnackBarWidget(getTranslated('please_select_any_payment_type', context), context, snackBarType: SnackBarType.warning);
                                      }else{
                                        Provider.of<WalletController>(context, listen: false).addFundToWallet(
                                          inputAmountController.text.trim(),
                                          digitalPaymentProvider.selectedDigitalPaymentMethodName,
                                        ).then((response){
                                          inputAmountController.clear();
                                          Navigator.pop(Get.context!);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withValues(alpha: 0.20),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                child: Icon(Icons.close, size: Dimensions.iconSizeSmall, color: Theme.of(context).hintColor),
                              ),
                            ),
                          ),
                        ]
                      ),
                    ],),
                  );
                }
              );
            }
          ),
        ),
      ),
    );
  }
}