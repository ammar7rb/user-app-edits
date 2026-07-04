import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/widgets/wishlist_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/widgets/wishlist_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/debounce_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});
  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final TextEditingController searchTextEditingController = TextEditingController();
  final DebounceHelper debounceHelper = DebounceHelper(milliseconds: 500);


  @override
  void initState() {
    super.initState();
    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListController>(context, listen: false).getWishList('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async{
        if(Provider.of<ProfileController>(context, listen: false).userInfoModel == null) {
          Provider.of<ProfileController>(context, listen: false).getUserInfo(context);
          RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page : 'more');
        } else {
          return;
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: getTranslated('wishList', context)),
        resizeToAvoidBottomInset: true,
        body: Column(children: [

          // Place this inside your Consumer<WishListController> builder

          Consumer<WishListController>(builder: (context, wishListController, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeSmall
              ).copyWith(right: Dimensions.paddingSizeDefault),
              child: TextFormField(
                controller: searchTextEditingController,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  debounceHelper.run(() {
                    wishListController.getWishList(searchTextEditingController.text);
                  });
                },
                onFieldSubmitted: (value) {
                  wishListController.getWishList(searchTextEditingController.text);
                },
                style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    borderSide: BorderSide(color: Colors.grey[300]!)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    borderSide: BorderSide(color: Colors.grey[300]!)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    borderSide: BorderSide(color: Colors.grey[300]!)),
                  hintText: getTranslated('search_products', context),
                  hintStyle: textRegular.copyWith(color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.9)),
                  suffixIcon: SizedBox(width: searchTextEditingController.text.isNotEmpty ? 70 : 50,
                    child: Row(children: [
                      if(searchTextEditingController.text.isNotEmpty)
                        InkWell(
                          onTap: (){
                            searchTextEditingController.clear();
                            wishListController.getWishList('', clearSearch: true);
                          },
                          child: const Icon(Icons.clear, size: 20,),
                        ),

                      InkWell(onTap: () {
                        if(searchTextEditingController.text.trim().isNotEmpty) {
                          wishListController.getWishList(searchTextEditingController.text);
                        } else {
                          showCustomSnackBarWidget(getTranslated('enter_somethings', context), context, snackBarType: SnackBarType.warning);
                        }
                      },
                        child: Container(
                          margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          ),
                          child: Image.asset(Images.search, color: Colors.white, height: Dimensions.iconSizeSmall, width: Dimensions.iconSizeSmall, fit: BoxFit.contain),
                        ),
                      ),
                    ]),
                  )
                ),
              ),
            );
          }),





          Expanded(child: !Provider.of<AuthController>(context, listen: false).isLoggedIn() ?
          NotLoggedInWidget(
            fromPage: RouterHelper.wishListScreen,
            onLoginSuccess: () {
              RouterHelper.getWishListRoute(action: RouteAction.pushReplacement);
            },
          )
            : Consumer<WishListController>(builder: (context, wishListProvider, child) {
          return wishListProvider.wishList != null
            ? wishListProvider.wishList!.isNotEmpty
            ? RefreshIndicator(
            onRefresh: () async => await  wishListProvider.getWishList(searchTextEditingController.text ?? ''),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: wishListProvider.wishList!.length,
              itemBuilder: (context, index) => WishListWidget(wishlistModel: wishListProvider.wishList?[index], index: index),
            ))
            : NoInternetOrDataScreenWidget(isNoInternet: false, message: searchTextEditingController.text.trim().isNotEmpty ? 'no_product_found' : 'no_wishlist_product', icon: Images.noWishlist)
            : const WishListShimmer();
          })),
        ]),
      ),
    );
  }
}


