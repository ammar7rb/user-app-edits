import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_directionality_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/review_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/refund/controllers/refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';

class OrderDetailsWidget extends StatefulWidget {
  final OrderDetailsModel orderDetailsModel;
  final String orderType;
  final String orderId;
  final String paymentStatus;
  final Function callback;
  final bool fromTrack;
  final int? isGuest;
  final int index;
  const OrderDetailsWidget({
    super.key, required this.orderDetailsModel, required this.callback,
    required this.orderType, required this.paymentStatus,  this.fromTrack = false, this.isGuest, required this.orderId, required this.index
  });

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  final ReceivePort _port = ReceivePort();


  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState((){ });
    });

//    FlutterDownloader.registerCallback(downloadCallback);
  }

  void downloadCallback(String id, int status, int progress) async {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }


  DigitalVariation? digitalVariation;

  String? downloadMessage;
  File? downloadedFile;

  @override
  Widget build(BuildContext context) {
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;

    if(widget.orderDetailsModel.productDetails != null && widget.orderDetailsModel.variant != null && widget.orderDetailsModel.variant!.isNotEmpty && widget.orderDetailsModel.productDetails?.productType == 'digital') {
      for(DigitalVariation dv in widget.orderDetailsModel.productDetails!.digitalVariation ?? []) {
        if(dv.variantKey == widget.orderDetailsModel.variant){
          digitalVariation = dv;
        }
      }
    }

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Stack(children: [
        Column(children: [
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.125))
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                ),
                child: CustomImageWidget(image: '${widget.orderDetailsModel.productDetails?.thumbnailFullUrl?.path}', width: 50, height: 50),
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(flex: 3,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: InkWell(
                    onTap: () {
                      RouterHelper.getProductDetailsRoute(action: RouteAction.push, productId: widget.orderDetailsModel.productDetails!.id! , slug: widget.orderDetailsModel.productDetails!.slug);
                    },
                    child: Text(
                      widget.orderDetailsModel.productDetails?.name ?? '',
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                ]),
                const SizedBox(height: Dimensions.marginSizeExtraSmall),


                (widget.orderDetailsModel.variant != null && widget.orderDetailsModel.variant!.isNotEmpty) ?
                Padding(padding: const EdgeInsets.only(top: 0),
                  child: Row(children: [
                    Text('${getTranslated('variations', context)}: ',
                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color)),

                    Flexible(child: Text(widget.orderDetailsModel.variant!,
                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).disabledColor,))
                    ),

                  ]),
                ) : const SizedBox(),
                const SizedBox(height: Dimensions.marginSizeExtraSmall),



                Row(children: [
                  Text(
                    PriceConverter.convertPrice(context, widget.orderDetailsModel.price),
                    style: titilliumSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: Dimensions.fontSizeDefault),
                    maxLines: 1,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                ]),

                // widget.orderDetailsModel.productDetails!.taxModel == 'exclude'?
                // Text(
                //   '(${getTranslated('tax', context)} ${PriceConverter.convertPrice(context,( (widget.orderDetailsModel.tax ?? 0) / (widget.orderDetailsModel.qty ?? 1)))})',
                //   style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                // ) :
                // Text(
                //   '(${getTranslated('tax', context)} ${widget.orderDetailsModel.productDetails!.taxModel})',
                //   style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                // ),

                const SizedBox(height: Dimensions.marginSizeExtraSmall),

                Text('${getTranslated('qty', context)}: ${widget.orderDetailsModel.qty}',
                  style: titilliumRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color, fontSize: Dimensions.fontSizeSmall)
                ),
                const SizedBox(height: Dimensions.marginSizeExtraSmall),


              ],
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),


            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              widget.orderDetailsModel.productDetails?.productType =='digital' && widget.paymentStatus == 'paid' ?
              Consumer<OrderDetailsController>(
                builder: (context, orderProvider, _) {
                  return InkWell(onTap : () async {
                    if(widget.orderDetailsModel.productDetails!.digitalProductType == 'ready_after_sell' &&
                        widget.orderDetailsModel.digitalFileAfterSell == null) {
                      showCustomSnackBarWidget(getTranslated('product_not_uploaded_yet', context), context, snackBarType: SnackBarType.success);
                    } else {
                      if(Provider.of<AuthController>(context, listen: false).isLoggedIn() && widget.isGuest == 0){
                        _downloadProduct();
                      }else{
                        orderProvider.downloadDigitalProduct(orderDetailsId: widget.orderDetailsModel.id!).then((value){
                          if(value.response?.statusCode == 200){

                          }
                        });
                      }
                    }
                  },
                    child: Align(alignment: Alignment.centerRight,
                      child: Builder(
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeEight),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.10)),
                            alignment: Alignment.center,
                            child: (orderProvider.isDownloaodLoading &&  orderProvider.downloaodIndex == widget.index) ?
                            SizedBox(height: 15,  width: 15, child: CircularProgressIndicator(color: Theme.of(context).primaryColor, strokeWidth: 2)) :
                            Center(child:  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              CustomAssetImageWidget(Images.productDownloadIcon, height: 15, width: 15, color: Theme.of(context).primaryColor),
                            ]))
                          );
                        }
                      )
                    ),
                  );
                }
              ) : const SizedBox(),

              SizedBox(height: (widget.orderDetailsModel.productDetails != null &&
                  widget.orderDetailsModel.productDetails?.productType =='digital' && widget.paymentStatus == 'paid') ?
              Dimensions.paddingSizeSmall : 0),


              ///Refund
              ///
              // Consumer<RefundController>(builder: (context,refund,_) {
              //   return _canRefundRequest(configModel) ?
              //   InkWell(
              //     onTap: refund.isRefund ? null : () {
              //       Provider.of<ReviewController>(context, listen: false).removeData();
              //       refund.removeRefundDetails();
              //
              //       refund.getRefundReqInfo(widget.orderDetailsModel.id).then((value) {
              //         if(value.response!.statusCode == 200) {
              //           if(context.mounted){
              //             Navigator.push(context, MaterialPageRoute(builder: (_) => RefundRequestWidget(
              //               product: widget.orderDetailsModel.productDetails,
              //               orderDetailsId: widget.orderDetailsModel.id!,
              //               orderId: widget.orderId,
              //             )));
              //           }
              //         }
              //       });
              //     },
              //
              //       child: refund.isRefund && (widget.orderDetailsModel.id == refund.getSelectedOrderDetailsId) ?
              //       SizedBox(
              //         height: Dimensions.paddingSizeExtraLarge,
              //         width: Dimensions.paddingSizeExtraLarge,
              //         child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
              //       ) :
              //       Container(
              //         padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeExtraLarge),
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Theme.of(context).primaryColor),
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //         child: Text(getTranslated('refund', context)!,
              //             style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
              //               color: Theme.of(context).primaryColor,)),
              //       )
              //
              //   ) : const SizedBox();
              // }),
              // Consumer<OrderController>(
              //     builder: (context, orderController, _) {
              //       return Consumer<RefundController>(builder: (context,refundController,_){
              //         return (orderController.orderTypeIndex == 1 && widget.orderDetailsModel.refundReq != 0 &&
              //             widget.orderType != "POS") ?
              //
              //         InkWell(onTap: refundController.isRefund ? null : () {
              //           Provider.of<ReviewController>(context, listen: false).removeData();
              //           Provider.of<RefundController>(context, listen: false).removeRefundDetails();
              //           refundController.getRefundReqInfo(widget.orderDetailsModel.id).then((value) {
              //             if(value.response!.statusCode==200) {
              //               if(context.mounted) {
              //                 Navigator.push(context, MaterialPageRoute(builder: (_) =>
              //                   RefundDetailsWidget(product: widget.orderDetailsModel.productDetails,
              //                     orderDetailsId: widget.orderDetailsModel.id,
              //                     orderDetailsModel:  widget.orderDetailsModel, createdAt: widget.orderDetailsModel.createdAt),
              //                 ));
              //               }
              //             }}
              //           );
              //         },
              //         child: isRefundDetailButtonPressed(refundController) ?
              //         SizedBox(
              //           height: Dimensions.paddingSizeExtraLarge,
              //           width: Dimensions.paddingSizeExtraLarge,
              //           child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
              //         ) :
              //         Container(
              //           margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
              //           padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Theme.of(context).primaryColor),
              //             borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),),
              //
              //           child: Text(getTranslated('refund_status_btn', context)??'',
              //             style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
              //             color: Theme.of(context).primaryColor)),)) :const SizedBox();}
              //       );
              //     }
              // ),
              ///
              ///


            ]),
          ]),



          Consumer<OrderController>(
            builder: (context, orderController, _) {
              return  widget.orderDetailsModel.order?.status == 'delivered' && widget.orderType != "POS" ?
              ReviewButtonWidget(
                orderDetailsModel: widget.orderDetailsModel,
                orderId: widget.orderId,
                orderType: widget.orderType,
                callback: widget.callback,
                index: widget.index,
              ) : const SizedBox.shrink();
            }
          ),

          if(widget.orderDetailsModel.order?.status == 'delivered' && widget.orderType != "POS")
            const SizedBox(height: Dimensions.paddingSizeSmall),

          SizedBox(height: 1, child: Divider(thickness: .300, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),

        ]),

        if(widget.orderDetailsModel.discount! > 0 && (widget.orderDetailsModel.productDetails?.discount != null || widget.orderDetailsModel.productDetails?.clearanceSale != null)) Positioned(
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
                widget.orderDetailsModel.productDetails?.clearanceSale != null ?
                PriceConverter.percentageCalculation(context, (widget.orderDetailsModel.price! * widget.orderDetailsModel.qty!), widget.orderDetailsModel.productDetails?.clearanceSale?.discountAmount, widget.orderDetailsModel.productDetails?.clearanceSale?.discountType) :
                PriceConverter.percentageCalculation(
                  context, (widget.orderDetailsModel.price! * widget.orderDetailsModel.qty!),
                  widget.orderDetailsModel.productDetails?.discount,
                  widget.orderDetailsModel.productDetails?.discountType,
                ),
                style: titilliumRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color:  Theme.of(context).colorScheme.secondaryContainer,
                ),
              ),
            ),
          ),
        )

      ],
      ),
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

