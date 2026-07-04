import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/create_account_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';


class ShippingDetailsWidget extends StatefulWidget {
  final bool hasPhysical;
  final bool billingAddress;
  final GlobalKey<FormState> passwordFormKey;

  const ShippingDetailsWidget({super.key, required this.hasPhysical, required this.billingAddress, required this.passwordFormKey});

  @override
  State<ShippingDetailsWidget> createState() => _ShippingDetailsWidgetState();
}

class _ShippingDetailsWidgetState extends State<ShippingDetailsWidget> {

  @override
  Widget build(BuildContext context) {
    bool isGuestMode = !Provider.of<AuthController>(context, listen: false).isLoggedIn();
    return Consumer<CheckoutController>(
        builder: (context, shippingProvider,_) {
          if(shippingProvider.sameAsBilling && !widget.hasPhysical) {
            shippingProvider.setSameAsBilling(isUpdate: false);
          }
          
          return Consumer<AddressController>(
            builder: (context, locationProvider, _) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                widget.hasPhysical?
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.3), spreadRadius:2, blurRadius: 10)],
                    color: Theme.of(context).cardColor,
                  ),
                  child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [

                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start, children: [
                        Expanded(
                          child: Row(
                            children: [
                              CustomAssetImageWidget(Images.deliveryTo, height: 20, width: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                  '${getTranslated('delivery_to', context)}',
                                  style: textMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                        InkWell(
                          onTap: () {
                            RouterHelper.getSavedAddressListRoute(fromGuest: isGuestMode);
                          },
                          child: SizedBox(width: 20, child: Image.asset(Images.edit,
                            scale: 3, color: Theme.of(context).primaryColor,)),
                        ),]
                      ),
                    ),

                    SizedBox(height: 1, child: const Divider(thickness: .200)),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      (shippingProvider.addressIndex != null && locationProvider.addressList != null && locationProvider.addressList!.isNotEmpty) ?
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${getTranslated('name', context)} : ',
                                      style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium?.color),
                                    ),

                                    Expanded(
                                      child: Text(
                                        locationProvider.addressList![shippingProvider.addressIndex!].contactPersonName ?? '',
                                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color,  overflow: TextOverflow.ellipsis),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${getTranslated('phone', context)} : ',
                                      style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.titleMedium?.color,),
                                    ),

                                    Expanded(
                                      child: Text(
                                        locationProvider.addressList![shippingProvider.addressIndex!].phone ?? '',
                                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color,  overflow: TextOverflow.ellipsis),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Dimensions.paddingSizeDefault),

                          Container(
                            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.07)
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                CustomAssetImageWidget(Images.savedAddressLocationIcon, height: 20, width: 20),
                                SizedBox(width: Dimensions.paddingSizeSmall),

                                Text(
                                  '${locationProvider.addressList![shippingProvider.addressIndex!].addressType ?? ''}: ',
                                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                                ),

                                Expanded(
                                  child: Text(
                                    '${locationProvider.addressList![shippingProvider.addressIndex!].address ?? ''}: ',
                                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color, overflow: TextOverflow.ellipsis), maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.paddingSizeDefault),
                        ]),
                      ) : SizedBox(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(children: []),

                            CustomAssetImageWidget(Images.deliveryTo, height: 30, width: 30, color: Theme.of(context).hintColor),
                            SizedBox(height: Dimensions.paddingSizeSmall),

                            Text(
                              '${getTranslated('please_set_your_delivery_info', context)}',
                              style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor,),
                            ),
                          ],
                        ),
                      ),

                    ]),
                  ])
                ) : const SizedBox(),
                SizedBox(height: widget.hasPhysical? Dimensions.paddingSizeSmall:0),


                isGuestMode ? (widget.hasPhysical)?
                CreateAccountWidget(formKey: widget.passwordFormKey) : const SizedBox() : const SizedBox(),


                isGuestMode ? const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),
                if(widget.billingAddress || shippingProvider.sameAsBilling)
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.2), spreadRadius:3, blurRadius: 3)],
                    ),
                    child: Column(crossAxisAlignment:CrossAxisAlignment.start, children: [

                      Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.center, children: [
                          Expanded(
                            child: Row(
                              children: [
                                CustomAssetImageWidget(Images.billingTo, height: 20, width: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                    '${getTranslated('billing_to', context)}',
                                    style: textMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),



                          if(widget.hasPhysical && widget.billingAddress)
                            Container(
                              padding:  EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.07),
                              ),
                              child: InkWell(highlightColor: Colors.transparent,focusColor: Colors.transparent, splashColor: Colors.transparent,
                                onTap: ()=> shippingProvider.setSameAsBilling(),
                                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                  SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  SizedBox(width : 18, height : 18,
                                      child: Container(alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha:.75), width: 1.5),
                                            borderRadius: BorderRadius.circular(2),
                                            color: shippingProvider.sameAsBilling ?  Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                          ),
                                          child: Icon(CupertinoIcons.checkmark_alt,size: 15,
                                              color: shippingProvider.sameAsBilling ? Theme.of(context).cardColor : Colors.transparent)
                                      )
                                  ),


                                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                      child: Text(getTranslated('same_as_delivery', context)!,
                                          style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color))
                                  )

                                ]),
                              ),
                            ),

                          if(!shippingProvider.sameAsBilling)
                            SizedBox(width: Dimensions.paddingSizeSmall),

                          if(!shippingProvider.sameAsBilling)
                            InkWell(
                              onTap: () => RouterHelper.getSavedBillingAddressListRoute(fromGuest: isGuestMode),
                              child: SizedBox(width: 20,child: Image.asset(Images.edit, scale: 3, color: Theme.of(context).primaryColor,)),
                            ),
                        ]),
                      ),

                      if(!shippingProvider.sameAsBilling)...[
                        SizedBox(height: 1, child: const Divider(thickness: .200)),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ],


                      if(!shippingProvider.sameAsBilling)
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          (shippingProvider.billingAddressIndex != null && (locationProvider.addressList?.isNotEmpty ?? false)) ?
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${getTranslated('name', context)} : ',
                                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodySmall?.color),
                                      ),

                                      Text(
                                        locationProvider.addressList![shippingProvider.billingAddressIndex!].contactPersonName ?? '',
                                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${getTranslated('phone', context)} : ',
                                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodySmall?.color),
                                      ),

                                      Text(
                                        locationProvider.addressList![shippingProvider.billingAddressIndex!].phone ?? '',
                                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.paddingSizeDefault),

                              Container(
                                padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.07)
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    CustomAssetImageWidget(Images.savedAddressLocationIcon, height: 20, width: 20),
                                    SizedBox(width: Dimensions.paddingSizeSmall),

                                    Text(
                                      '${locationProvider.addressList![shippingProvider.billingAddressIndex!].addressType ?? ''}: ',
                                      style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor),
                                    ),

                                    Expanded(
                                      child: Text(
                                        '${locationProvider.addressList![shippingProvider.billingAddressIndex!].address ?? ''}: ',
                                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge?.color, overflow: TextOverflow.ellipsis), maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimensions.paddingSizeDefault),
                            ]),
                          ) :
                          SizedBox(
                            height: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(children: []),
                                CustomAssetImageWidget(Images.deliveryTo, height: 30, width: 30, color: Theme.of(context).hintColor),
                                SizedBox(height: Dimensions.paddingSizeSmall),

                                Text(
                                  '${getTranslated('please_set_your_billing_info', context)}',
                                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor,),
                                ),
                              ],
                            ),
                          )
                        ]),

                    ]),
                  ),


                isGuestMode ? (!widget.hasPhysical)?
                CreateAccountWidget(formKey: widget.passwordFormKey) : const SizedBox() : const SizedBox(),




                ]);
            }
          );
        }
    );
  }
}

class AddressInfoItem extends StatelessWidget {
  final String? icon;
  final String? title;
  const AddressInfoItem({super.key, this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(children: [
        SizedBox(width: 18, child: Image.asset(icon!)),
        Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Text(title??'', style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color), maxLines: 2, overflow: TextOverflow.fade )))]),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}