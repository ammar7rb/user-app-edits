import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/track_order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/tracking/widgets/status_stepper_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';

class TrackingResultScreen extends StatefulWidget {
  final String orderID;
  const TrackingResultScreen({super.key, required this.orderID});

  @override
  State<TrackingResultScreen> createState() => _TrackingResultScreenState();
}

class _TrackingResultScreenState extends State<TrackingResultScreen> {
  TrackingHistory? trackingHistory;
  late bool isDigitalOrder;
  late bool isOrderFailed;

  @override
  void initState() {
    Provider.of<OrderController>(context, listen: false).initTrackingInfo(widget.orderID);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('TRACK_ORDER', context)),
      body: Column(children: [

        Expanded(
          child: Consumer<OrderDetailsController>(
            builder: (context, tracking, child) {
              trackingHistory = tracking.trackOrderDetailsModel?.history;
              isDigitalOrder = tracking.trackOrderDetailsModel?.isDigitalOrder ?? false;

              isOrderFailed = (trackingHistory?.orderCanceled?.status ?? false)
                || (trackingHistory?.orderFailed?.status ?? false)
                || (trackingHistory?.orderReturned?.status ?? false);


              return tracking.trackOrderDetailsModel != null ?
              ListView( children: [
                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Center(child: RichText(
                    text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: '${getTranslated('your_order', context)}',
                        style: textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                      TextSpan(text: '  #${widget.orderID}',
                        style: textBold.copyWith(color: Theme.of(context).primaryColor)
                      )

                      ])

                    )
                  )
                ),





                  Container(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                    margin: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
                    ),
                    child: Column(
                      children: [
                        StatusStepperWidget(
                          title: getTranslated('order_placed', context),
                          icon: Images.orderPlacedIconTimeline, checked: true,
                          dateTime: trackingHistory?.orderPlaced?.dateTime,
                          isCanceled: isOrderFailed,
                          isNextTrue: trackingHistory?.orderConfirmed?.status ?? false,
                        ),

                        if((trackingHistory?.orderPlaced!.status ?? true) && (isOrderFailed) && !(trackingHistory?.orderConfirmed?.status ?? false) )
                          CanceledStatusWidget(),

                        StatusStepperWidget(
                          title: '${getTranslated('order_confirmed', context)}',
                          icon: Images.orderConfirmedIconTimeline,
                          dateTime: trackingHistory?.orderConfirmed?.dateTime,
                          isCanceled: isOrderFailed,
                          checked: trackingHistory?.orderConfirmed?.status ?? false,
                          isNextTrue: trackingHistory?.preparingForShipment?.status ?? false,
                        ),

                        if((trackingHistory?.orderConfirmed!.status ?? true) && (isOrderFailed) && !(trackingHistory?.preparingForShipment?.status ?? false) )
                          CanceledStatusWidget(),

                        if(!isDigitalOrder)
                          StatusStepperWidget(
                            title: '${getTranslated('preparing_for_shipment', context)}',
                            icon: Images.prepareingForShippingIconTimeline,
                            dateTime: trackingHistory?.preparingForShipment?.dateTime,
                            isCanceled: isOrderFailed,
                            checked: trackingHistory?.preparingForShipment?.status ?? false,
                            isNextTrue: trackingHistory?.orderIsOnTheWay?.status ?? false,
                          ),

                        if(!isDigitalOrder &&  (trackingHistory?.preparingForShipment!.status ?? true) && (isOrderFailed) && !(trackingHistory?.orderIsOnTheWay?.status ?? false))
                          CanceledStatusWidget(),


                        if(!isDigitalOrder)
                          StatusStepperWidget(
                            title: '${getTranslated('order_is_on_the_way', context)}',
                            statusKey: trackingHistory?.orderIsOnTheWay?.key,
                            icon: Images.onTheWayIconTimeline,
                            dateTime: trackingHistory?.orderIsOnTheWay?.dateTime,
                            isCanceled: isOrderFailed,
                            checked: trackingHistory?.orderIsOnTheWay?.status ?? false,
                            isNextTrue: trackingHistory?.orderDelivered?.status ?? false,
                          ),


                        if(!isDigitalOrder &&  (trackingHistory?.orderIsOnTheWay!.status ?? true) && (isOrderFailed) && !(trackingHistory?.orderDelivered?.status ?? false))
                          CanceledStatusWidget(),

                        StatusStepperWidget(
                          title: '${getTranslated('order_delivered', context)}',
                          icon: Images.deliverdIconTimeline,
                          dateTime: trackingHistory?.orderDelivered?.dateTime,
                          isCanceled: trackingHistory?.orderCanceled?.status ?? false,
                          checked: trackingHistory?.orderDelivered?.status ?? false,
                          isLastItem: true,
                        ),


                      ],
                    ),
                  ),
                ]) : const Center(child: CircularProgressIndicator());


            },
          ),
        ),


        ],
      ),
    );
  }
}



class CanceledStatusWidget extends StatelessWidget {
  const CanceledStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderDetailsController>(
      builder: (context, tracking, child) {
        TrackingHistory? trackingHistory = tracking.trackOrderDetailsModel?.history;

        OrderPlaced ? orderPlaced = (trackingHistory?.orderFailed?.status ?? false) ?
        trackingHistory?.orderFailed : (trackingHistory?.orderReturned?.status ?? false) ?
        trackingHistory?.orderReturned : (trackingHistory?.orderCanceled?.status ?? false) ?
        trackingHistory?.orderCanceled : null;

        return StatusStepperWidget(
          title: '${getTranslated(orderPlaced?.key, context)}',
          icon: Images.cancel,
          dateTime: orderPlaced?.dateTime,
          isCanceled: orderPlaced?.status ?? false,
          checked:  true,
          isStatusCanceled: true,
          isNextTrue: false,
          isLastItem: false,
        );
      }
    );
  }
}


