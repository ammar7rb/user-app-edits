import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_asset_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/shop_helper.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';

class SellerSectionWidget extends StatelessWidget {
  final OrderDetailsController? order;
  const SellerSectionWidget({super.key, this.order});

  @override
  Widget build(BuildContext context) {

    bool isVacationActive = false;

    if (order?.orderDetails != null && order!.orderDetails![0].seller != null) {
      isVacationActive = ShopHelper.isVacationActive(
          context, startDate: order!.orderDetails![0].seller?.shop?.vacationStartDate,
          endDate: order!.orderDetails![0].seller?.shop?.vacationEndDate,
          vacationDurationType: order!.orderDetails![0].seller?.shop?.vacationDurationType,
          vacationStatus: order!.orderDetails![0].seller?.shop?.vacationStatus,
          isInHouseSeller: order!.orderDetails![0].order?.sellerIs == 'admin'
      );
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.2), spreadRadius:1.5, blurRadius: 3)],
        color: Theme.of(context).cardColor,
      ),

      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Row(children: [
              OrderSellerInfoWidget(
                orderDetails: order?.orderDetails != null && order!.orderDetails!.isNotEmpty ? order!.orderDetails![0] : null,
              ),
              const Spacer(),
              InkWell(
                  onTap: () {
                    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()){
                      Provider.of<ChatController>(context, listen: false).setUserTypeIndex(context, 1);
                      if((order!.orderDetails![0].seller != null && ((order!.orderDetails![0].seller?.shop?.temporaryClose ?? false)))) {
                        showCustomSnackBarWidget(getTranslated("this_shop_is_close_now", context), context, snackBarType: SnackBarType.error);
                      } else if(order!.orderDetails![0].seller != null) {
                        RouterHelper.getChatScreenRoute(
                          action: RouteAction.push,
                          id: order!.orderDetails![0].order?.sellerIs == 'admin' ? 0 : order!.orderDetails![0].seller!.id,
                          name: order!.orderDetails![0].order?.sellerIs == 'admin'
                              ? "${Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name}"
                              : order!.orderDetails![0].seller!.shop!.name,
                          image: order!.orderDetails![0].order?.sellerIs == 'admin'
                              ? "${Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.imageFullUrl?.path}"
                              : order!.orderDetails![0].seller?.shop?.imageFullUrl?.path,
                          isShopOnVacation: isVacationActive,
                          isShopTemporaryClosed: order!.orderDetails![0].seller?.shop?.temporaryClose ?? false,
                        );
                      } else {
                        showCustomSnackBarWidget(getTranslated('seller_not_available', context), Get.context!, snackBarType: SnackBarType.error);
                      }
                    }else{
                      showModalBottomSheet(backgroundColor: Colors.transparent, context: context, builder: (_)=> const NotLoggedInBottomSheetWidget());}
                  },
                  child: const SizedBox(width: Dimensions.iconSizeDefault, child: CustomAssetImageWidget(Images.storeChatIcon, height: 20, width: 20)))
            ]),
          ),
        ),

        Divider(thickness: .25, color: Theme.of(context).primaryColor.withValues(alpha:0.50)),

      ]),
    );
  }
}

class OrderSellerInfoWidget extends StatelessWidget {
  final OrderDetailsModel? orderDetails;
  final double widthFactor;

  const OrderSellerInfoWidget({
    super.key,
    required this.orderDetails,
    this.widthFactor = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    if (orderDetails == null) {
      return const SizedBox();
    }

    final bool isAdmin = orderDetails?.order?.sellerIs == 'admin';

    final String sellerName = isAdmin
        ? Provider.of<SplashController>(context, listen: false).configModel?.inHouseShop?.name ??
        '' : orderDetails?.seller?.shop?.name ?? getTranslated('seller_not_available', context) ?? '';

    return InkWell(
      onTap: () {
        final seller = orderDetails?.seller;
        final isAdmin = orderDetails?.order?.sellerIs == 'admin';

        if (seller != null && !isAdmin) {
          RouterHelper.getTopSellerRoute(
            action: RouteAction.push,
            slug: seller.shop?.slug,
            sellerId: seller.id,
            temporaryClose: seller.shop?.temporaryClose ?? false,
            vacationStatus: seller.shop?.vacationStatus ?? false,
            vacationEndDate: seller.shop?.vacationEndDate,
            vacationStartDate: seller.shop?.vacationStartDate,
            vacationDurationType: seller.shop?.vacationDurationType,
            name: seller.shop?.name,
            banner: seller.shop?.bannerFullUrl?.path,
            image: seller.shop?.imageFullUrl?.path,
          );
        } else {
          final splash = context.read<SplashController>();
          RouterHelper.getTopSellerRoute(
            action: RouteAction.push,
            slug: splash.configModel?.inHouseShop?.slug,
            sellerId: 0,
            temporaryClose: splash.configModel?.inhouseTemporaryClose?.status ?? false,
            vacationStatus: splash.configModel?.inhouseVacationAdd?.status,
            vacationEndDate: splash.configModel?.inhouseVacationAdd?.vacationEndDate,
            vacationStartDate: splash.configModel?.inhouseVacationAdd?.vacationStartDate,
            vacationDurationType: splash.configModel?.inhouseVacationAdd?.vacationDurationType,
            name: splash.configModel?.inHouseShop?.name,
            banner: splash.configModel?.inHouseShop?.bannerFullUrl?.path,
            image: splash.configModel?.inHouseShop?.imageFullUrl?.path,
          );
        }
      },
      child: Row(
        children: [
          CustomAssetImageWidget(Images.vendorIcon, color: Theme.of(context).primaryColor, height: 20,),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          SizedBox(
            width: MediaQuery.of(context).size.width * widthFactor,
            child: Text(
              sellerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textRegular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
