import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/shipping_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/color_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class OfflinePaymentSection extends StatefulWidget {
  final OrderDetailsController orderProvider;

  const OfflinePaymentSection({
    super.key,
    required this.orderProvider,
  });

  @override
  State<OfflinePaymentSection> createState() =>
      _OfflinePaymentSectionState();
}

class _OfflinePaymentSectionState extends State<OfflinePaymentSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final info =
        widget.orderProvider.orderDetails?[0].order?.offlinePayments;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  getTranslated('see_payment_details', context) ?? '',
                  style: textMedium.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeEight),


          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
            firstChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                borderRadius:
                BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated('offline_payment_info', context) ?? '',
                    style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: info?.infoKey?.length ?? 0,
                    itemBuilder: (context, index) {
                      String key = info?.infoKey?[index] ?? '';
                      String value = info?.infoValue?[index] ?? '';

                      String fittedKey =
                      key.replaceAll('_', ' ').capitalize();

                      if (fittedKey.toLowerCase() == 'method id') {
                        return const SizedBox();
                      }

                      return PaymentItemCard(
                        leftValue: fittedKey,
                        rightValue: value,
                      );
                    },
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox(),
          ),
        ],
      ),
    );
  }
}


class CustomerPaymentSection extends StatefulWidget {
  final OrderDetailsController orderProvider;

  const CustomerPaymentSection({
    super.key,
    required this.orderProvider,
  });

  @override
  State<CustomerPaymentSection> createState() =>
      _CustomerPaymentSectionState();
}

class _CustomerPaymentSectionState
    extends State<CustomerPaymentSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final info = widget.orderProvider.orderDetails?[0].latestEditHistory?.orderDuePaymentInfo;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  getTranslated('see_payment_details', context) ?? '',
                  style: textMedium.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeEight),


          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _isExpanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
            firstChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                borderRadius:
                BorderRadius.circular(Dimensions.radiusDefault),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated('customer_payment_info', context) ?? '',
                    style: textMedium.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: info?.infoKey?.length ?? 0,
                    itemBuilder: (context, index) {
                      String key = info?.infoKey?[index] ?? '';
                      String value = info?.infoValue?[index] ?? '';

                      String fittedKey =
                      key.replaceAll('_', ' ').capitalize();

                      if (fittedKey.toLowerCase() == 'method id') {
                        return const SizedBox();
                      }

                      return PaymentItemCard(
                        leftValue: fittedKey,
                        rightValue: value,
                      );
                    },
                  ),
                ],
              ),
            ),

            secondChild: const SizedBox(),
          ),
        ],
      ),
    );
  }
}


class PaymentItemCard extends StatelessWidget {
  final String leftValue;
  final String rightValue;
  const PaymentItemCard({super.key, required this.leftValue, required this.rightValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$leftValue  : ', style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium!.color )),
        Expanded(child: Text(rightValue,style: textMedium.copyWith(color: ColorHelper.blendColors(Colors.white, Theme.of(context).textTheme.bodyLarge!.color!, 0.9), fontSize: Dimensions.fontSizeDefault),)),
      ],
      ),
    );
  }
}