import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/shop_navigation_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

class FavouriteButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final int? productId;
  final bool? fromProductDetails;
  final SellerNavigationModel? sellerNavigationModel;
  const FavouriteButtonWidget({super.key, this.backgroundColor = Colors.black, this.productId, this.fromProductDetails = false, this.sellerNavigationModel});
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeController>(context).darkTheme;

    return Consumer<AuthController>(
      builder: (context, authController, _) {
        bool isGuestMode = !authController.isLoggedIn();
        return Consumer<WishListController>(
          builder: (context, wishProvider,_) {
            return GestureDetector(
              onTap: () {
                String? currentRouteName = ModalRoute.of(context)?.settings.name;
                final searchProvider = Provider.of<SearchProductController>(context, listen: false);

                if (isGuestMode) {
                  if (searchProvider.searchFocusNode.hasFocus) {
                    searchProvider.searchFocusNode.unfocus();
                  }
                 showModalBottomSheet(backgroundColor: Colors.transparent,
                   context: context, builder: (_)=> NotLoggedInBottomSheetWidget(
                     fromFavoriteButton: true,
                     fromPage: currentRouteName,
                     onLoginSuccess: sellerNavigationModel?.sellerId == null ? null : () {
                       RouterHelper.getTopSellerRoute(
                         action: RouteAction.pushReplacement,
                         slug: sellerNavigationModel?.slug,
                         sellerId: sellerNavigationModel?.sellerId,
                         temporaryClose: sellerNavigationModel?.temporaryClose,
                         vacationStatus: sellerNavigationModel?.vacationStatus,
                         vacationEndDate: sellerNavigationModel?.vacationEndDate,
                         vacationStartDate: sellerNavigationModel?.vacationStartDate,
                         vacationDurationType: sellerNavigationModel?.vacationDurationType,
                         name: sellerNavigationModel?.name,
                         banner: sellerNavigationModel?.banner,
                         image: sellerNavigationModel?.image,
                         fromMore: sellerNavigationModel?.fromMore,
                         totalReview: sellerNavigationModel?.totalReview,
                         totalProduct: sellerNavigationModel?.totalProduct,
                       );
                     },
                   )
                 );
                } else {
                  wishProvider.addedIntoWish.contains(productId)?
                  wishProvider.removeWishList(productId,) :
                  wishProvider.addWishList(productId);
                }
              },
              child: Container(
                height: (fromProductDetails ?? false) ? 40 : null,
                width: (fromProductDetails ?? false) ? 40 : null,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.transparent : Theme.of(context).cardColor,
                  border: Border.all(color: isDarkMode ? Theme.of(context).primaryColor : Colors.transparent, width: 1),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(
                    color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.10),
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: const Offset(0,3),
                  )],
                ),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeEight),
                  transform: Matrix4.translationValues(0, 1, 0),
                  child: Icon(wishProvider.addedIntoWish.contains(productId)
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                    color: wishProvider.addedIntoWish.contains(productId)
                      ? Theme.of(context).primaryColor
                      : isDarkMode ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
                    size: Dimensions.paddingSizeDefaultAddress,
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
}
