import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/shop_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/rating_bar_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShopInfoWidget extends StatefulWidget {
  final String sellerId;
  const ShopInfoWidget({super.key, required this.sellerId});

  @override
  State<ShopInfoWidget> createState() => _ShopInfoWidgetState();
}

class _ShopInfoWidgetState extends State<ShopInfoWidget> {
  @override
  void initState() {
    Provider.of<ShopController>(context, listen: false).getSellerInfoProductDetails(widget.sellerId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double sellerIconSize = 50;

    return Consumer<ShopController>(
      builder: (context, seller, child) {
        final bool isVacationActive = ShopHelper.isVacationActive(
          context, startDate: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationStartDate,
          endDate: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationEndDate,
          vacationDurationType: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationDurationType,
          vacationStatus: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationStatus,
          isInHouseSeller: widget.sellerId == '0',
        );

        return seller.sellerInfoModelProductDetails != null ?
        Container(margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
            Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, 0),
          color: Theme.of(context).cardColor,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(children: [
                  Container(
                    width: sellerIconSize,height: sellerIconSize,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(sellerIconSize), border: Border.all(width: .5,color: Theme.of(context).hintColor)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(sellerIconSize),
                      child: CustomImageWidget(image: seller.sellerInfoModelProductDetails?.seller != null
                        ? '${seller.sellerInfoModelProductDetails?.seller?.shop?.imageFullUrl?.path}'
                        : "${Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.imageFullUrl?.path}"),
                    ),
                  ),

                  if(isVacationActive || (seller.sellerInfoModelProductDetails?.seller?.shop?.temporaryClose ?? false))
                    Positioned.fill(child: Align(alignment: Alignment.center,
                      child: Stack(children: [
                        Container(decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha:.5),
                          borderRadius: BorderRadius.circular(sellerIconSize),
                        )),

                        Center(child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          child: Text(
                            getTranslated( 'close_for_now', context)!,
                            textAlign: TextAlign.center,
                            style: textRegular.copyWith(color: Colors.white, fontSize: 8),
                          ),
                        ))
                      ]),
                    )),
                ]),
                const SizedBox(width: Dimensions.paddingSizeSmall),


                Expanded(
                  child: Column(children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: InkWell(
                        onTap: () {
                          log("==id11=>${seller.sellerInfoModelProductDetails?.seller?.toJson()}");
                          if(seller.sellerInfoModelProductDetails?.seller != null) {
                            RouterHelper.getTopSellerRoute (
                              action: RouteAction.push,
                              slug: seller.sellerInfoModelProductDetails?.seller?.shop?.slug,
                              sellerId:  seller.sellerInfoModelProductDetails?.seller?.id,
                              temporaryClose: seller.sellerInfoModelProductDetails?.seller?.shop?.temporaryClose??false,
                              vacationStatus: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationStatus??false,
                              vacationEndDate: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationEndDate,
                              vacationStartDate: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationStartDate,
                              vacationDurationType: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationDurationType,
                              name: seller.sellerInfoModelProductDetails?.seller?.shop?.name,
                              banner: seller.sellerInfoModelProductDetails?.seller?.shop?.bannerFullUrl?.path,
                              image: seller.sellerInfoModelProductDetails?.seller?.shop?.imageFullUrl?.path
                            );
                          } else {
                            log("==SellerId==>${seller.sellerInfoModelProductDetails?.seller?.toJson()}");
                            RouterHelper.getTopSellerRoute (
                              slug: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.slug,
                              sellerId: 0,
                              temporaryClose: Provider.of<SplashController>(context, listen: false).configModel?.inhouseTemporaryClose?.status ?? false,
                              vacationStatus: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.status,
                              vacationEndDate: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationEndDate,
                              vacationStartDate: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationStartDate,
                              vacationDurationType: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationDurationType,
                              name: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name,
                              banner: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.bannerFullUrl?.path,
                              image: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.imageFullUrl?.path
                            );
                          }
                        },
                        child: Column(mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(seller.sellerInfoModelProductDetails != null ? seller.sellerInfoModelProductDetails?.seller?.shop?.name ?? '${Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name}'  : '${Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name}',
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                            if((int.tryParse(seller.sellerInfoModelProductDetails?.avgRating ?? '0') ?? 0) > 0)
                            Row(children: [
                              RatingBar(rating: seller.sellerInfoModelProductDetails != null ? double.parse(seller.sellerInfoModelProductDetails!.avgRating.toString()) : 0),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              Text(seller.sellerInfoModelProductDetails != null ?
                              '(${seller.sellerInfoModelProductDetails?.totalReview})' : '',
                              style: titleRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).hintColor)
                            )])
                          ]
                        )
                      )),

                      SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      InkWell(
                        onTap: () {
                          if(!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                            showModalBottomSheet(context: context, builder: (_) => NotLoggedInBottomSheetWidget(fromPage: RouterHelper.productDetailsScreen));
                          }else if(seller.sellerInfoModelProductDetails != null && ((seller.sellerInfoModelProductDetails?.seller?.shop?.temporaryClose ?? false))){
                            showCustomSnackBarWidget(getTranslated('this_shop_is_close_now', context), context, snackBarType: SnackBarType.error);
                          }
                          else if(seller.sellerInfoModelProductDetails != null) {
                            Provider.of<ChatController>(context, listen: false).setUserTypeIndex(context, 1);
                            if(seller.sellerInfoModelProductDetails?.seller != null){
                              RouterHelper.getChatScreenRoute(
                                action: RouteAction.push,
                                id: seller.sellerInfoModelProductDetails?.seller?.id,
                                name: seller.sellerInfoModelProductDetails?.seller?.shop?.name ?? '',
                                userType: 1,
                                image: seller.sellerInfoModelProductDetails?.seller?.shop?.imageFullUrl?.path ?? '',
                                isShopOnVacation: isVacationActive,
                                isShopTemporaryClosed: seller.sellerInfoModelProductDetails?.seller?.shop?.temporaryClose ?? false,
                              );
                            }else{
                              RouterHelper.getChatScreenRoute(
                                action: RouteAction.push,
                                id: 0,
                                name: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name ?? '',
                                userType: 1,
                                image: "${Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.imageFullUrl?.path}",
                                isShopOnVacation: isVacationActive,
                                isShopTemporaryClosed: Provider.of<SplashController>(context, listen: false).configModel?.inhouseTemporaryClose?.status ?? false,
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.30) ),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                          ),
                          child: const CustomAssetImageWidget(Images.storeChatIcon, height: 20, width: 20)
                        ),
                      ),
                    ]),

                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  ]),
                ),

                ],
              ),

            seller.sellerInfoModelProductDetails != null?
            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: IntrinsicHeight(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                  if((seller.sellerInfoModelProductDetails!.totalReview ?? 0) > 0)
                  Row(children: [
                    Text(seller.sellerInfoModelProductDetails!.totalReview.toString(),
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                    Text(getTranslated('reviews', context)!,
                      style: titleRegular.copyWith(color: Theme.of(context).hintColor))
                    ]
                  ),

                  if((seller.sellerInfoModelProductDetails!.totalReview ?? 0) > 0)
                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Container(width: 1, height: 10, color: Provider.of<ThemeController>(context).darkTheme ?
                    Theme.of(context).highlightColor.withValues(alpha: 0.70) :
                    Theme.of(context).highlightColor)),

                  if((seller.sellerInfoModelProductDetails!.totalReview ?? 0) > 0)
                  VerticalDivider(
                    width: 30.0,
                    thickness: 1.0,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.30),
                    indent: 0.0,
                    endIndent: 0.0,
                  ),

                  Row(children: [
                    Text(NumberFormat.compact().format(seller.sellerInfoModelProductDetails!.totalProduct),
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color),),
                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                    Text(getTranslated('products', context)!,
                      style: titleRegular.copyWith(color: Theme.of(context).hintColor))])
                ]),
              ),
            ):const SizedBox(),

            Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child: InkWell(onTap: (){
                log("==id11=>${seller.sellerInfoModelProductDetails?.seller?.toJson()}");
                if(seller.sellerInfoModelProductDetails?.seller != null){
                  log("==id00=>${seller.sellerInfoModelProductDetails?.seller?.toJson()}");

                  RouterHelper.getTopSellerRoute(
                    action: RouteAction.push,
                    slug: seller.sellerInfoModelProductDetails?.seller?.shop?.slug,
                    sellerId:  seller.sellerInfoModelProductDetails?.seller?.id,
                    temporaryClose: seller.sellerInfoModelProductDetails?.seller?.shop?.temporaryClose??false,
                    vacationStatus: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationStatus??false,
                    vacationEndDate: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationEndDate,
                    vacationStartDate: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationStartDate,
                    vacationDurationType: seller.sellerInfoModelProductDetails?.seller?.shop?.vacationDurationType,
                    name: seller.sellerInfoModelProductDetails?.seller?.shop?.name,
                    banner: seller.sellerInfoModelProductDetails?.seller?.shop?.bannerFullUrl?.path,
                    image: seller.sellerInfoModelProductDetails?.seller?.shop?.imageFullUrl?.path
                  );
                } else {
                  log("==id22=>${seller.sellerInfoModelProductDetails?.seller?.toJson()}");
                  RouterHelper.getTopSellerRoute(
                    action: RouteAction.push,
                    slug: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.slug,
                    sellerId: 0,
                    temporaryClose: Provider.of<SplashController>(context, listen: false).configModel?.inhouseTemporaryClose?.status ?? false,
                    vacationStatus: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.status,
                    vacationEndDate: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationEndDate,
                    vacationStartDate: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationStartDate,
                    vacationDurationType: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationDurationType,
                    name: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name,
                    banner: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.bannerFullUrl?.path,
                    image: Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.imageFullUrl?.path
                  );
                }
              },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                  child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: SizedBox(width: 20, child: Image.asset(Images.storeIcon, color: Theme.of(context).cardColor))),
                      Text(getTranslated('visit_store', context)!,
                        style: titilliumBold.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeLarge)),
                    ],
                  )),
                ),
              ),
            )
            ],
          ),
        ):const SizedBox();
      },
    );
  }
}
