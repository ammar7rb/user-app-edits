import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/more/widgets/square_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class MoreHorizontalSection extends StatelessWidget {
  const MoreHorizontalSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel = Provider.of<SplashController>(context, listen: false).configModel;

    return Consumer<ProfileController>(builder: (context, profileProvider,_) {
      final bool isGuestMode = !Provider.of<AuthController>(context, listen: false).isLoggedIn();
      return SizedBox(height: ResponsiveHelper.isTab(context)? 135 :130, child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        child: Center(child: ListView(
          scrollDirection:Axis.horizontal,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            SquareButtonWidget(
              image: Images.offerIcon,
              title: getTranslated('offers', context),
              navigateTo: null,
              count: 0,
              hasCount: false,
              onTap: () {
                RouterHelper.getOfferProductListScreenRoute(action: RouteAction.push);
              },
            ),

            if(!isGuestMode && configModel?.walletStatus == 1)SquareButtonWidget(
              image: Images.wallet,
              title: getTranslated('wallet', context),
              navigateTo: null,
              onTap: () {
                RouterHelper.getWalletRoute(action: RouteAction.push, isBackButtonExist: true);
              },
              count: 1,
              hasCount: false,
              subTitle: 'amount',
              isWallet: true,
              balance: profileProvider.balance,
            ),


            if(!isGuestMode && configModel?.loyaltyPointStatus == 1) SquareButtonWidget(
              image: Images.loyaltyPoint,
              title: getTranslated('loyalty_point', context),
              onTap: () => RouterHelper.getLoyaltyPointScreenRoute(action: RouteAction.push),
              count: 1,
              hasCount: false,
              isWallet: true,
              subTitle: 'point',
              balance: profileProvider.loyaltyPoint, isLoyalty: true,
            ),


            if(!isGuestMode) SquareButtonWidget(
              image: Images.shoppingImage,
              title: getTranslated('orders', context),
              navigateTo: null,
              onTap: () {
                RouterHelper.getOrderScreenRoute(isBackButtonExist: true);
              },
              count: 1,
              hasCount: false,
              isWallet: true,
              subTitle: 'orders',
              balance: profileProvider.userInfoModel?.totalOrder ?? 0,
              isLoyalty: true,
            ),

            SquareButtonWidget(
              image: Images.cartImage,
              title: getTranslated('cart', context),
              onTap: () => RouterHelper.getCartScreenRoute(action: RouteAction.push),
              navigateTo: null,
              count: Provider.of<CartController>(context,listen: false).cartList.length,
              hasCount: true,
            ),

            Consumer<WishListController>(builder: (context, wishListController, _) {
              return SquareButtonWidget(
                image: Images.wishlist, title: getTranslated('wishlist', context),
                navigateTo: null,
                onTap: () {
                  RouterHelper.getWishListRoute(action: RouteAction.push);
                },
                count: wishListController.wishList?.length ?? 0,
                hasCount: (!isGuestMode  && (wishListController.wishList?.length ?? 0) > 0),
              );
            }),

          ],
        )),
      ));
    });
  }
}
