
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/enums/vacation_duration_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart' show Get;
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShopInfoWidget extends StatelessWidget {
  final String slug = '';
  final bool vacationIsOn;
  final bool temporaryClose;
  final String sellerName;
  final int? sellerId;
  final int? totalReview;
  final int? totalProduct;
  final String? rating;
  final String banner;
  final String shopImage;
  final DateTime? vacationEndDate;
  final DateTime? vacationStartDate;
  final VacationDurationType? vacationDurationType;
  final bool fromMore;
  const ShopInfoWidget({super.key, required this.vacationIsOn, required this.sellerName,
    required this.sellerId, required this.banner, required this.shopImage, required this.temporaryClose, this.totalReview, this.totalProduct, this.rating, this.vacationEndDate, this.vacationStartDate, this.vacationDurationType, required this.fromMore});

  @override
  Widget build(BuildContext context) {

    var splashController = Provider.of<SplashController>(context, listen: false);
    return Column(children: [
      Stack(
        children: [
          CustomImageWidget(image: (sellerId == 0 || sellerId == null) ? splashController.configModel?.inHouseShop?.bannerFullUrl?.path ?? '' : banner,
            placeholder: Images.placeholder_3x1, width: MediaQuery.of(context).size.width, height: ResponsiveHelper.isTab(context)? 250 : 120),

         // if(Platform.isIOS)
          Positioned(
            top: 40,
            left: 15,
            child: InkWell(
              onTap: () {
                Provider.of<SellerProductController>(context, listen: false).clearSellerProducts();
                Provider.of<CategoryController>(Get.context!, listen: false).onUpdateFilteredCategoryList(isSeller: false);
                Provider.of<BrandController>(Get.context!, listen: false).onUpdateFiltererBrandList(isSeller: false);
                Provider.of<ShopController>(Get.context!, listen: false).nullShopInfoModel();
                Provider.of<CategoryController>(Get.context!, listen: false).uncheckSellerCategoryList();
                Provider.of<BrandController>(Get.context!, listen: false).uncheckSellerBrandList();
                if(sellerId == null) {
                  RouterHelper.getDashboardRoute(action: RouteAction.pushNamedAndRemoveUntil);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).cardColor
                ),
                height: 40, width: 40,
                child: Padding(
                  padding: EdgeInsetsGeometry.only(left: Dimensions.paddingSizeSmall),
                  child: const Icon(Icons.arrow_back_ios)),
              ),
            ),
          ),
        ],
      ),


        Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Container(transform: Matrix4.translationValues(0, -20, 0),
            padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).cardColor,
                boxShadow: Provider.of<ThemeController>(context,listen: false).darkTheme? null:
                [BoxShadow(color: Colors.grey.withValues(alpha:0.3), spreadRadius: 1, blurRadius: 5)]),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(children: [
                Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).highlightColor,
                    boxShadow: Provider.of<ThemeController>(context,listen: false).darkTheme? null:
                    [BoxShadow(color: Colors.grey.withValues(alpha:0.3), spreadRadius: 1, blurRadius: 5)]),
                  child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    child: CustomImageWidget(height: 80, width: 80, fit: BoxFit.cover,
                      image: (sellerId == 0 || sellerId == null) ?
                      splashController.configModel?.inHouseShop?.imageFullUrl?.path ?? '' :
                      shopImage,
                    ))),
                if(temporaryClose || vacationIsOn)
                  Container(width: 80,height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha:.5),
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),)),

                temporaryClose?
                Positioned(top: 0,bottom: 0,left: 0,right: 0,
                  child: Align(alignment: Alignment.center,
                      child: Center(child: Text(getTranslated('temporary_closed', context)!.replaceAll(' ', '\n'), textAlign: TextAlign.center,
                          style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall))))):

                vacationIsOn?
                Positioned(top: 0,bottom: 0,left: 0,right: 0,
                  child: Align(alignment: Alignment.center,
                      child: Center(child: Text(getTranslated('close_for_now', context)!, textAlign: TextAlign.center,
                          style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall))))):
                const SizedBox()]),

              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(child: Consumer<ShopController>(
                  builder: (context, sellerProvider,_) {
                    String ratting = sellerProvider.sellerInfoModel != null && sellerProvider.sellerInfoModel!.avgRating != null?
                    sellerProvider.sellerInfoModel!.avgRating.toString() : "0";

                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(sellerName, style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color),
                            maxLines: 2, overflow: TextOverflow.ellipsis,),),

                          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: InkWell(onTap: () {
                              if(temporaryClose) {
                                showCustomSnackBarWidget("${getTranslated("this_shop_is_close_now", context)}", context, snackBarType: SnackBarType.warning);
                              }else{
                                if(!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                                  showModalBottomSheet(context: context, builder: (_) => NotLoggedInBottomSheetWidget(
                                    fromPage: RouterHelper.topSellerScreen,
                                    onLoginSuccess: () {
                                      RouterHelper.getTopSellerRoute(
                                        action: RouteAction.pushReplacement,
                                        slug: slug,
                                        sellerId: sellerId ?? 0,
                                        temporaryClose: temporaryClose,
                                        vacationStatus: vacationIsOn,
                                        vacationEndDate: vacationEndDate,
                                        vacationStartDate: vacationStartDate,
                                        vacationDurationType: vacationDurationType,
                                        name: sellerName,
                                        banner: banner,
                                        image: shopImage,
                                        fromMore: fromMore,
                                        totalReview: totalReview,
                                        totalProduct: totalProduct,
                                      );
                                    },
                                  ));
                                }else  {
                                  Provider.of<ChatController>(context, listen: false).setUserTypeIndex(context, 1);
                                  RouterHelper.getChatScreenRoute(
                                    action: RouteAction.push,
                                    id: sellerId ?? 0,
                                    name: sellerName,
                                    userType: 1,
                                    isShopOnVacation: vacationIsOn,
                                    image: sellerId == 0 ? splashController.configModel?.inHouseShop?.imageFullUrl?.path ?? '' : shopImage,
                                  );
                                }
                              }
                            }, child : const CustomAssetImageWidget(Images.storeChatIcon, height: 20, width: 20)),
                          )]),


                        ((sellerProvider.sellerInfoModel != null) || (rating != null && totalProduct != null && totalReview != null)) ?
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            const Icon(Icons.star_rate_rounded, color: Colors.orange),
                            Text(double.parse(rating ?? ratting).toStringAsFixed(1), style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),

                            if(totalReview != null || sellerProvider.sellerInfoModel?.minimumOrderAmount != null && sellerProvider.sellerInfoModel!.minimumOrderAmount! > 0)
                            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Text('|', style: textRegular.copyWith(color: Theme.of(context).primaryColor),),),

                            if(totalReview != null || sellerProvider.sellerInfoModel?.minimumOrderAmount != null && sellerProvider.sellerInfoModel!.minimumOrderAmount! > 0)
                            Text('${totalReview ?? sellerProvider.sellerInfoModel!.totalReview} ${getTranslated('reviews', context)}',
                              style: titleRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).primaryColor),
                              maxLines: 1, overflow: TextOverflow.ellipsis)]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),


                          Row(children: [

                            (sellerProvider.sellerInfoModel?.minimumOrderAmount != null && sellerProvider.sellerInfoModel!.minimumOrderAmount! > 0)?
                            Text('${PriceConverter.convertPrice(context, sellerProvider.sellerInfoModel!.minimumOrderAmount)} '
                                '${getTranslated('minimum_order', context)}',
                              style: titleRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                              maxLines: 1, overflow: TextOverflow.ellipsis,):
                            Text('${totalReview ?? sellerProvider.sellerInfoModel!.totalReview} ${getTranslated('reviews', context)}',
                              style: titleRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis,),


                            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                              child: Text('|', style: textRegular.copyWith(color: Theme.of(context).primaryColor),),),

                            Text('${totalProduct ?? sellerProvider.sellerInfoModel!.totalProduct} ${getTranslated('products', context)}',
                              style: titleRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).primaryColor), maxLines: 1, overflow: TextOverflow.ellipsis)]),
                        ]):const SizedBox(),
                      ],
                      );
                    }
                ),
              ),

            ]),
          ),
        ),
      ],
    );
  }
}


class ShopInfoShimmerWidget extends StatelessWidget {
  const ShopInfoShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).cardColor,
      highlightColor: Theme.of(context).hintColor.withValues(alpha: .5),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            color: Colors.white,
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeDefault,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),


                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 15,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(height: 10),


                        Row(
                          children: [
                            Container(height: 12, width: 40, color: Colors.white),
                            const SizedBox(width: 10),
                            Container(height: 12, width: 80, color: Colors.white),
                          ],
                        ),
                        const SizedBox(height: 10),


                        Row(
                          children: [
                            Container(height: 12, width: 100, color: Colors.white),
                            const SizedBox(width: 10),
                            Container(height: 12, width: 60, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}