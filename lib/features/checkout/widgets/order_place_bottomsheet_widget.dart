import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class OrderPlaceBottomSheetWidget extends StatefulWidget {
  final bool isFailed;
  final double rotateAngle;
  final IconData icon;
  final String? title;
  final String? description;
  final String? orderID;

  const OrderPlaceBottomSheetWidget({
    super.key,
    this.isFailed = false,
    this.rotateAngle = 0,
    required this.icon,
    required this.title,
    required this.description,
    this.orderID,
  });

  @override
  State<OrderPlaceBottomSheetWidget> createState() => _OrderPlaceBottomSheetWidgetState();
}

class _OrderPlaceBottomSheetWidgetState extends State<OrderPlaceBottomSheetWidget> {

  List<int> orderIds = [];
  List<JustTheController> toolTipControllers  = [];

  String orderId = '';


  @override
  void initState() {
    orderIds = convertToIntList(widget.orderID.toString());
    for(int id in orderIds) {
      toolTipControllers.add(JustTheController());
    }
    super.initState();
  }



  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {

    bool isLoggedIn = Provider.of<AuthController>(context, listen: false).isLoggedIn();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 30, width: 30,
                padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).hintColor.withValues(alpha: 0.3)
                ),
                child: Icon(Icons.close, size: 20, color: Theme.of(context).textTheme.titleMedium!.color),
              ),
            ),
          ),


          CustomAssetImageWidget(Images.orderSuccessIcon, height: 60, width: 60),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Text(
            widget.title!,
            style: robotoBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          if(isLoggedIn)...[
            Text(
              '${getTranslated('your_order_placed', Get.context!)} ${widget.orderID} ${getTranslated('keep_it_handy_for_tracking', Get.context!)}',
              textAlign: TextAlign.center,
              style: titilliumRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
          ],


          if(!isLoggedIn)...[
            Text(
              '${getTranslated('your_order_placed_and_it_will_process', Get.context!)}',
              textAlign: TextAlign.center,
              style: titilliumRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text(
              '${getTranslated('you_can_use_this_id_to_track', Get.context!)}',
              textAlign: TextAlign.center,
              style: titilliumRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge)
          ],


          if(!isLoggedIn)...[
            ((orderIds.length) == 1) ?
            DottedBorder(
              options: RoundedRectDottedBorderOptions(
                padding: const EdgeInsets.all(3),
                radius: const Radius.circular(20), dashPattern: const [5, 5],
                color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                Colors.grey : Theme.of(context).colorScheme.primary.withValues(alpha:0.5),
                strokeWidth: 1,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Text('${getTranslated('order_id', Get.context!)}#${orderIds[0]}',
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color))
                  )
                ),

                JustTheTooltip(
                  backgroundColor: Colors.black87,
                  controller: tooltipController,
                  preferredDirection: AxisDirection.down,
                  tailLength: 10,
                  tailBaseWidth: 20,
                  content: Container(width: 90,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Text(getTranslated('copied', context)!,
                      style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault)
                    )
                  ),
                  child: GestureDetector(onTap: () async {
                    tooltipController.showTooltip();
                    await Clipboard.setData(ClipboardData(text: '${getTranslated('order_id', Get.context!)}#${orderIds[0]}'));
                  },
                    child: Container(width: 85, height: 40, alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(60)),
                      child: Text('${getTranslated('copy', context)}', style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white.withValues(alpha:0.9))
                      )
                    )
                  ),
                )
              ])
            ) :
              Container(
              //height: 155,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                 border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.50))
               ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimensions.radiusDefault),
                          topRight: Radius.circular(Dimensions.radiusDefault),
                        ),
                        color: Theme.of(context).hintColor.withValues(alpha: 0.05)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${getTranslated('order', Get.context!)}',
                            textAlign: TextAlign.center,
                            style: titilliumBold.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),

                          Text(
                            '${getTranslated('invoice', Get.context!)}',
                            textAlign: TextAlign.center,
                            style: titilliumBold.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                    ),


                    SizedBox(
                      height: orderIds.length == 2 ? 100 : orderIds.length == 3 ? 150 : orderIds.length <= 4 ? 200 : 200,
                      child: ListView.builder(
                        itemCount: (orderIds.length),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withValues(alpha: 0.01)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${getTranslated('order_id', Get.context!)}#${orderIds[index]}',
                                      textAlign: TextAlign.center,
                                      style: titleRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.paddingSizeSmall),

                                    JustTheTooltip(
                                      key:  Key(orderIds[index].toString()) ,
                                      backgroundColor: Colors.black87,
                                      controller: toolTipControllers[index],
                                      preferredDirection: AxisDirection.down,
                                      tailLength: 10,
                                      tailBaseWidth: 20,
                                      content: Container(width: 90,
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        child: Text(getTranslated('copied', context)!,
                                          style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault)
                                        )
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          toolTipControllers[index].showTooltip();
                                          await Clipboard.setData(ClipboardData(text: '${getTranslated('order_id', Get.context!)}#${orderIds[index]}'));
                                        },
                                        child: CustomAssetImageWidget(Images.copy, height: 20, width: 20)
                                      ),
                                    )
                                  ],
                                ),

                                Consumer<OrderDetailsController>(
                                  builder: (context, orderTrackingProvider, _) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          orderId = orderIds[index].toString();
                                        });
                                        Provider.of<OrderDetailsController>(context, listen: false).getOrderInvoice(orderIds[index].toString(), context);
                                      },
                                      child:  orderTrackingProvider.isInvoiceLoading &&  orderId == orderIds[index].toString() ?
                                      SizedBox(height: 20, width: 20,  child: CircularProgressIndicator(strokeWidth: 1, color: Theme.of(context).primaryColor)) :
                                      CustomAssetImageWidget(Images.invoiceDownloadIconGuest, height: 20, width: 20)
                                    );
                                  }
                                )


                              ],
                            ),
                          );
                        }
                      ),
                    ),




                  ],
                ),
              ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge)
          ],



          // Provider.of<AuthController>(context, listen: false).isLoggedIn()
          // orderProvider.getOrderInvoice(orderProvider.orders!.id.toString(), context);


          if(!isLoggedIn && orderIds.length == 1)...[
            Consumer<OrderDetailsController>(
              builder: (context, orderTrackingProvider, _) {
                return Center(
                  child: ShimmerOverlayWrapper(
                    isActive: (orderTrackingProvider.isInvoiceLoading),
                    opacity: 0.3,
                    baseColor: Theme.of(context).hintColor.withValues(alpha: 0.7),
                    highlightColor : Theme.of(context).primaryColor.withValues(alpha: 1),
                    child: InkWell(
                      onTap: (){
                        Provider.of<OrderDetailsController>(context, listen: false).getOrderInvoice(
                          Provider.of<CheckoutController>(context, listen: false).getFirstOrderId(widget.orderID!)!, context
                        );
                      },
                      child: Opacity(
                        opacity: orderTrackingProvider.isInvoiceLoading ? 0.3 : 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomAssetImageWidget(Images.downlooadInvoiceIcon, height: 15, width: 15),
                            SizedBox(width: Dimensions.paddingSizeSmall),

                            Text(
                              '${getTranslated('download_invoice_title', Get.context!)}',
                              textAlign: TextAlign.center,
                              style: titilliumSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ],


          if(isLoggedIn)...[
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            SizedBox(
              height: 45, width: 200,
              child: CustomButton(
                radius: 5,
                buttonText: getTranslated('explore_more_items', context),
                onTap: () {
                  RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page: 'home');
                },
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge)
          ],

        ],
      ),
    );
  }


  List<int> convertToIntList(String input) {
    if (input.trim().isEmpty) return [];

    return input.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).map(int.parse).toList();
  }

}



class ShimmerOverlayWrapper extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final double opacity;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerOverlayWrapper({
    super.key,
    required this.child,
    this.isActive = false,
    this.opacity = 0.3,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isActive)
          Positioned.fill(
            child: Opacity(
              opacity: opacity,
              child: Shimmer.fromColors(
                baseColor: baseColor ?? Theme.of(context).primaryColor,
                highlightColor: highlightColor ?? Colors.grey[100]!,
                child: Container(color: Colors.white), // shimmer overlay
              ),
            ),
          ),
      ],
    );
  }
}



