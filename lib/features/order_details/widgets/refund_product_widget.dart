import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/refund/controllers/refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/refund/widgets/refund_request_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/refund/widgets/refunded_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class RefundProductWidget extends StatefulWidget {
  final OrderDetailsModel orderDetailsModel;
  final String orderType;
  final String orderId;
  final String paymentStatus;
  final Function callback;
  final bool fromTrack;
  final int index;
  const RefundProductWidget({
    super.key, required this.orderDetailsModel, required this.callback,
    required this.orderType, required this.paymentStatus,  this.fromTrack = false, required this.orderId, required this.index
  });

  @override
  State<RefundProductWidget> createState() => _RefundProductWidgetState();
}

class _RefundProductWidgetState extends State<RefundProductWidget> {


  @override
  void initState() {
    super.initState();
  }


  DigitalVariation? digitalVariation;

  String? downloadMessage;
  File? downloadedFile;

  @override
  Widget build(BuildContext context) {
    ConfigModel? configModel = Provider.of<SplashController>(context, listen: false).configModel;
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;

    if(widget.orderDetailsModel.productDetails != null && widget.orderDetailsModel.variant != null && widget.orderDetailsModel.variant!.isNotEmpty && widget.orderDetailsModel.productDetails?.productType == 'digital') {
      for(DigitalVariation dv in widget.orderDetailsModel.productDetails!.digitalVariation ?? []) {
        if(dv.variantKey == widget.orderDetailsModel.variant){
          digitalVariation = dv;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// --- Product Image ---
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withValues(alpha: .125),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      child: CustomImageWidget(
                        width: 50, height: 50,
                        image: '${widget.orderDetailsModel.productDetails?.thumbnailFullUrl?.path}',
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  /// --- Product Info ---
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// --- Product Name ---
                        InkWell(
                          onTap: () {
                            RouterHelper.getProductDetailsRoute(
                              action: RouteAction.push,
                              productId: widget.orderDetailsModel.productDetails!.id!,
                              slug: widget.orderDetailsModel.productDetails!.slug,
                            );
                          },
                          child: Text(
                            widget.orderDetailsModel.productDetails?.name ?? '',
                            style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: Dimensions.marginSizeExtraSmall),

                        /// --- Quantity ---
                        Text(
                          '${getTranslated('qty', context)}: ${widget.orderDetailsModel.qty}',
                          style: titilliumRegular.copyWith(
                            color: Theme.of(context).textTheme.titleMedium?.color,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                        const SizedBox(height: Dimensions.marginSizeExtraSmall),

                        /// --- Price + Refund (if no variation) ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              PriceConverter.convertPrice(context, widget.orderDetailsModel.price),
                              style: titilliumSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: Dimensions.fontSizeDefault),
                            ),
                            if (widget.orderDetailsModel.variant == null || widget.orderDetailsModel.variant!.isEmpty)
                              _buildRefundButton(context, configModel),
                          ],
                        ),
                        const SizedBox(height: Dimensions.marginSizeExtraSmall),
                        if(widget.orderDetailsModel.variant == null || widget.orderDetailsModel.variant!.isEmpty)
                        SizedBox(height: Dimensions.marginSizeExtraSmall
                        ),


                        /// --- Variation + Refund (if available) ---
                        if (widget.orderDetailsModel.variant != null && widget.orderDetailsModel.variant!.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${getTranslated('variations', context)}: ',
                                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color,),
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.orderDetailsModel.variant!,
                                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildRefundButton(context, configModel),
                            ],
                          ),

                        if(widget.orderDetailsModel.variant != null && widget.orderDetailsModel.variant!.isNotEmpty)
                        SizedBox(height: Dimensions.paddingSizeSmall)



                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// --- Discount Badge ---
          if (widget.orderDetailsModel.discount! > 0 &&
              (widget.orderDetailsModel.productDetails?.discount != null ||
                  widget.orderDetailsModel.productDetails?.clearanceSale != null))
            Positioned(
              top: 25,
              left: isLtr ? 0 : null,
              right: isLtr ? null : 20,
              child: Container(
                height: 20,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraExtraSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(isLtr ? Dimensions.paddingSizeExtraSmall : 0),
                    left: Radius.circular(isLtr ? 0 : Dimensions.paddingSizeExtraSmall),
                  ),
                ),
                child: CustomDirectionalityWidget(
                  child: Text(
                    widget.orderDetailsModel.productDetails?.clearanceSale != null
                      ? PriceConverter.percentageCalculation(context,
                      (widget.orderDetailsModel.price! * widget.orderDetailsModel.qty!),
                      widget.orderDetailsModel.productDetails?.clearanceSale?.discountAmount,
                      widget.orderDetailsModel.productDetails?.clearanceSale?.discountType,
                    ) : PriceConverter.percentageCalculation(
                      context,
                      (widget.orderDetailsModel.price! * widget.orderDetailsModel.qty!),
                      widget.orderDetailsModel.productDetails?.discount,
                      widget.orderDetailsModel.productDetails?.discountType,
                    ),
                    style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildRefundButton(BuildContext context, ConfigModel? configModel) {
    final orderDetails = widget.orderDetailsModel;
    final orderType = widget.orderType;

    return Consumer2<OrderController, RefundController>(
      builder: (context, orderController, refundController, _) {

        bool isLoadingRefund = refundController.isRefund && (orderDetails.id == refundController.getSelectedOrderDetailsId);

        bool canRefund = _canRefundRequest(configModel);

        bool showRefundStatusButton = orderController.orderTypeIndex == 1 &&
          orderDetails.refundReq != 0 && orderType != "POS";

        // --- CASE: Refund Request Button ---
        if (canRefund) {
          return InkWell(
            onTap: isLoadingRefund ? null : () {
              Provider.of<ReviewController>(context, listen: false).removeData();
              refundController.removeRefundDetails();

              refundController.getRefundReqInfo(orderDetails.id).then((value) {
                if (value.response?.statusCode == 200 && context.mounted) {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (_) => RefundRequestWidget(
                        product: orderDetails.productDetails,
                        orderDetailsId: orderDetails.id!,
                        orderId: widget.orderId,
                      ),
                    ),
                  );
                }
              });
            },
            child: isLoadingRefund ? SizedBox(
              height: Dimensions.paddingSizeExtraLarge,
              width: Dimensions.paddingSizeExtraLarge,
              child: Center(
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
              ),
            ) : Container(
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeExtraSmall,
                horizontal: Dimensions.paddingSizeExtraLarge,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              ),
              child: Text(
                getTranslated('req_refund', context)!,
                style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
              ),
            ),
          );
        }


        else if (showRefundStatusButton) {
          bool isLoadingDetails = refundController.isRefund && isRefundDetailButtonPressed(refundController);

          return InkWell(
            onTap: isLoadingDetails ? null : () {
              Provider.of<ReviewController>(context, listen: false).removeData();
              Provider.of<RefundController>(context, listen: false).removeRefundDetails();
              refundController.getRefundReqInfo(orderDetails.id).then((value) {
                if (value.response?.statusCode == 200 && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RefundDetailsWidget(
                        product: orderDetails.productDetails,
                        orderDetailsId: orderDetails.id,
                        orderDetailsModel: orderDetails,
                        createdAt: orderDetails.createdAt,
                      ),
                    ),
                  );
                }
              });
            },
            child: isLoadingDetails ? SizedBox(
              height: Dimensions.paddingSizeExtraLarge,
              width: Dimensions.paddingSizeExtraLarge,
              child: Center(
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
              ),
            ) : Container(
              margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
              padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeExtraSmall,
                horizontal: Dimensions.paddingSizeDefault,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(
                  Dimensions.paddingSizeExtraSmall
                ),
              ),
              child: Text(
                getTranslated('view_refund', context) ?? '',
                style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
              ),
            ),
          );
        }
        else {
          return const SizedBox();
        }
      },
    );
  }


  bool isRefundDetailButtonPressed(RefundController refundController) {
    return refundController.isRefund
        && (widget.orderDetailsModel.id == refundController.getSelectedOrderDetailsId);
  }

  bool _canRefundRequest(ConfigModel? configModel) => widget.orderDetailsModel.order?.status == 'delivered'
      && widget.orderDetailsModel.refundReq == 0
      && widget.orderType != "POS"
      && widget.orderDetailsModel.refundStartedAt != null
      && DateTime.parse(widget.orderDetailsModel.refundStartedAt!).difference(DateTime.now()).inDays.abs() <= (configModel?.refundDayLimit ?? 0)
      && (configModel?.refundDayLimit != 0);

  void _downloadProduct(){
    String url = widget.orderDetailsModel.productDetails!.digitalProductType == 'ready_after_sell'?
    '${widget.orderDetailsModel.digitalFileAfterSellFullUrl?.path}':
    '${widget.orderDetailsModel.productDetails?.digitalFileReadyFullUrl?.path}';

    String filename = widget.orderDetailsModel.productDetails!.digitalProductType == 'ready_after_sell'?
    '${widget.orderDetailsModel.digitalFileAfterSellFullUrl?.key}':
    '${widget.orderDetailsModel.productDetails?.digitalFileReadyFullUrl?.key}';

    Provider.of<OrderDetailsController>(context, listen: false).productDownload(
        url: url,
        fileName: filename,
        index: widget.index
    );
  }
}