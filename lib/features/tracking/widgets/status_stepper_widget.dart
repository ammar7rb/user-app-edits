import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/tracking/widgets/line_dashed_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StatusStepperWidget extends StatelessWidget {
  final String? title;
  final bool isLastItem;
  final String icon;
  final bool checked;
  final String? dateTime;
  final bool isCanceled;
  final bool isNextTrue;
  final bool isStatusCanceled;
  final String? statusKey;

  const StatusStepperWidget({super.key,
    required this.title, this.isLastItem = false, required this.icon,
    this.checked = false, this.dateTime, this.isCanceled = false,
    this.isNextTrue = false, this.isStatusCanceled = false,
    this.statusKey
  });

  @override
  Widget build(BuildContext context) {
    Color myColor;
    if (checked && !isStatusCanceled) {
      myColor = Provider.of<ThemeController>(context, listen: false).darkTheme? Colors.white  : Theme.of(context).primaryColor;
    } else {
      myColor = Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).hintColor.withValues(alpha:.75) :
      Theme.of(context).hintColor;
    }

    bool isOrderOnTheWay = statusKey == 'order_is_on_the_way';
    // bool isOrderOnTheWay = true;

    return Container(height: 100,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [

              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Container(padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  color: Theme.of(context).primaryColor.withValues(alpha: .075)),
                  child: SizedBox(height: 30,child: CustomAssetImageWidget(icon, color: (checked || isStatusCanceled) ? Theme.of(context).primaryColor : Theme.of(context).hintColor)),
                )
              ),


              Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                checked ?
                Text(title!, style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color)) :
                Text(title!, style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),

                if(dateTime != null)
                Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                  child: Row(children: [
                    Text(DateConverter.dateTimeStringToDateAndTime(dateTime!), style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.titleMedium?.color?.withValues(alpha: 0.85))),
                  ])
                ),


                ])

              ]
            ),

            isLastItem ? const SizedBox.shrink() :
            isNextTrue || (!isNextTrue && isCanceled && !isStatusCanceled) ?
            Padding(padding: const EdgeInsets.only(
              top: Dimensions.paddingSizeExtraExtraSmall,
              bottom: Dimensions.paddingSizeExtraExtraSmall, left: 35
            ),
              child: CustomPaint(painter: LineSolidWidget(Theme.of(context).primaryColor))
            ) :
            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, left: 35),
              child: CustomPaint(painter: LineDashedWidget(myColor))
            )

            ]
          )
        ),



        if(isOrderOnTheWay && (!isNextTrue && !isCanceled) && checked)
          Consumer<OrderDetailsController>(
            builder: (context, orderProvider, child) {
              Orders? orderModel = orderProvider.orders;
              String? countryCode =  orderModel?.deliveryMan?.countryCode;
              String? phone =  orderModel?.deliveryMan?.phone;
              String? phoneWithCountryCode =  (countryCode ?? '') + (phone ?? '');
              String? name = '${orderModel?.deliveryMan?.fName!} ${orderModel?.deliveryMan?.lName}';
              int? id =   orderModel?.deliveryMan?.id;
              String? image =  orderModel?.deliveryMan?.imageFullUrl?.path;

              return  orderModel?.deliveryMan != null ? Container(
                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.05)
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Provider.of<ChatController>(context, listen: false).setUserTypeIndex(context, 0);
                        RouterHelper.getChatScreenRoute(
                          action: RouteAction.push,
                          image: image,
                          id: id,
                          name: name,
                          userType: 0,
                          isShopTemporaryClosed: false,
                          isShopOnVacation: false,
                        );
                      },
                      child: CustomAssetImageWidget(Images.storeChatIcon, height: 20, width: 20)
                    ),
                    SizedBox(width: Dimensions.paddingSizeSmall),

                    Container(height: 20, width: 1, color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.35) ),

                    SizedBox(width: Dimensions.paddingSizeSmall),
                    InkWell(
                      onTap: ()=> _launchUrl("tel:$phoneWithCountryCode"),
                      child: CustomAssetImageWidget(Images.deliverymanCallIcon, height: 20, width: 20)
                    ),

                  ],
                ),
              ) : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    child: Icon(isStatusCanceled ? Icons.cancel : CupertinoIcons.checkmark_alt_circle_fill, color: isStatusCanceled ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onTertiaryContainer)
                )
              );
            }
          ),
          


        if((checked || (isStatusCanceled))  && !(isOrderOnTheWay  && !isNextTrue && !isCanceled))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Icon(isStatusCanceled ? Icons.cancel : CupertinoIcons.checkmark_alt_circle_fill, color: isStatusCanceled ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onTertiaryContainer)
            )
          ),



      ]),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}