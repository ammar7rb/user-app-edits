import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';

class OrderProductListWidget extends StatelessWidget {
  final String? orderType;
  final String? orderId;
  final bool fromTrack;
  final int? isGuest;
  const OrderProductListWidget({super.key, this.orderType,  this.fromTrack = false, this.isGuest, this.orderId});

  @override
  Widget build(BuildContext context) {
    return  Consumer<OrderDetailsController>(
      builder: (context, orderDetailsController, _) {

        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          itemCount:
          orderDetailsController.orderDetails?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) => OrderDetailsWidget(
            orderDetailsModel: orderDetailsController.orderDetails![i],
            isGuest: isGuest,
            fromTrack: fromTrack,
            callback: () {
              showCustomSnackBarWidget(getTranslated('review_submitted_successfully', context), context, snackBarType: SnackBarType.success);
            },
            orderType: orderType!,
            paymentStatus: orderDetailsController.orders!.paymentStatus!,
            orderId: orderId!,
            index: i,
          ),
        );
      }
    );
  }
}
