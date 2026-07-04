import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/domain/models/shipping_method_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:provider/provider.dart';

class ShippingMethodBottomSheetWidget extends StatefulWidget {
  final String? groupId;
  final int? sellerId;
  final int sellerIndex;
  const ShippingMethodBottomSheetWidget({super.key, required this.groupId, required this.sellerId, required this.sellerIndex});

  @override
  ShippingMethodBottomSheetWidgetState createState() => ShippingMethodBottomSheetWidgetState();
}

class ShippingMethodBottomSheetWidgetState extends State<ShippingMethodBottomSheetWidget> {
  int selectedIndex = 0;
  @override
  void initState() {
    if(Provider.of<ShippingController>(context, listen: false).shippingList != null &&
        Provider.of<ShippingController>(context, listen: false).shippingList!.isNotEmpty){
      selectedIndex = Provider.of<ShippingController>(context, listen: false).shippingList![widget.sellerIndex].shippingIndex??0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 50.0),
      child: Container(padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeDefault), ),),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 5, width: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),


            Align(
              alignment: Alignment.centerRight, child: InkWell(onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).hintColor.withValues(alpha: 0.2),
                ),
                child: Padding(padding: EdgeInsets.all(Dimensions.paddingSizeExtraExtraSmall), child: Icon(Icons.close, size: 20, color: Theme.of(context).hintColor))
              )
            )),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(getTranslated('select_shipping_method', context)!, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),

                  Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall),
                    child: Text('${getTranslated('choose_a_method_for_your_delivery', context)}', style: textRegular.copyWith(color: Theme.of(context).hintColor))
                  ),
                ],
              ),
            ),


            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Consumer<ShippingController>(
                builder: (context, shippingController, child) {
                  return shippingController.isLoading ? const Center(child: CircularProgressIndicator()) :
                    (shippingController.shippingList != null && shippingController.shippingList!.isNotEmpty &&
                      shippingController.shippingList![widget.sellerIndex].shippingMethodList != null) ?
                  ( shippingController.shippingList![widget.sellerIndex].shippingMethodList!.isNotEmpty) ?
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: shippingController.shippingList![widget.sellerIndex].shippingMethodList!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            border:
                            selectedIndex == index ?
                            Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.50), width: 1):
                            Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.25),width: .5),
                            color: selectedIndex == index ? Theme.of(context).primaryColor.withValues(alpha: 0.05): Theme.of(context).cardColor),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Padding(padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  selectedIndex == index?
                                  Icon(Icons.radio_button_checked, color: Theme.of(context).primaryColor): Icon(Icons.circle_outlined,
                                    color: Theme.of(context).colorScheme.tertiaryContainer),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                  Expanded(child: Text('${shippingController.shippingList![widget.sellerIndex].shippingMethodList![index].title}'
                                      ' (Duration ${shippingController.shippingList![widget.sellerIndex].shippingMethodList![index].duration})',
                                    style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                                  ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  Text(' ${PriceConverter.convertPrice(context, shippingController.shippingList![widget.sellerIndex].shippingMethodList![index].cost)}',
                                    style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color))
                                ])
                              )
                            )

                          ),
                        );
                      },
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault,),
                    shippingController.isLoading ? const Center(child: CircularProgressIndicator()) :
                    CustomButton(buttonText: '${getTranslated('select', context)}', onTap: (){
                      Provider.of<ShippingController>(context, listen: false).setSelectedShippingMethod(selectedIndex, widget.sellerIndex);
                      ShippingMethodModel shipping = ShippingMethodModel();
                      shipping.id = shippingController.shippingList![widget.sellerIndex].shippingMethodList![selectedIndex].id;
                      shipping.duration = widget.groupId;
                      shippingController.isLoading ? const Center(child: CircularProgressIndicator()) :
                      shippingController.addShippingMethod(context, shipping.id, shipping.duration);
                    })]) :
                  Center(child: Text('${getTranslated('no_shipping_method_available', context)}')) : const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
