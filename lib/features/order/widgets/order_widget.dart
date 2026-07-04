import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';


class OrderWidget extends StatefulWidget {
  final Orders? orderModel;
  const OrderWidget({super.key, this.orderModel});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final tooltipController = JustTheController();


  @override
  Widget build(BuildContext context) {

    double orderAmount = 0;
    double tax = 0;

    if(widget.orderModel?.orderType == 'POS') {
      double itemsPrice = 0;
      double discount = 0;
      double? eeDiscount = 0;

      double coupon = 0;
      double shipping = 0;
      if (widget.orderModel?.details != null && widget.orderModel!.details!.isNotEmpty ) {
        coupon = widget.orderModel?.discountAmount ?? 0;
        shipping = widget.orderModel?.shippingCost ?? 0;
        tax = widget.orderModel?.totalTaxAmount ?? 0;

        for (var orderDetails in widget.orderModel!.details!) {
          itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.qty!);
          discount = discount + orderDetails.discount!;
          // tax = tax + orderDetails.tax!;
        }
        if(widget.orderModel!.orderType == 'POS'){
          if(widget.orderModel!.extraDiscountType == 'percent'){
            eeDiscount = itemsPrice * (widget.orderModel!.extraDiscount!/100);
          }else{
            eeDiscount = widget.orderModel!.extraDiscount;
          }
        }
      }
      double subTotal = itemsPrice +tax - discount;

      orderAmount = subTotal + shipping - coupon - (eeDiscount ?? 0);




      // double ? _extraDiscountAnount = 0;
      // if(orderModel.extraDiscount != null){
      //   _extraDiscountAnount = PriceConverter.convertWithDiscount(context, orderModel.totalProductPrice, orderModel.extraDiscount, orderModel.extraDiscountType == 'percent' ? 'percent' : 'amount' );
      //   if(_extraDiscountAnount != null) {
      //     double percentAmount = _extraDiscountAnount!;
      //     _extraDiscountAnount = orderModel.totalProductPrice! - percentAmount;
      //   }
      // }
      //
      // double totalDiscount = (_extraDiscountAnount! + orderModel.totalProductDiscount!);
      // double totalOrderAmount = (orderModel.totalProductPrice! + orderModel.totalTaxAmount!);
      //
      // orderAmount = totalOrderAmount - totalDiscount;
      //
      // orderAmount = orderModel.orderAmount! - orderModel.totalTaxAmount!;


    }



    return InkWell(
      onTap: () {
        RouterHelper.getOrderDetailsScreenRoute(
          action: RouteAction.push,
          orderId: widget.orderModel!.id!,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: Dimensions.paddingSizeExtraSmall,
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: .15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Theme.of(context).primaryColor.withValues(alpha: 0.15)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                  placeholder: Images.placeholder,
                  image: widget.orderModel?.sellerIs == 'admin'
                    ? Provider.of<SplashController>(context, listen: false).configModel ?.inHouseShop?.imageFullUrl?.path ?? ''
                    : '${widget.orderModel?.seller?.shop?.imageFullUrl?.path}',
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${getTranslated('order', context)!} #${widget.orderModel!.id}',
                              style: textBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),


                            if(widget.orderModel?.editedStatus == 1)
                              Text('(${getTranslated('edited', context)})',
                                style: textMedium.copyWith(color: Theme.of(context).textTheme.headlineMedium?.color,fontSize: Dimensions.fontSizeSmall),
                              ),
                            SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            if(widget.orderModel?.editedStatus == 1 && ((widget.orderModel?.editDueAmount ?? 0) > 0 || (widget.orderModel?.editReturnAmount ?? 0) > 0))
                              JustTheTooltip(
                                backgroundColor: Colors.black87,
                                controller: tooltipController,
                                preferredDirection: AxisDirection.up,
                                tailLength: 10,
                                tailBaseWidth: 20,
                                content: Container(width: 250,
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Text(
                                    (widget.orderModel?.editDueAmount ?? 0) > 0 ? getTranslated('you_will_pay_due_the_amount', context)! :
                                    (widget.orderModel?.editReturnAmount ?? 0) > 0 ? getTranslated('admin_return_the_excess_amount_to_you', context)! : '',
                                    style: titleRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault)
                                  )
                                ),
                                child: InkWell(
                                  onTap: ()=>  tooltipController.showTooltip(),
                                  child: CustomAssetImageWidget(
                                    (widget.orderModel?.editDueAmount ?? 0) > 0 ?
                                    Images.orderDueAmountIcon : (widget.orderModel?.editReturnAmount ?? 0) > 0 ? Images.orderReturnAmountIcon : Images.placeholder,
                                    height: 16, width: 16
                                  ),
                                ),
                              ),

                          ],
                        )
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeEight,
                          vertical: Dimensions.paddingSizeExtraSmall,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: _getStatusBgColor(context, widget.orderModel!.orderStatus),
                        ),
                        child: Text(
                          getTranslated(widget.orderModel!.orderStatus, context) ?? '',
                          style: textBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: _getStatusTextColor(context, widget.orderModel!.orderStatus),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    DateConverter.localDateToIsoStringAMPMOrder(DateTime.parse(widget.orderModel!.createdAt!)),
                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleMedium?.color,),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        PriceConverter.convertPrice(
                          context,
                          widget.orderModel!.orderType == 'POS' ? orderAmount : widget.orderModel!.orderAmount,
                        ),
                        style: textBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),



                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.orderModel?.orderDetailsCount ?? 0} ',
                            style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color,),
                          ),

                          Text(
                            '${getTranslated('products', context)}',
                            style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color,),
                          ),
                        ],
                      ),




                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusBgColor(BuildContext context, String? status) {
    switch (status) {
      case 'delivered':
      case 'confirmed':
        return Theme.of(context).colorScheme.onTertiaryContainer.withValues(alpha: .1);
      case 'pending':
        return Theme.of(context).primaryColor.withValues(alpha: .1);
      case 'processing':
        return Theme.of(context).colorScheme.outline.withValues(alpha: .1);
      case 'canceled':
      case 'failed':
        return Theme.of(context).colorScheme.error.withValues(alpha: .1);
      default:
        return Theme.of(context).colorScheme.secondary.withValues(alpha: .1);
    }
  }

  Color _getStatusTextColor(BuildContext context, String? status) {
    switch (status) {
      case 'delivered':
      case 'confirmed':
        return Theme.of(context).colorScheme.onTertiaryContainer;
      case 'pending':
        return Theme.of(context).primaryColor;
      case 'processing':
        return Theme.of(context).colorScheme.outline;
      case 'canceled':
      case 'failed':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }
}
