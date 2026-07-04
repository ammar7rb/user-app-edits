import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/amount_widget.dart';

class OrderAmountCalculation extends StatelessWidget {
  final double itemTotalAmount;
  final double discount;
  final double? eeDiscount;
  final double tax;
  final double shippingCost;
  final double referAndEarnDiscount;
  final OrderDetailsController orderProvider;
  const OrderAmountCalculation({super.key, required this.itemTotalAmount, required this.discount, this.eeDiscount, required this.tax, required this.shippingCost, required this.orderProvider, required this.referAndEarnDiscount});

  @override
  Widget build(BuildContext context) {
    bool isPaid = orderProvider.orderDetails?[0].latestEditHistory?.orderDuePaymentStatus == 'paid';
    return  Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.2), spreadRadius:1.5, blurRadius: 3)],
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: [
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getTranslated('billing_summery', context)!,
                  style: titilliumBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)
                ),
              ]
            )
          ),
          SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),

          Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            color: Theme.of(context).cardColor,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              if(orderProvider.orderDetails![0].order?.editedStatus == 1)
              Container(
                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Text(getTranslated('total_bill_has_been_updated_after', context) ?? '',
                  style: titilliumRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: Dimensions.fontSizeDefault,
                  )
                ),
              ),

              AmountWidget(title: getTranslated('sub_total', context),
                  amount: PriceConverter.convertPrice(context, itemTotalAmount)),


              orderProvider.orders!.orderType == "POS"? const SizedBox():
              AmountWidget(title: getTranslated('shipping_fee', context),
                  amount: PriceConverter.convertPrice(context, shippingCost)),


              AmountWidget(title: getTranslated('discount', context),
                  amount: PriceConverter.convertPrice(context, discount)),


              orderProvider.orders!.orderType == "POS"?
              AmountWidget(title: getTranslated('extra_discount', context),
                  amount: PriceConverter.convertPrice(context, eeDiscount)):const SizedBox(),


              AmountWidget(title: getTranslated('coupon_voucher', context),
                amount: PriceConverter.convertPrice(context, orderProvider.orders!.discountAmount),),


              if(tax > 0)
              AmountWidget(title: getTranslated('tax', context),
                  amount: PriceConverter.convertPrice(context, tax)),

              if(referAndEarnDiscount > 0)
                AmountWidget(title: getTranslated('referral_discount', context),
                amount: PriceConverter.convertPrice(context, referAndEarnDiscount)),


              SizedBox(height: 1, child: Divider(thickness: .300, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),


              AmountWidget(
                titleStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                amountStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                isTitleBlack: true,  title: '${getTranslated('total_payable', context)} ${orderProvider.orders!.taxModel == 'include' ? getTranslated('inc_vat_tax', context) : ''}' ,
                amount: PriceConverter.convertPrice(context, (itemTotalAmount + shippingCost - referAndEarnDiscount - eeDiscount! - orderProvider.orders!.discountAmount! - discount  + tax)),
              ),


              if((orderProvider.orderDetails?[0].latestEditHistory?.orderDueAmount ?? 0)  > 0)...[
                AmountWidget(isTitleBlack: true,  title: '${getTranslated('paid_amount', context)}',
                  titleStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                  amountStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                  amount: PriceConverter.convertPrice(context, (itemTotalAmount + shippingCost - referAndEarnDiscount - eeDiscount! - orderProvider.orders!.discountAmount! - discount  + tax) - (orderProvider.orderDetails?[0].latestEditHistory?.orderDueAmount ?? 0))
                ),


                AmountWidget(isTitleBlack: true,  title: '${getTranslated('due', context)}' ,
                  isPaid: isPaid,
                  titleStyle: textBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                    color: isPaid ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).colorScheme.error),
                  amountStyle: textBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                    color: isPaid ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.error),
                  amount: PriceConverter.convertPrice(context, (orderProvider.orderDetails?[0].latestEditHistory?.orderDueAmount ?? 0))
                ),
              ],


              if((orderProvider.orderDetails?[0].latestEditHistory?.orderReturnAmount ?? 0)  > 0)...[
                AmountWidget(isTitleBlack: true,  title: '${getTranslated('paid_amount', context)}',
                  titleStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                  amountStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                    amount: PriceConverter.convertPrice(context, (itemTotalAmount + shippingCost - referAndEarnDiscount - eeDiscount! - orderProvider.orders!.discountAmount! - discount  + tax) - (orderProvider.orderDetails?[0].latestEditHistory?.orderDueAmount ?? 0) +  (orderProvider.orderDetails?[0].latestEditHistory?.orderReturnAmount ?? 0))
                ),


                AmountWidget(isTitleBlack: true,  title: '${getTranslated('amount_to_return', context)}',
                  isReturned: orderProvider.orderDetails?[0].latestEditHistory?.orderReturnPaymentStatus == 'returned',
                  titleStyle: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                  amountStyle: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).colorScheme.primary),
                  amount: PriceConverter.convertPrice(context, (orderProvider.orderDetails?[0].latestEditHistory?.orderReturnAmount ?? 0))
                ),
              ],






              // && orderProvider.orders!.paymentMethod  == "cash" && orderProvider.orders!.paidAmount! > (itemTotalAmount + shippingCost - eeDiscount! - orderProvider.orders!.discountAmount! - discount  + tax)
              if (orderProvider.orders!.orderType == 'POS')
                AmountWidget(isTitleBlack: true, title: getTranslated('paid_amount', context),
                    amount: PriceConverter.convertPrice(context, orderProvider.orders!.paidAmount)),

              if (orderProvider.orders!.orderType == 'POS')
                AmountWidget(isTitleBlack: true, title: getTranslated('change_amount', context),
                  amount: PriceConverter.convertPrice(context, orderProvider.orders!.paidAmount! - double.parse((itemTotalAmount + shippingCost - eeDiscount! - orderProvider.orders!.discountAmount! - discount  + tax).toStringAsFixed(2)))
                ),



            ])
          )


        ],
      ),
    );
  }
}
