import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/refund_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class RefundProductBottomSheetWidget extends StatefulWidget {

  final String? title;
  final String? description;
  final String? orderID;

  const RefundProductBottomSheetWidget({
    super.key,
    required this.title,
    required this.description,
    this.orderID,
  });

  @override
  State<RefundProductBottomSheetWidget> createState() => _RefundProductBottomSheetWidgetState();
}

class _RefundProductBottomSheetWidgetState extends State<RefundProductBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 200,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeDefault,
          horizontal: Dimensions.paddingSizeDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 30,
                  width: 30,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: Theme.of(context).textTheme.titleMedium!.color,
                  ),
                ),
              ),
            ),

            Text(
              getTranslated('refund_request', context)!,
              style: titilliumBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            Text(
              getTranslated('choose_the_item', context)!,
              style: titleRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),


            Expanded(
              child: Consumer<OrderDetailsController>(
                builder: (context, orderDetailsController, _) {
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: orderDetailsController.orderDetails?.length ?? 0,
                    itemBuilder: (context, i) => RefundProductWidget(
                      orderDetailsModel: orderDetailsController.orderDetails![i],
                      fromTrack: false,
                      callback: () {
                        showCustomSnackBarWidget(
                          getTranslated('review_submitted_successfully', context),
                          context,
                          snackBarType: SnackBarType.success,
                        );
                      },
                      orderType: orderDetailsController.orders!.orderType!,
                      paymentStatus: orderDetailsController.orders!.paymentStatus!,
                      orderId: orderDetailsController.orderDetails!.first.orderId.toString(),
                      index: i,
                    ),
                    separatorBuilder: (_, index) => const SizedBox(
                      height: Dimensions.paddingSizeSmall,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );


  }
}
