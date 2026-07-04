import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/cancel_order_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/reorder/controllers/re_order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class CancelAndSupportWidget extends StatelessWidget {
  final Orders? orderModel;
  final bool fromNotification;
  final bool showSupport;
  const CancelAndSupportWidget({super.key, this.orderModel, this.fromNotification = false, this.showSupport = false});

  @override
  Widget build(BuildContext context) {
    final orderDetailsController = Provider.of<OrderDetailsController>(context, listen: true);

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [

      if(showSupport)
        InkWell(
          onTap: () => RouterHelper.getSupportTicketRoute(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.2), spreadRadius:1.5, blurRadius: 3)],
            ),
            child: Row(
              children: [
                CustomAssetImageWidget(Images.supportIcon, width: 35, height: 35),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    text: TextSpan(children: [
                      TextSpan(
                        text: getTranslated('having_trouble_or_can', context),
                        style: titilliumRegular.copyWith(
                          color: Theme.of(context).textTheme.titleMedium?.color,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),

                      TextSpan(
                        text: getTranslated('contact_support', context),
                        style: titilliumRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),

                    ]),
                  ),
                ),

                const SizedBox(width: Dimensions.paddingSizeDefault),
                CustomAssetImageWidget(Images.supportMessageIcon, width: 35, height: 35),
              ],
            ),
          ),
        ),


      if(!showSupport)...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
          child: Column(
            children: [
              (orderModel != null && (orderModel!.customerId! == int.parse(Provider.of<ProfileController>(context, listen: false).userID)) &&
                  (orderModel!.orderStatus == 'pending') && (orderModel!.orderType != "POS")) ?
              CustomButton(textColor: Theme.of(context).colorScheme.error,
                backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha:0.15),
                buttonText: getTranslated('cancel_order', context),
                onTap: () {
                  showDialog(context: context, builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: CancelOrderDialogWidget(orderId: orderModel!.id),
                  ));
                },
              ) :
              (orderModel != null && Provider.of<AuthController>(context, listen: false).isLoggedIn() &&
                  orderModel!.customerId! == int.parse(Provider.of<ProfileController>(context, listen: false).userID) &&
                  orderModel!.orderStatus == 'delivered' && orderModel!.orderType != "POS") ?
              CustomButton(textColor:  Theme.of(context).colorScheme.secondaryContainer,
                  backgroundColor: Theme.of(context).primaryColor,
                  buttonText: getTranslated('re_order', context),
                  onTap: () => Provider.of<ReOrderController>(context, listen: false).reorder(orderId: orderModel?.id.toString())):

              (Provider.of<AuthController>(context, listen: false).isLoggedIn() &&
                  orderModel!.customerId! == int.parse(Provider.of<ProfileController>(context, listen: false).userID) &&
                  orderModel!.orderType != "POS" && (orderModel!.orderStatus != 'canceled' &&
                  orderModel!.orderStatus != 'returned'  && orderModel!.orderStatus != 'fail_to_delivered' )) ?

              CustomButton(buttonText: getTranslated('TRACK_ORDER', context),
                onTap: () =>
                  RouterHelper.getTrackingResultRoute(
                    action: RouteAction.push,
                    orderID: orderModel!.id.toString(),
                  ),
              ) : const SizedBox(),

            ],
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeSmall),
      ],

      ],
    );
  }
}
