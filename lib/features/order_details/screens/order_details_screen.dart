import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/shipping_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/offline_payment/widgets/offline_payment_section_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/cal_chat_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/cancel_and_support_center_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/delivery_man_review_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/due_amount_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_amount_calculation.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_details_status_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_payment_bottomsheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_payment_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/ordered_product_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/seller_section_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/shipping_and_billing_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/shipping_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/color_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/image_diaglog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/order_details_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final bool isNotification;
  final int? orderId;
  final String? phone;
  final bool fromTrack;
  const OrderDetailsScreen({super.key, required this.orderId, this.isNotification = false, this.phone,  this.fromTrack = false});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  void _loadData(BuildContext context) async {
    if(Provider.of<AuthController>(context, listen: false).isLoggedIn() && !widget.fromTrack) {
      await Provider.of<OrderDetailsController>(Get.context!, listen: false).getOrderDetails(widget.orderId.toString());
      await Provider.of<OrderController>(Get.context!, listen: false).initTrackingInfo(widget.orderId.toString());
      await Provider.of<OrderDetailsController>(Get.context!, listen: false).getOrderFromOrderId(widget.orderId.toString());
    } else {
      await Provider.of<OrderDetailsController>(Get.context!, listen: false).trackOrder(orderId: widget.orderId.toString(), phoneNumber: widget.phone, isUpdate: false);
      await Provider.of<OrderDetailsController>(Get.context!, listen: false).getOrderFromOrderId(widget.orderId.toString());
    }
    Provider.of<CheckoutController>(Get.context!, listen: false).getOfflinePaymentList();
    await Provider.of<OrderDetailsController>(Get.context!, listen: false).getTrackOrderDetailsId(orderId: widget.orderId.toString());
  }

  @override
  void initState() {
    super.initState();
    if(Provider.of<SplashController>(context, listen: false).configModel == null ) {
      Provider.of<SplashController>(context, listen: false).initConfig(context, null, null).then((value){
        _loadData(Get.context!);
        Provider.of<OrderDetailsController>(Get.context!, listen: false).digitalOnly(true);
      });
    }else{
      _loadData(context);
      Provider.of<OrderDetailsController>(context, listen: false).digitalOnly(true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async{
        Provider.of<OrderDetailsController>(context, listen: false).emptyOrderDetails();
        if(widget.isNotification) {
          RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page: 'home');
        } else {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Material(
            color: Theme.of(context).cardColor,
            elevation: 3.0,
            shadowColor: Theme.of(context).cardColor,
            child: Container(),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).highlightColor,
          toolbarHeight: 80, leadingWidth: 0, automaticallyImplyLeading: false,
          title: Consumer<OrderDetailsController> (
            builder: (context, orderProvider, _) {
              return (orderProvider.orderDetails != null && orderProvider.orders != null) ?
              OrderDetailsStatusWidget(isNotification: widget.isNotification) : const SizedBox();
            }
          )
        ),

        body: RefreshIndicator(
          onRefresh: () async {
            _loadData(context);
          },
          child: Consumer<SplashController>(
            builder: (context, config, _) {
              return config.configModel != null?
              Consumer<OrderDetailsController>(
                builder: (context, orderProvider, child) {
                  double itemTotalAmount = 0;
                  double discount = 0;
                  double? eeDiscount = 0;
                  double tax = 0;
                  double shippingCost = 0;
                  double referAndEarnDiscount = 0;

                  if (orderProvider.orderDetails != null && orderProvider.orderDetails!.isNotEmpty) {
                    if( orderProvider.orderDetails?[0].order?.isShippingFree == 1){
                      shippingCost = 0;
                    }else{
                      shippingCost = orderProvider.orders?.shippingCost??0;
                    }

                    for (var orderDetails in orderProvider.orderDetails!) {
                      if(orderDetails.productDetails?.productType != null && orderDetails.productDetails!.productType != "physical" ){
                        orderProvider.digitalOnly(false, isUpdate: false);
                      }
                    }



                    for (var orderDetails in orderProvider.orderDetails!) {
                      itemTotalAmount = itemTotalAmount + (orderDetails.price! * orderDetails.qty!);
                      discount = discount + orderDetails.discount!;
                      // tax =  orderProvider.orderDetails.t !;
                    }


                    if(orderProvider.orders != null && orderProvider.orders!.orderType == 'POS') {
                      if(orderProvider.orders!.extraDiscountType == 'percent') {
                        eeDiscount = (itemTotalAmount - discount  - (orderProvider.orders!.discountAmount ?? 0)) * ((orderProvider.orders!.extraDiscount) !/100);
                      }else{
                        eeDiscount = orderProvider.orders!.extraDiscount;
                      }
                    }

                    if(orderProvider.orderDetails != null && orderProvider.orders?.orderType != 'POS') {
                      referAndEarnDiscount = orderProvider.orderDetails?[0].order?.referAndEarnDiscount ?? 0;
                    }

                    tax = orderProvider.orders?.totalTaxAmount ?? 0 ;
                  }


                  return (orderProvider.orderDetails != null && orderProvider.orders != null) ?
                  Column(
                    children: [
                      Expanded(
                        child: ListView(padding: const EdgeInsets.all(0), children: [
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          const OrderPaymentInfoWidget(),

                            Container(
                              height: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.2), spreadRadius:1.5, blurRadius: 3)],
                                color: Theme.of(context).cardColor,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          getTranslated('payment_info', context) ?? '',
                                          style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color )
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45))),

                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getTranslated('payment_status_title', context) ?? '',
                                          style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                                        ),

                                        Text((orderProvider.orders?.paymentStatus != null && orderProvider.orders!.paymentStatus!.isNotEmpty) ?
                                        getTranslated(orderProvider.orders!.paymentStatus, context) ?? orderProvider.orders!.paymentStatus!
                                          : 'Digital Payment',
                                          style: titilliumSemiBold.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: orderProvider.orders?.paymentStatus == 'paid' ?
                                            Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.error
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    child: SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45)))),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),


                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getTranslated('payment_method', context) ?? '',
                                          style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                                        ),

                                        Text(orderProvider.orders!.paymentMethod!.replaceAll('_', ' ').capitalize(),
                                          style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    child: SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45)))
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),




                                  if(orderProvider.orderDetails?[0].order?.offlinePayments != null)...[
                                    SizedBox(height: Dimensions.paddingSizeSmall),

                                    OfflinePaymentSection(orderProvider: orderProvider),
                                  ],



                                if(orderProvider.orderDetails![0].latestEditHistory != null && !(orderProvider.orders?.paymentStatus ==  'unpaid' && orderProvider.orders?.paymentMethod == 'cash_on_delivery'))...[
                                  SizedBox(height: Dimensions.paddingSizeSmall),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          getTranslated('another_payment_info', context) ?? '',
                                          style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color )
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getTranslated('payment_status', context) ?? '',
                                          style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                                        ),


                                        if(orderProvider.orderDetails![0].latestEditHistory?.orderDuePaymentStatus  != null && orderProvider.orderDetails![0].latestEditHistory!.orderDuePaymentStatus!.isNotEmpty
                                           && (orderProvider.orderDetails![0].latestEditHistory?.orderDueAmount ?? 0) > 0)
                                        Text(
                                        getTranslated(orderProvider.orderDetails![0].latestEditHistory?.orderDuePaymentStatus, context) ?? 'Digital Payment',
                                          style: titilliumSemiBold.copyWith(
                                            fontSize: Dimensions.fontSizeDefault,
                                            color: orderProvider.orderDetails![0].latestEditHistory?.orderDuePaymentStatus == 'paid' ?
                                            Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.error
                                          )
                                        ),


                                        if(orderProvider.orderDetails![0].latestEditHistory?.orderReturnPaymentStatus != null && orderProvider.orderDetails![0].latestEditHistory!.orderReturnPaymentStatus!.isNotEmpty
                                         && (orderProvider.orderDetails![0].latestEditHistory?.orderReturnAmount ?? 0) > 0)
                                          Text(
                                            getTranslated(orderProvider.orderDetails![0].latestEditHistory?.orderReturnPaymentStatus, context) ?? 'Digital Payment',
                                            style: titilliumSemiBold.copyWith(
                                              fontSize: Dimensions.fontSizeDefault,
                                              color: (orderProvider.orderDetails![0].latestEditHistory?.orderReturnPaymentStatus == 'paid' || orderProvider.orderDetails![0].latestEditHistory?.orderReturnPaymentStatus == 'returned') ?
                                              Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.error
                                            )
                                          ),

                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),



                                  if(orderProvider.orderDetails![0].latestEditHistory?.orderDuePaymentMethod != null)...[
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                      child: SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45)))),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            getTranslated('payment_method', context) ?? '',
                                            style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                                          ),

                                          Text(orderProvider.orderDetails![0].latestEditHistory!.orderDuePaymentMethod!.replaceAll('_', ' ').capitalize(),
                                            style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                      child: SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45)))
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                  ],



                                  if(orderProvider.orderDetails![0].latestEditHistory?.orderReturnPaymentMethod != null)...[
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                      child: SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45)))),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            getTranslated('payment_method', context) ?? '',
                                            style: textRegular.copyWith(color: Theme.of(context).textTheme.titleMedium?.color)
                                          ),

                                          Text(orderProvider.orderDetails![0].latestEditHistory!.orderReturnPaymentMethod!.replaceAll('_', ' ').capitalize(),
                                            style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor)
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                      child: SizedBox(height: 1, child: Divider(thickness: .200, color: Theme.of(context).hintColor.withValues(alpha: 0.45)))
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                  ],


                                  if (orderProvider.orderDetails?[0].latestEditHistory?.orderDuePaymentInfo != null)...[
                                    SizedBox(height: Dimensions.paddingSizeSmall),

                                    CustomerPaymentSection(orderProvider: orderProvider),
                                  ],
                                ],
                                  


                                if(orderProvider.orderDetails![0].order?.editedStatus == 1)...[
                                  if(orderProvider.orderDetails![0].order?.editedStatus == 1 && (orderProvider.orderDetails?[0].latestEditHistory?.orderDueAmount ?? 0) > 0
                                    &&  orderProvider.orderDetails![0].latestEditHistory!.orderDuePaymentMethod != 'cash_on_delivery' && orderProvider.orderDetails?[0].latestEditHistory?.orderDuePaymentStatus != 'paid'
                                      && !(orderProvider.orderDetails![0].latestEditHistory!.orderDuePaymentMethod == 'offline_payment' && orderProvider.orderDetails?[0].latestEditHistory?.orderDuePaymentStatus == 'unpaid'))
                                  AmountDueCard(
                                    showButton: true,
                                    title: getTranslated('pay_due_bill', context)!,
                                    price: PriceConverter.convertPrice(context, orderProvider.orderDetails![0].latestEditHistory!.orderDueAmount!),
                                    description: getTranslated('after_editing_your_product_list', context)!,
                                    buttonText:  getTranslated('pay_now', context)!,
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                        builder: (c) {
                                          return OrderPaymentMethodBottomSheetWidget(
                                            onlyDigital: false,
                                            orderId: orderProvider.orderDetails![0].orderId.toString(),
                                            payableAmount : orderProvider.orderDetails![0].latestEditHistory!.orderDueAmount!,
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  if(orderProvider.orderDetails![0].order?.editedStatus == 1 && (orderProvider.orderDetails?[0].latestEditHistory?.orderReturnAmount ?? 0) > 0 && orderProvider.orderDetails?[0].latestEditHistory?.orderReturnPaymentStatus != 'returned' )
                                  AmountDueCard(
                                    showButton: false,
                                    title: getTranslated('amount_to_be_returned', context)!,
                                    price: PriceConverter.convertPrice(context, orderProvider.orderDetails![0].latestEditHistory!.orderReturnAmount!),
                                    description: getTranslated('after_editing_your_product_list_you_will_receive_this', context)!, buttonText: '',
                                    onTap: null,
                                  ),
                                ],

                                  SizedBox(height: Dimensions.paddingSizeSmall),
                                ],
                              ),
                            ),



                            Container(
                              height: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                            ),



                          if(orderProvider.orders!.orderType != 'POS')
                          ShippingAndBillingWidget(orderProvider: orderProvider),


                          (orderProvider.orders != null && orderProvider.orders!.orderNote != null && orderProvider.orders!.orderType != 'POS' && orderProvider.orders!.orderNote!.isNotEmpty) ?
                          Container(
                            //padding : const EdgeInsets.all(Dimensions.marginSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.2), spreadRadius:2, blurRadius: 10)]
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: Dimensions.paddingSizeSmall),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                  child: Text('${getTranslated('order_note', context)}',
                                    style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).shadowColor
                                    )
                                  ),
                                ),
                                SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                Divider(thickness: .25, color: Theme.of(context).primaryColor.withValues(alpha:0.50)),

                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: 0),
                                  child: Text(
                                    orderProvider.orders!.orderNote != null? orderProvider.orders!.orderNote ?? '': "",
                                    style: titilliumRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).textTheme.bodyLarge?.color
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),

                                SizedBox(height: Dimensions.paddingSizeSmall),
                              ],
                            )
                          ) : const SizedBox(),

                          if(orderProvider.orders!.orderType != 'POS')
                          const SizedBox(height: Dimensions.paddingSizeSmall),



                          SellerSectionWidget(order: orderProvider),


                          if(orderProvider.orders != null)
                            OrderProductListWidget(
                              orderType: orderProvider.orders!.orderType,
                              fromTrack: widget.fromTrack,
                              isGuest: orderProvider.orders!.isGuest!,
                              orderId: orderProvider.orders!.id.toString(),
                            ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          OrderAmountCalculation(orderProvider: orderProvider,itemTotalAmount: itemTotalAmount,discount: discount,eeDiscount: eeDiscount,shippingCost: shippingCost, tax: tax, referAndEarnDiscount: referAndEarnDiscount),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          /// Delivery Man Section
                          orderProvider.orders!.deliveryMan != null ?
                          Column(
                            children: [
                              Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                                    boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.2), spreadRadius:2, blurRadius: 10)]
                                ),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${getTranslated('shipping_info', context)}', style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                      orderProvider.orders?.orderStatus == 'delivered' ?
                                      InkWell(
                                        onTap: () {
                                          Provider.of<ReviewController>(context, listen: false).removeData();

                                          showDialog(context: context, builder: (context) => Dialog(
                                            insetPadding: EdgeInsets.zero, backgroundColor: Colors.transparent,
                                            child: DeliveryManReviewDialogWidget(
                                              deliverymanAssignedAt: orderProvider.orders?.deliverymanAssignedAt,
                                              existingDeliveryManReview: orderProvider.orderDetails?[0].order?.deliveryManReview,
                                              deliveryMan: orderProvider.orders!.deliveryMan,
                                              orderId: orderProvider.orders?.id.toString(),
                                              callback: ()=> showCustomSnackBarWidget(getTranslated('review_submitted_successfully', context)!, context, snackBarType: SnackBarType.success),
                                            ),
                                          ));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                          child: Row(children: [
                                            const CustomAssetImageWidget(Images.myReviewIconWhite, height: 20, width: 20),
                                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),


                                            Text(orderProvider.orderDetails?[0].order?.deliveryManReview != null ?
                                            '${getTranslated('update_review', context)}' :
                                            '${getTranslated('review', context)}', style: textBold.copyWith(
                                              fontSize: Dimensions.fontSizeSmall,
                                              color: Theme.of(context).scaffoldBackgroundColor,
                                            )),
                                          ]),
                                        ),
                                      ) :
                                      CallAndChatWidget(orderProvider: orderProvider, orderModel: orderProvider.orders),
                                    ],
                                  ),


                                  const SizedBox(height: Dimensions.paddingSizeSmall),


                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeLarge),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder, fit: BoxFit.scaleDown, width: Dimensions.paddingSizeButton, height: Dimensions.paddingSizeButton,
                                          image: '${orderProvider.orders!.deliveryMan?.imageFullUrl?.path}',
                                          imageErrorBuilder: (c, o, s) => Image.asset(
                                            Images.placeholder,
                                            fit: BoxFit.cover,
                                            width: Dimensions.paddingSizeButton,
                                            height: Dimensions.paddingSizeButton,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: Dimensions.paddingSizeDefault),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text((orderProvider.orders!.deliveryMan != null ) ?
                                              '${orderProvider.orders?.deliveryMan?.fName} ${orderProvider.orders?.deliveryMan?.lName}':'',
                                                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color))]
                                          ),
                                          // const SizedBox(height: 10),

                                          if(orderProvider.orders?.deliverymanAssignedAt != null)
                                            Text.rich(TextSpan(children: [
                                              TextSpan(text: '${getTranslated('assign', context)!} : ', style: textRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall,
                                                color: Theme.of(context).hintColor,
                                              )),


                                              TextSpan(text: DateConverter.localToIsoString(DateTime.tryParse(orderProvider.orders?.deliverymanAssignedAt ?? '') ?? DateTime.now()), style: textRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall,
                                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                              )),
                                            ])),
                                          // const SizedBox(height: Dimensions.paddingSizeDefault),

                                        ],
                                      )
                                    ],
                                  ),
                                ]),
                              ),
                              SizedBox(height: Dimensions.paddingSizeSmall),
                            ],
                          ) : orderProvider.orders!.deliveryServiceName != null ?
                          ShippingInfoWidget(order: orderProvider) : const SizedBox(),

                          if(orderProvider.orderDetails != null && orderProvider.orderDetails!.isNotEmpty &&
                            orderProvider.orderDetails![0].verificationImages != null &&orderProvider.orderDetails![0].verificationImages!.isNotEmpty)
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
                                Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                  '${getTranslated('picture_uploaded_by', context)} ${orderProvider.orders!.deliveryMan != null ?
                                  '${orderProvider.orders!.deliveryMan!.fName} ${orderProvider.orders!.deliveryMan!.lName}' : ''}',
                                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                                ),
                              ),

                              SizedBox(height: 120,
                                child: ListView.builder(
                                  itemCount: orderProvider.orderDetails![0].verificationImages?.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index){
                                    return InkWell(onTap: () {
                                      showDialog(context: context, builder: (_)=> ImageDialog(
                                        imageUrl: '${orderProvider.orderDetails![0].verificationImages?[index].imageFullUrl?.path}')
                                      );
                                    },
                                    child: Padding(padding:  EdgeInsets.only(left: Dimensions.paddingSizeSmall,
                                      right: orderProvider.orderDetails![0].verificationImages!.length == index+1?
                                      Dimensions.paddingSizeSmall : 0),
                                      child: SizedBox(width: 200,
                                        child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                          child: Container(decoration: BoxDecoration(
                                            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.25), width: .25),
                                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                            child: CustomImageWidget(image: '${orderProvider.orderDetails![0].verificationImages?[index].imageFullUrl?.path}'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    );
                                  },
                                ),
                              ),
                            ]),


                          if(orderProvider.orderDetails != null && orderProvider.orderDetails!.isNotEmpty &&
                            orderProvider.orderDetails![0].verificationImages != null &&orderProvider.orderDetails![0].verificationImages!.isNotEmpty)
                          const SizedBox(height: Dimensions.paddingSizeSmall),


                          CancelAndSupportWidget(orderModel: orderProvider.orders, showSupport: true),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Container(
                        color: Theme.of(context).cardColor,
                        child: CancelAndSupportWidget(orderModel: orderProvider.orders, showSupport: false)
                      ),
                    ],
                  ) : const OrderDetailsShimmer();
                },
              ): const OrderDetailsShimmer();
            }
          ),
        )

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
