import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/refund_product_bottomsheet.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class OrderDetailsStatusWidget extends StatelessWidget {
  final bool isNotification;
  const OrderDetailsStatusWidget({super.key, required this.isNotification});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsController>(
      builder: (context, orderProvider, _) {
        return  Container(
          color: Theme.of(context).cardColor,
          child: Stack(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${getTranslated('order', context)}# ',
                        style: textRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                        children: [
                          TextSpan(
                            text: orderProvider.orders?.id.toString(),
                            style: textBold.copyWith(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: Dimensions.fontSizeLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    RichText(
                      text: TextSpan(
                        text: getTranslated('your_order_is', context),
                        style: titilliumRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).hintColor,
                        ),
                        children: [
                          TextSpan(
                            text: ' ${getTranslated('${orderProvider.orders?.orderStatus}', context)}',
                            style: textBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: orderProvider.orders?.orderStatus == 'delivered'
                                ? Theme.of(context).colorScheme.onTertiaryContainer
                                : orderProvider.orders?.orderStatus == 'pending'
                                  ? Theme.of(context).primaryColor
                                  : orderProvider.orders?.orderStatus == 'confirmed'
                                    ? Theme.of(context).colorScheme.onTertiaryContainer
                                    : orderProvider.orders?.orderStatus == 'processing'
                                      ? Theme.of(context).colorScheme.outline
                                      : ((orderProvider.orders?.orderStatus == 'canceled' || orderProvider.orders?.orderStatus == "failed")
                                        ? Theme.of(context).colorScheme.error
                                        : Theme.of(context).colorScheme.secondary
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            InkWell(
              onTap: () {
                if(isNotification){
                  RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement);
                }else  if(Navigator.of(context).canPop()){
                  Navigator.of(context).pop();
                }else{
                  RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement);
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault, horizontal: 0),
                child: Icon(CupertinoIcons.back),
              ),
            ),

            Positioned(
              right: 0,
              child: Consumer<OrderDetailsController>(
                builder: (context, orderProvider, _) {
                  ConfigModel? configModel = Provider.of<SplashController>(context, listen: false).configModel;



                  return (orderProvider.orders?.orderStatus !='delivered' || (orderProvider.orders!.orderType == 'POS' &&  orderProvider.orders?.orderStatus =='delivered') || showRefundRequest(configModel, orderProvider)
                    ? InkWell(
                      onTap: () {
                        orderProvider.getOrderInvoice(orderProvider.orders!.id.toString(), context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: orderProvider.isInvoiceLoading
                          ? Padding(
                            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: const SizedBox(height: 30, width: 30, child: CircularProgressIndicator(strokeWidth: 1)
                          )) : const Padding(
                            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: CustomAssetImageWidget(Images.downloadInvoice, height: 30, width: 30),
                          ),
                      ),
                    ) :
                    PopupMenuButton<String>(
                    color: Theme.of(context).cardColor,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    ),
                    padding: EdgeInsets.zero,
                    menuPadding: EdgeInsets.zero,
                    offset: const Offset(0, 35),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        color: Theme.of(context).hintColor.withValues(alpha: 0.25),
                      ),
                      child: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        size: 20,
                      ),
                    ),

                    itemBuilder: (BuildContext context) => [
                      if(orderProvider.orders!.orderType != 'POS')
                      PopupMenuItem<String>(
                        value: 'download_invoice',
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${getTranslated('download_invoice_title', context)!} ',
                                style: textRegular,
                              ),

                            Consumer<OrderDetailsController>(
                              builder: (context, orderProvider, _) {
                                return (orderProvider.orders!.orderType != 'POS'
                                  ? InkWell(
                                  onTap: () {
                                    orderProvider.getOrderInvoice(orderProvider.orders!.id.toString(), context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    ),
                                    child: orderProvider.isInvoiceLoading
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                                      : CustomAssetImageWidget(
                                        Images.downloadInvoice,
                                        height: Dimensions.paddingSizeExtraLarge,
                                        width: Dimensions.paddingSizeExtraLarge,
                                      ),
                                  ),
                                ) : SizedBox());
                                }
                              ),
                            ],
                          ),
                        ),
                      ),

                      PopupMenuItem<String>(
                        value: 'refund_request',
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: InkWell(
                            onTap: () {
                              showBottomSheet();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('refund_request', context)!, style: textRegular),
                                CustomAssetImageWidget(
                                  Images.viewRefundRequest,
                                  height: Dimensions.paddingSizeExtraLarge,
                                  width: Dimensions.paddingSizeExtraLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],

                    onSelected: (value) {
                      if (value == 'download_invoice') {
                        // your logic
                      } else if (value == 'refund_request') {
                        // your logic
                      }
                    },
                  )

                  );
                },
              ),
            ),



          ]),
        );
      }
    );
  }

  bool showRefundRequest(ConfigModel? configModel, OrderDetailsController orderDetailsController) => orderDetailsController.orderDetails?.first.order?.status == 'delivered'
    && configModel?.refundDayLimit  == 0
    && !refundRequested(orderDetailsController.orderDetails);

  bool refundRequested (List<OrderDetailsModel>? orderDetails) {
    if(orderDetails == null) return false;

    for(OrderDetailsModel order in orderDetails) {
      if(order.refundReq == 1) {
        return true;
      }
    }
    return false;
  }

}

void showBottomSheet() {
  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: RefundProductBottomSheetWidget(
          title: '',
          description: '',
          orderID: '',

        ),
      );
    },
  );






}
