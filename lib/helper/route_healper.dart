import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/image_full_url.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/screens/address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/screens/add_new_address_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/screens/saved_address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/screens/saved_billing_address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/enums/from_page.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/otp_login_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/otp_registration_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/otp_verification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/screens/offers_product_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/screens/brands_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/domain/models/message_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/media_viewer_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/screens/checkout_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/screens/digital_payment_order_place_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/clearance_sale/screens/clearance_sale_all_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/clearance_sale/screens/clearance_sale_shop_all_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/screens/compare_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/contact_us/screens/contact_us_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/screens/coupon_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/screens/featured_deal_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/screens/flash_deal_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/view_all_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/location/screens/select_location_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/screens/loyalty_point_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/more/screens/faq_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/offline_payment/screens/offline_payment_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/screens/order_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/screens/order_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_image_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/specification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/restock/screens/restock_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/screens/review_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/screens/search_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/setting/screens/settings_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/screens/notification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/more/screens/html_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/screens/guest_track_order_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/enums/vacation_duration_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/all_shop_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/overview_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/business_pages_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_ticket_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/screens/add_ticket_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/screens/support_conversation_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/screens/support_ticket_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/widgets/support_ticket_type_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/tracking/screens/tracking_result_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/update/screen/update_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/wallet/screens/add_fund_to_wallet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/wallet/screens/wallet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/screens/wishlist_screen.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/maintenance/maintenance_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/screens/splash_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/login_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/screens/profile_screen1.dart';
import 'package:flutter_sixvalley_ecommerce/features/blog/screens/blog_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/shop_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/auth_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/forget_password_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/reset_password_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/screens/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/chat_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_offline_payment_screen.dart' as order_offline;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


enum RouteAction {push, pushReplacement, pushNamedAndRemoveUntil}

class RouterHelper {
  static const String initial = '/';
  static const String trackOrder = '/track-order';
  static const String signUpAuth = '/referral-login';
  static const String productDetails = '/product/:slug';
  static const String vendorDetails = '/vendor-shop/:slug';


  static const String splashScreen = '/splash';
  static const String dashboardScreen = '/dashboard';
  static const String loginScreen = '/login';
  static const String profileScreen1 = '/profile1';
  static const String blogScreen = '/blog';
  static const String brandCategoryScreen = '/brand-category';
  static const String productDetailsScreen = '/product-details';
  static const String topSellerScreen = '/top-seller';
  static const String onboardingScreen = '/onboarding';
  static const String addressScreen = '/address-list-screen';
  static const String addNewAddressScreen = '/add-new-address';
  static const String savedAddressListScreen = '/saved-address-list';
  static const String savedBillingAddressListScreen = '/saved-billing-address-list';
  static const String authScreen = '/auth';
  static const String forgetPasswordScreen = '/forget-password';
  static const String otpLoginScreen = '/otp-login';
  static const String otpRegistrationScreen = '/otp-registration';
  static const String verificationScreen = '/verification';
  static const String resetPasswordScreen = '/reset-password';
  static const String offerProductListScreen = '/offer-product-list';
  static const String brandsView = '/brands';
  static const String cartScreen = '/cart';
  static const String categoryScreen = '/category';
  static const String chatScreen = '/chat';
  static const String inboxScreen = '/inbox';
  static const String mediaViewerScreen = '/media-viewer';
  static const String checkoutScreen = '/checkout';
  static const String digitalPaymentScreen = '/digital-payment';
  static const String clearanceSaleAllProductScreen = '/clearance-sale-all-product';
  static const String clearanceSaleShopProductScreen = '/clearance-sale-shop-product';
  static const String compareProductScreen = '/compare-product';
  static const String contactUsScreen = '/contact-us';
  static const String couponListScreen = '/coupon-list';
  static const String featuredDealScreenView = '/featured-deal';
  static const String flashDealScreenView = '/flash-deal';
  static const String viewAllProductScreen = '/view-all-product';
  static const String loyaltyPointScreen = '/loyalty-point';
  static const String maintenanceScreen = '/maintenance';
  static const String referAndEarnScreen = '/refer-and-earn';
  static const String restockListScreen = '/restock-list';
  static const String settingsScreen = '/settings';
  static const String notificationScreen = '/notification';
  static const String guestTrackOrderScreen = '/guest-track-order';
  static const String htmlViewScreen = '/html-view';
  static const String supportTicketScreen = '/support-ticket';
  static const String faqScreen = '/faq';
  static const String orderScreen = '/order-screen';
  static const String orderDetailsScreen = '/order-details-screen';
  static const String productImageScreen = '/product-image-screen';
  static const String specificationScreen = '/specification';
  static const String reviewScreen = '/review';
  static const String searchScreen = '/search';
  static const String allTopSellerScreen = '/all-top-seller-screen';
  static const String addTicketScreen = '/add-ticket';
  static const String supportConversationScreen = '/support-conversation';
  static const String trackingResultScreen = '/tracking-result';
  static const String updateScreen = '/update';
  static const String walletScreen = '/wallet';
  static const String addFundToWalletScreen = '/add-fund-wallet';
  static const String wishListScreen = '/wish-list';
  static const String selectLocationScreen = '/select-location-screen';
  static const String offlinePaymentScreen = '/offline-payment-screen';
  static const String shopOverviewScreen = '/shop-overview-screen';
  static const String orderOfflinePaymentScreen = '/order-offline-payment-screen';



  static const String signUp = '/sign-up';
  static const String digitalProduct = '/sign-up';



  static String getSplashRoute({RouteAction? action}) => _navigateRoute(splashScreen, route: action);
  static String getDashboardRoute({RouteAction? action, String page = 'home'}) => _navigateRoute('$dashboardScreen?page=$page', route: action);
  static String getLoginRoute({RouteAction? action, bool isFromLogout = false, String? fromPage,  VoidCallback? onLoginSuccess}) {

    final query = 'formLogout=${isFromLogout ? 'true' : 'false'}'
        '&fromPage=${fromPage ?? ''}';
    return _navigateRoute(
      '$loginScreen?$query',
      route: action,
      extra: {
        'onLoginSuccess': onLoginSuccess,
      },
    );
  }
  static String getProfileScreen1Route({RouteAction? action}) => _navigateRoute(profileScreen1, route: action);
  static String getBlogScreenRoute({RouteAction? action, required String url}) => _navigateRoute('$blogScreen?url=${Uri.encodeComponent(url)}', route: action);
  static String getAddressListScreen({RouteAction? action}) => _navigateRoute(addressScreen, route: action);
  static String getAddNewAddressRoute({
    RouteAction? action,
    bool? isEnableUpdate,
    bool? fromCheckout,
    bool? isBilling,
    AddressModel? address,
  }) {
    String? address0 =  address !=null ? base64Url.encode(utf8.encode(jsonEncode(address.toJson()))) : null;

    final params = <String, String>{};
    if (isEnableUpdate != null) params['isEnableUpdate'] = isEnableUpdate.toString();
    if (fromCheckout != null) params['fromCheckout'] = fromCheckout.toString();
    if (isBilling != null) params['isBilling'] = isBilling.toString();
    if (address != null) params['address'] = address0!;

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');

    return _navigateRoute('$addNewAddressScreen${query.isNotEmpty ? '?$query' : ''}', route: action);
  }

  static String getSavedAddressListRoute({RouteAction? action, bool? fromGuest}) {
    final params = <String, String>{};
    if (fromGuest != null) params['fromGuest'] = fromGuest.toString();
    final query = params.isNotEmpty ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}' : '';
    return _navigateRoute('$savedAddressListScreen$query', route: action);
  }

  static String getSavedBillingAddressListRoute({RouteAction? action, bool? fromGuest}) {
    final params = <String, String>{};
    if (fromGuest != null) params['fromGuest'] = fromGuest.toString();
    final query = params.isNotEmpty ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}' : '';
    return _navigateRoute('$savedBillingAddressListScreen$query', route: action);
  }

  static String getBrandCategoryRoute({
    RouteAction? action,
    bool? isBrand,
    int? id,
    String? name,
    String? image,
    SubCategory? subCategory,
    bool? isInsideSubSubCategory,
    CategoryModel? categoryModel,
    bool? isAllProduct
  }) {

    String? subCategory0 =  subCategory !=null ? base64Url.encode(utf8.encode(jsonEncode(subCategory.toJson()))) : null;
    String? category =  categoryModel !=null ? base64Url.encode(utf8.encode(jsonEncode(categoryModel.toJson() ))) : null;

    final params = <String, String>{};
    if (isBrand != null) params['is_brand'] = isBrand.toString();
    if (id != null) params['id'] = id.toString();
    if (name != null) params['name'] = Uri.encodeComponent(name);
    if (image != null) params['image'] = Uri.encodeComponent(image);
    if (subCategory != null) params['subCategory'] = subCategory0!;
    if (isInsideSubSubCategory != null) params['isInsideSubSubCategory'] = isInsideSubSubCategory.toString();
    if (categoryModel != null) params['categoryModel'] = category!;
    if (isAllProduct != null) params['isAllProduct'] = isAllProduct.toString();
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute('$brandCategoryScreen${query.isNotEmpty ? '?$query' : ''}', route: action);
  }

  static String getProductDetailsRoute({
    RouteAction? action,
    int? productId,
    String? slug,
    bool? isFromWishList,
    bool? isNotification,
    bool? fromFlashDeals
  }) {
    final params = <String, String>{};
    if (productId != null) params['id'] = productId.toString();
    if (slug != null) params['slug'] = Uri.encodeComponent(slug);
    if (isFromWishList != null) params['isFromWishList'] = isFromWishList.toString();
    if (isNotification != null) params['isNotification'] = isNotification.toString();
    if (fromFlashDeals != null) params['fromFlashDeals'] = fromFlashDeals.toString();
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute('$productDetailsScreen${query.isNotEmpty ? '?$query' : ''}', route: action);
  }

  static String getTopSellerRoute({
    RouteAction? action,
    String? slug,
    int? sellerId,
    bool? temporaryClose,
    bool? vacationStatus,
    DateTime? vacationEndDate,
    DateTime? vacationStartDate,
    VacationDurationType? vacationDurationType,
    String? name,
    String? banner,
    String? image,
    bool? fromMore,
    int? totalReview,
    int? totalProduct,
    String? rating,
  }) {
    final params = <String, String>{};
    if (sellerId != null) params['sellerId'] = sellerId.toString();
    if (temporaryClose != null) params['temporaryClose'] = temporaryClose.toString();
    if (vacationStatus != null) params['vacationStatus'] = vacationStatus.toString();
    if (vacationEndDate != null) params['vacationEndDate'] = vacationEndDate.toIso8601String();
    if (vacationStartDate != null) params['vacationStartDate'] = vacationStartDate.toIso8601String();
    if (vacationDurationType != null) params['vacationDurationType'] = vacationDurationType.toString();
    if (name != null) params['name'] = Uri.encodeComponent(name);
    if (banner != null) params['banner'] = Uri.encodeComponent(banner);
    if (image != null) params['image'] = Uri.encodeComponent(image);
    if (fromMore != null) params['fromMore'] = fromMore.toString();
    if (totalReview != null) params['totalReview'] = totalReview.toString();
    if (totalProduct != null) params['totalProduct'] = totalProduct.toString();
    if (rating != null) params['rating'] = rating;
    if (slug != null) params['slug'] = slug;
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute('$topSellerScreen${query.isNotEmpty ? '?$query' : ''}', route: action);
  }
  static String getOnboardingRoute({RouteAction? action, Color? indicatorColor, Color? selectedIndicatorColor}) {
    final params = <String, String>{};
    if (indicatorColor != null) params['indicatorColor'] = indicatorColor.toARGB32().toRadixString(16);
    if (selectedIndicatorColor != null) params['selectedIndicatorColor'] = selectedIndicatorColor.toARGB32().toRadixString(16);
    final query = params.isNotEmpty ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}' : '';
    return _navigateRoute('$onboardingScreen$query', route: action);
  }

  static String getAuthScreenRoute({RouteAction? action, bool fromLogout = false, String? fromPage,  VoidCallback? onLoginSuccess}) {
    final query = 'formLogout=${fromLogout ? 'true' : 'false'}'
        '&fromPage=${fromPage ?? ''}';

    return _navigateRoute(
      '$authScreen?$query',
      route: action,
      extra: {
        'onLoginSuccess': onLoginSuccess,
      },
    );
  }

  static String getForgetPasswordScreenRoute({RouteAction? action}) => _navigateRoute(forgetPasswordScreen, route: action);
  static String getOtpLoginRoute({
    bool fromLogout = false,
    String? toNavigateScreen,
    VoidCallback? onLoginSuccess,
  }) {
    final params = <String, String>{
      'fromLogout': fromLogout.toString(),
    };

    if (toNavigateScreen != null) {
      params['toNavigateScreen'] = Uri.encodeComponent(toNavigateScreen);
    }
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');

    return _navigateRoute(
      '$otpLoginScreen?$query',
      extra: {
        'onLoginSuccess': onLoginSuccess,
      },
    );
  }


  static String getOtpRegistrationRoute({
    required String tempToken,
    required String userInput,
    String? userName,
    RouteAction? action,
    String? toNavigateScreen,
    VoidCallback? onLoginSuccess
  }) {
    final params = <String, String>{
      'tempToken': Uri.encodeComponent(tempToken),
      'userInput': Uri.encodeComponent(userInput),
    };
    if (userName != null) params['userName'] = Uri.encodeComponent(userName);
    if (toNavigateScreen != null) params['toNavigateScreen'] = toNavigateScreen.toString();
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute(
      '$otpRegistrationScreen?$query',
      route: action,
      extra: {
        'onLoginSuccess': onLoginSuccess,
      },
    );
  }
  static String getVerificationRoute({
    String? userInput,
    required FromPage fromPage,
    String? session,
    bool fromDigitalProduct = false,
    int? orderId,
    RouteAction? action,
    String? toNavigateScreen,
    VoidCallback? onLoginSuccess
  }) {
    final params = <String, String>{
      'fromPage': fromPage.name,
      'fromDigitalProduct': fromDigitalProduct.toString(),
    };
    if (userInput != null) params['userInput'] = Uri.encodeComponent(userInput);
    if (session != null) params['session'] = Uri.encodeComponent(session);
    if (orderId != null) params['orderId'] = orderId.toString();
    if (toNavigateScreen != null) params['toNavigateScreen'] = toNavigateScreen.toString();
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute(
      '$verificationScreen?$query', route: action,
      extra: {
        'onLoginSuccess': onLoginSuccess,
      },
    );
  }
  static String getResetPasswordRoute({
    required String mobileNumber,
    required String otp,
    RouteAction? action,
  }) {
    final params = <String, String>{
      'mobileNumber': Uri.encodeComponent(mobileNumber),
      'otp': Uri.encodeComponent(otp),
    };
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute('$resetPasswordScreen?$query', route: action);
  }

  static String getOfferProductListScreenRoute({RouteAction? action, int? page, String? filter}) {
    return _navigateRoute(offerProductListScreen, route: action);
  }

  static String getBrandViewRoute({RouteAction? action}) => _navigateRoute(brandsView, route: action);

  static String getCartScreenRoute({RouteAction? action, bool? fromCheckout, int? sellerId, bool? showBackButton}) {
    final params = <String, String>{};
    if (fromCheckout != null) params['fromCheckout'] = fromCheckout.toString();
    if (sellerId != null) params['sellerId'] = sellerId.toString();
    if (showBackButton != null) params['showBackButton'] = showBackButton.toString();
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute('$cartScreen${query.isNotEmpty ? '?$query' : ''}', route: action);
  }

  static String getChatScreenRoute({
    RouteAction? action,
    int? id,
    String? name,
    bool? isDelivery,
    String? image,
    String? phone,
    int? userType,
    bool? isShopOnVacation,
    bool? isShopTemporaryClosed,
  }) {
    final params = <String, String>{};
    if (id != null) params['id'] = id.toString();
    if (name != null) params['name'] = Uri.encodeComponent(name);
    if (isDelivery != null) params['isDelivery'] = isDelivery.toString();
    if (image != null) params['image'] = Uri.encodeComponent(image);
    if (phone != null) params['phone'] = Uri.encodeComponent(phone);
    if (userType != null) params['userType'] = userType.toString();
    if (isShopOnVacation != null) params['isShopOnVacation'] = isShopOnVacation.toString();
    if (isShopTemporaryClosed != null) params['isShopTemporaryClosed'] = isShopTemporaryClosed.toString();

    final query = params.isNotEmpty ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}' : '';
    return _navigateRoute('$chatScreen$query', route: action);
  }

  static String getInboxScreenRoute({
    RouteAction? action,
    bool? isBackButtonExist,
    bool? fromNotification,
    int? initIndex,
  }) {
    final params = <String, String>{};
    if (isBackButtonExist != null) params['isBackButtonExist'] = isBackButtonExist.toString();
    if (fromNotification != null) params['fromNotification'] = fromNotification.toString();
    if (initIndex != null) params['initIndex'] = initIndex.toString();

    final query = params.isNotEmpty ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}' : '';
    return _navigateRoute('$inboxScreen$query', route: action);
  }


  static String getMediaViewerScreenRoute({
    RouteAction? action,
    required int clickedIndex,
    List<Attachment>? serverMedia,
    List<XFile>? localMedia,
  }) {
    final params = <String, String>{};

    params['clickedIndex'] = clickedIndex.toString();

    if (serverMedia != null) {
      params['serverMedia'] = Uri.encodeComponent(
        jsonEncode(serverMedia.map((e) => e.toJson()).toList()),
      );
    }

    if (localMedia != null) {
      params['localMedia'] = Uri.encodeComponent(
        jsonEncode(localMedia.map((e) => e.path).toList()), // just store paths
      );
    }

    final query = '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    return _navigateRoute('$mediaViewerScreen$query', route: action);
  }

  static String getCheckoutScreenRoute({
    RouteAction? action,
    required List<CartModel> cartList,
    bool fromProductDetails = false,
    double totalOrderAmount = 0,
    double shippingFee = 0,
    double discount = 0,
    double tax = 0,
    int? sellerId,
    bool onlyDigital = false,
    bool hasPhysical = true,
    int quantity = 1,
  }) {
    final params = <String, String>{
      'cartList': Uri.encodeComponent(jsonEncode(cartList.map((e) => e.toJson()).toList())),
      'fromProductDetails': fromProductDetails.toString(),
      'totalOrderAmount': totalOrderAmount.toString(),
      'shippingFee': shippingFee.toString(),
      'discount': discount.toString(),
      'tax': tax.toString(),
      'onlyDigital': onlyDigital.toString(),
      'hasPhysical': hasPhysical.toString(),
      'quantity': quantity.toString(),
    };

    if (sellerId != null) params['sellerId'] = sellerId.toString();

    final query = '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    return _navigateRoute('$checkoutScreen$query', route: action);
  }

  static String getDigitalPaymentScreenRoute({
    RouteAction? action,
    required String url,
    bool fromWallet = false,
    String? orderId,
  }) {
    final params = <String, String>{
      'url': Uri.encodeComponent(url),
      'fromWallet': fromWallet.toString(),
      'orderId': orderId.toString(),
    };
    final query = '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    return _navigateRoute('$digitalPaymentScreen$query', route: action);
  }

  static String getClearanceSaleAllProductScreenRoute({RouteAction? action}) {
    return _navigateRoute(clearanceSaleAllProductScreen, route: action);
  }

  static String getClearanceSaleShopProductScreenRoute({required String slug, RouteAction? action}) {
    final params = <String, String>{'slug': slug};
    final query = '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    return _navigateRoute('$clearanceSaleShopProductScreen$query', route: action);
  }

  static String getCompareProductScreenRoute({RouteAction? action}) {
    return _navigateRoute(compareProductScreen, route: action);
  }

  static String getContactUsScreenRoute({RouteAction? action}) {
    return _navigateRoute(contactUsScreen, route: action);
  }

  static String getCouponListScreenRoute({RouteAction? action}) {
    return _navigateRoute(couponListScreen, route: action);
  }

  static String getFeaturedDealScreenViewRoute({RouteAction? action}) {
    return _navigateRoute(featuredDealScreenView, route: action);
  }

  static String getFlashDealScreenViewRoute({RouteAction? action}) {
    return _navigateRoute(flashDealScreenView, route: action);
  }

  static String getViewAllProductScreenRoute({required ProductType productType, RouteAction? action}) {
    final params = <String, String>{'productType': productType.name};
    final query = '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    return _navigateRoute('$viewAllProductScreen$query', route: action);
  }

  static String getLoyaltyPointScreenRoute({RouteAction? action}) {
    return _navigateRoute(loyaltyPointScreen, route: action);
  }

  static String getMaintenanceRoute({RouteAction? action}) {
    return _navigateRoute(maintenanceScreen, route: action);
  }

  static String getReferAndEarnRoute({RouteAction? action}) {
    return _navigateRoute(referAndEarnScreen, route: action);
  }

  static String getRestockListRoute({RouteAction? action}) {
    return _navigateRoute(restockListScreen, route: action);
  }

  static String getSettingsRoute({RouteAction? action}) {
    return _navigateRoute(settingsScreen, route: action);
  }

  static String getNotificationRoute({RouteAction? action, bool fromNotification = false}) {
    final params = <String, String>{};
    if (fromNotification) params['fromNotification'] = fromNotification.toString();
    final query = params.isNotEmpty ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}' : '';
    return _navigateRoute('$notificationScreen$query', route: action);
  }

  static String getGuestTrackOrderRoute({RouteAction? action}) {
    return _navigateRoute(guestTrackOrderScreen, route: action);
  }

  static String getHtmlViewRoute({
    RouteAction? action,
    required BusinessPageModel page,
  }) {
    final encodedPage = base64Url.encode(utf8.encode(jsonEncode(page.toJson())));

    final params = <String, String>{
      'page': encodedPage,
    };

    final query = '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    return _navigateRoute('$htmlViewScreen$query', route: action);
  }

  static String getCategoryScreenRoute({RouteAction action = RouteAction.push}) {
    return _navigateRoute(categoryScreen, route: action);
  }

  static String getSupportTicketRoute({RouteAction? action}) {
    return _navigateRoute(supportTicketScreen, route: action);
  }

  static String getFaqRoute({RouteAction? action, String? title}) {
    final params = <String, String>{};
    if (title != null) params['title'] = Uri.encodeComponent(title);
    final query = params.isNotEmpty ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}' : '';
    return _navigateRoute('$faqScreen$query', route: action);
  }

  static String getOrderScreenRoute({RouteAction? action, bool isBackButtonExist = true, bool fromPlaceOrder = false}) {
    final params = '?isBackButtonExist=$isBackButtonExist&fromPlaceOrder=$fromPlaceOrder';
    return _navigateRoute('$orderScreen$params', route: action);
  }

  static String getOrderDetailsScreenRoute({
    RouteAction? action,
    required int orderId,
    bool isNotification = false,
    String? phone,
    bool fromTrack = false,
  }) {
    final params = <String, String>{
      'orderId': orderId.toString(),
      'isNotification': isNotification.toString(),
      'fromTrack': fromTrack.toString(),
    };

    if (phone != null) params['phone'] = Uri.encodeComponent(phone);

    final query = '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    return _navigateRoute('$orderDetailsScreen$query', route: action);
  }

  static String getProductImageScreenRoute({
    RouteAction? action,
    required String title,
    required List<ImageFullUrl> imageList,
  }) {
    String? encodedImageList = imageList.isNotEmpty
        ? base64Url.encode(utf8.encode(jsonEncode(imageList.map((e) => e.toJson()).toList())))
        : null;

    final query = '?title=${Uri.encodeComponent(title)}&images=$encodedImageList';
    return _navigateRoute('$productImageScreen$query', route: action);
  }

  static String getSpecificationRoute(String specification) {
    return _navigateRoute('$specificationScreen?spec=$specification');
  }

  static String getReviewRoute({
    RouteAction? action,
    List<ReviewModel>? reviewList,
  }) {
    String? reviews = reviewList != null
        ? base64Url.encode(utf8.encode(jsonEncode(reviewList.map((e) => e.toJson()).toList())))
        : null;

    final params = <String, String>{};
    if (reviews != null) params['reviews'] = reviews;

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute('$reviewScreen${query.isNotEmpty ? '?$query' : ''}', route: action);
  }

  static String getSearchRoute({RouteAction? action}) {
    return _navigateRoute(searchScreen, route: action);
  }

  static String getAllTopSellerRoute({RouteAction? action, required String title}) {
    final query = '?title=${Uri.encodeComponent(title)}';
    return _navigateRoute('$allTopSellerScreen$query', route: action);
  }

  static String getWishListRoute({RouteAction? action}) {
    return _navigateRoute(wishListScreen, route: action);
  }


  static String getAddTicketRoute({
    RouteAction? action,
    required TicketModel ticketModel,
    required int categoryIndex,
  }) {
    // Encode model to base64
    String encodedTicket = base64Url.encode(
      utf8.encode(jsonEncode(ticketModel.toJson())),
    );

    final params = <String, String>{
      'ticket': encodedTicket,
      'categoryIndex': categoryIndex.toString(),
    };

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute(
      '$addTicketScreen?${query.isNotEmpty ? query : ''}',
      route: action,
    );
  }

  static String getSupportConversationRoute({
    RouteAction? action,
    required SupportTicketModel supportTicketModel,
  }) {
    // Encode the SupportTicketModel safely as Base64 JSON
    String encodedTicket = base64Url.encode(
      utf8.encode(jsonEncode(supportTicketModel.toJson())),
    );

    final params = <String, String>{
      'supportTicket': encodedTicket,
    };

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute(
      '$supportConversationScreen${query.isNotEmpty ? '?$query' : ''}',
      route: action,
    );
  }

  static String getTrackingResultRoute({
    RouteAction? action,
    required String orderID,
  }) {
    final params = <String, String>{
      'orderID': Uri.encodeComponent(orderID),
    };

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute(
      '$trackingResultScreen${query.isNotEmpty ? '?$query' : ''}',
      route: action,
    );
  }

  static String getUpdateRoute({RouteAction? action}) {
    return _navigateRoute(updateScreen, route: action);
  }

  static String getWalletRoute({RouteAction? action, bool? isBackButtonExist}) {
    final params = <String, String>{};
    if (isBackButtonExist != null) params['isBackButtonExist'] = isBackButtonExist.toString();

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute('$walletScreen${query.isNotEmpty ? '?$query' : ''}', route: action);
  }

  static String getAddFundToWalletRoute({RouteAction? action, required String url}) {
    final params = <String, String>{};
    params['url'] = Uri.encodeComponent(url);

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return _navigateRoute('$addFundToWalletScreen${query.isNotEmpty ? '?$query' : ''}', route: action);
  }



  static String getSelectLocationScreen({
    GoogleMapController? googleMapController,
    RouteAction? action,
  }) {
    return _navigateRoute(
      selectLocationScreen,
      route: action,
      extra: {
        'googleMapController': googleMapController,
      },
    );
  }


  static String getOfflinePaymentScreen({
    required double payableAmount,
    required Function callback,
    RouteAction? action,
  }) {
    final params = <String, String>{
      'payableAmount': payableAmount.toString(),
    };

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');

    return _navigateRoute(
      '$offlinePaymentScreen?$query',
      route: action,
      extra: {
        'callback': callback,
      },
    );
  }


  static String getShopOverviewScreen({
    required String slug,
    required ScrollController scrollController,
    RouteAction? action,
  }) {
    final params = <String, String>{
      'slug': slug.toString(),
    };

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');

    return _navigateRoute(
      '$shopOverviewScreen?$query',
      route: action,
      extra: {
        'scrollController': scrollController,
      },
    );
  }


  static String getOrderOfflinePaymentScreen({
    required double payableAmount,
    required Function callback,
    required int orderId,
    RouteAction? action,
  }) {
    final params = <String, String>{
      'payableAmount': payableAmount.toString(),
      'orderId': orderId.toString(),
    };

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');

    return _navigateRoute(
      '$orderOfflinePaymentScreen?$query',
      route: action,
      extra: {
        'callback': callback,
      },
    );
  }




  static String _navigateRoute(String path, {RouteAction? route = RouteAction.push, Map<String, dynamic>? extra}) {
    if (route == RouteAction.pushNamedAndRemoveUntil) {
      Get.context?.go(path, extra: extra);
    } else if (route == RouteAction.pushReplacement) {
      GoRouter.of(Get.context!).pushReplacement(path, extra: extra);
    } else {
      Get.context?.push(path, extra: extra);
    }
    return path;
  }



  static  Widget _routeHandler(BuildContext context, Widget route,  {bool isBranchCheck = false, required String? path}) {
    return Provider.of<SplashController>(context, listen: false).configModel == null ?
    SplashScreen() : _isMaintenance(Provider.of<SplashController>(context, listen: false).configModel!) ? const MaintenanceScreen() : route;
  }

  static bool _isMaintenance(ConfigModel configModel) {
    if(configModel.maintenanceModeData?.maintenanceStatus == 1) {
      if((configModel.maintenanceModeData?.selectedMaintenanceSystem?.customerApp  == 1)) {
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }


  static bool _isUserLoggedIn(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    return authController.isLoggedIn();
  }


  static final goRoutes = GoRouter(
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = _isUserLoggedIn(context);
      final String? referralCode = state.uri.queryParameters['referral_code'];

      if (state.matchedLocation == initial  && isLoggedIn) {
        return initial;
      }

      if(!isLoggedIn && state.matchedLocation == initial && referralCode != null && referralCode.isNotEmpty) {
        return '$signUpAuth?referral_code=$referralCode';
      }

      return null;
    },

    navigatorKey: navigatorKey,
    initialLocation: getSplashRoute(),
    errorBuilder: (ctx, _) => _routeHandler(ctx, const DashBoardScreen(pageIndex: 0), path: '/', isBranchCheck: true),
    routes: [
      GoRoute(path: initial, builder: (context, state) => DashBoardScreen(pageIndex: 0)),

      GoRoute(path: trackOrder, builder: (context, state) => GuestTrackOrderScreen(
        orderId : state.uri.queryParameters['order_id'] != null ? Uri.decodeComponent(state.uri.queryParameters['order_id']!) : '',
        phone: state.uri.queryParameters['phone_number'] != null ? Uri.decodeComponent(state.uri.queryParameters['phone_number']!) : '',
      )),

      GoRoute(
        path: signUpAuth,
        builder: (context, state) {
          final String? code = state.uri.queryParameters['referral_code'];
          return AuthScreen(
            fromLogout: false,
            fromPage: null,
            referCode: code,
            onLoginSuccess: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (navigatorKey.currentContext != null) {
                  navigatorKey.currentContext!.go(dashboardScreen);
                }
              });
            },
          );
        }
      ),

      GoRoute(
        path: productDetails,
        builder: (context, state) => ProductDetails(
          isNotification: true,
          productId: null,
          slug: state.pathParameters['slug'] ?? '',
        )
      ),

      GoRoute(
        path: vendorDetails,
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return TopSellerProductScreen(slug: slug, vacationEndDate: null, vacationStartDate: null, vacationDurationType: null,);
        },
      ),
      
      GoRoute(path: splashScreen, builder: (context, state) => const SplashScreen()),
      GoRoute(path: dashboardScreen, builder: (context, state) {
        String? page =  state.uri.queryParameters['page'];
        return DashBoardScreen(
          pageIndex: page == 'home' ? 0 : page == 'inbox' ? 1 : page == 'cart' ? 2 : page == 'orders' ? 3 : page == 'more' ? 4 : 0,
        );
      }),
      GoRoute(path: loginScreen, builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return LoginScreen(
          fromLogout: state.uri.queryParameters['formLogout'] == 'true',
          fromPage: state.uri.queryParameters['fromPage'],
          onLoginSuccess: extra?['onLoginSuccess'] as VoidCallback?,
        );
      }),
      GoRoute(path: profileScreen1, builder: (context, state) => const ProfileScreen1()),
      GoRoute(path: blogScreen, builder: (context, state) => BlogScreen(url: state.uri.queryParameters['url'] ?? '')),
      GoRoute(path: addressScreen, builder: (context, state) => AddressListScreen()),
      GoRoute(
        path: addNewAddressScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
         //  الكود الصحيح والمصفي من الأخطاء تماماً:

AddressModel? addressModel; // تعريف المتغير هنا عشان الـ Screen اللي تحت تشوفه

if (qp['address'] != null && qp['address'] != 'null') {
  String decodedAddress = utf8.decode(base64Url.decode('${state.uri.queryParameters['address']?.replaceAll(' ', '+')}'));
  addressModel = AddressModel.fromJson(jsonDecode(decodedAddress));
}

return AddNewAddressScreen(
  isEnableUpdate: qp['isEnableUpdate'] == 'true',
  fromCheckout: qp['fromCheckout'] == 'true',
  isBilling: qp['isBilling'] == 'true',
  address: addressModel, 
);
        },
      ),
      GoRoute(
        path: savedAddressListScreen,
        builder: (context, state) {
          final fromGuest = state.uri.queryParameters['fromGuest'] == 'true';
          return SavedAddressListScreen(fromGuest: fromGuest);
        },
      ),
      GoRoute(
        path: savedBillingAddressListScreen,
        builder: (context, state) {
          final fromGuest = state.uri.queryParameters['fromGuest'] == 'true';
          return SavedBillingAddressListScreen(fromGuest: fromGuest);
        },
      ),
      GoRoute(
        path: brandCategoryScreen,
        builder: (context, state) {
          CategoryModel? category;
          SubCategory? subCategory;

          if(state.uri.queryParameters['categoryModel'] != null) {
            String decoded = utf8.decode(base64Url.decode('${state.uri.queryParameters['categoryModel']?.replaceAll(' ', '+')}'));
            category = CategoryModel.fromJson(jsonDecode(decoded));
          }

          if(state.uri.queryParameters['subCategory'] != null) {
            String decoded = utf8.decode(base64Url.decode('${state.uri.queryParameters['subCategory']?.replaceAll(' ', '+')}'));
            subCategory = SubCategory.fromJson(jsonDecode(decoded));
          }
          return  BrandAndCategoryProductScreen(
            isBrand: state.uri.queryParameters['is_brand'] == 'true',
            id: state.uri.queryParameters['id'] != null ? int.tryParse(state.uri.queryParameters['id']!) : null,
            name: state.uri.queryParameters['name'],
            image: state.uri.queryParameters['image'],
            subCategory: subCategory,
            isInsideSubSubCategory: state.uri.queryParameters['isInsideSubSubCategory'] == 'true',
            categoryModel: category,
            isAllProduct: state.uri.queryParameters['isAllProduct'] == 'true',
          );
        },
      ),
      GoRoute(path: productDetailsScreen, builder: (context, state) => ProductDetails(
        productId: state.uri.queryParameters['id'] != null ? int.tryParse(state.uri.queryParameters['id']!) : null,
        slug: state.uri.queryParameters['slug'],
        isFromWishList: state.uri.queryParameters['isFromWishList'] == 'true',
        isNotification: state.uri.queryParameters['isNotification'] == 'true',
        fromFlashDeals: state.uri.queryParameters['fromFlashDeals'] == 'true',
      )),

      GoRoute(
        path: topSellerScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          return TopSellerProductScreen(
            sellerId: int.tryParse(qp['sellerId'] ?? ''),
            slug: qp['slug'] ?? '',
            temporaryClose: qp['temporaryClose'] == 'true',
            vacationStatus: qp['vacationStatus'] == 'true',
            vacationEndDate: qp['vacationEndDate'] != null ? DateTime.tryParse(qp['vacationEndDate'] ?? '') : null,
            vacationStartDate: qp['vacationStartDate'] != null ? DateTime.tryParse(qp['vacationStartDate'] ?? '') : null,
            vacationDurationType: qp['vacationDurationType'] != null
              ? VacationDurationType.values.firstWhere(
                (v) => v.name == qp['vacationDurationType'] || // direct match
                  'VacationDurationType.${v.name}' == qp['vacationDurationType'] || // prefixed match
                  v.toString() == qp['vacationDurationType'], // fallback (for safety)
              orElse: () => VacationDurationType.custom,
            ) : null,
            name: qp['name'] != null ? Uri.decodeComponent(qp['name'] ?? '') : null,
            banner: qp['banner'] != null ? Uri.decodeComponent(qp['banner'] ?? '') : null,
            image: qp['image'] != null ? Uri.decodeComponent(qp['image'] ?? '') : null,
            fromMore: qp['fromMore'] == 'true',
            totalReview: int.tryParse(qp['totalReview'] ?? ''),
            totalProduct: int.tryParse(qp['totalProduct'] ?? ''),
            rating: qp['rating'],
          );
        },
      ),

      GoRoute(path: onboardingScreen, builder: (context, state) {
        final indicatorColor = state.uri.queryParameters['indicatorColor'] != null
          ? Color(int.parse(state.uri.queryParameters['indicatorColor']!, radix: 16))
          : Colors.grey;
        final selectedIndicatorColor = state.uri.queryParameters['selectedIndicatorColor'] != null
          ? Color(int.parse(state.uri.queryParameters['selectedIndicatorColor']!, radix: 16))
          : Colors.black;
        return OnBoardingScreen(
          indicatorColor: indicatorColor,
          selectedIndicatorColor: selectedIndicatorColor,
        );
      }),
      GoRoute(path: authScreen, builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        return AuthScreen(
          fromLogout: state.uri.queryParameters['formLogout'] == 'true',
          fromPage: state.uri.queryParameters['fromPage'],
          onLoginSuccess: extra?['onLoginSuccess'] as VoidCallback?,
        );
      }),
      GoRoute(path: forgetPasswordScreen, builder: (context, state) => const ForgetPasswordScreen()),
      GoRoute(
        path: otpLoginScreen,
        builder: (context, state) {
          final fromLogout = state.uri.queryParameters['fromLogout'] == 'true';
          final toNavigateScreen = state.uri.queryParameters['toNavigateScreen'];
          final extra = state.extra as Map<String, dynamic>?;

          return OtpLoginScreen(
            fromLogout: fromLogout,
            fromPage: toNavigateScreen,
            onLoginSuccess: extra?['onLoginSuccess'] as VoidCallback?,
          );
        },
      ),

      GoRoute(
        path: otpRegistrationScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          final extra = state.extra as Map<String, dynamic>?;

          return OtpRegistrationScreen(
            tempToken: qp['tempToken'] ?? '',
            userInput: qp['userInput'] ?? '',
            userName: qp['userName'],
            toNavigateScreen: state.uri.queryParameters['toNavigateScreen'],
            onLoginSuccess: extra?['onLoginSuccess'] as VoidCallback?,
          );
        },
      ),
      GoRoute(
        path: verificationScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          final extra = state.extra as Map<String, dynamic>?;
          return VerificationScreen(
            qp['userInput'],
            FromPage.values.firstWhere((e) => e.name == qp['fromPage']),
            session: qp['session'],
            fromDigitalProduct: qp['fromDigitalProduct'] == 'true',
            orderId: qp['orderId'] != null ? int.tryParse(qp['orderId']!) : null,
            toNavigateScreen: state.uri.queryParameters['toNavigateScreen'],
            onLoginSuccess: extra?['onLoginSuccess'] as VoidCallback?,
          );
        },
      ),
      GoRoute(
        path: resetPasswordScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          return ResetPasswordScreen(
            mobileNumber: qp['mobileNumber'] ?? '',
            otp: qp['otp'] ?? '',
          );
        },
      ),
      GoRoute(path: offerProductListScreen, builder: (context, state) {
        return OfferProductListScreen();
      }),
      GoRoute(path: brandsView, builder: (context, state) => const BrandsView()),
      GoRoute(
        path: cartScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          return CartScreen(
            fromCheckout: qp['fromCheckout'] == 'true',
            sellerId: qp['sellerId'] != null ? int.tryParse(qp['sellerId']!) ?? 1 : 1,
            showBackButton: qp['showBackButton'] != null ? qp['showBackButton'] == 'true' : true,
          );
        },
      ),
      GoRoute(path: categoryScreen, builder: (context, state) => const CategoryScreen()),
      GoRoute(
        path: chatScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          return ChatScreen(
            id: qp['id'] != null ? int.tryParse(qp['id']!) : null,
            name: qp['name'] != null ? Uri.decodeComponent(qp['name']!) : '',
            isDelivery: qp['isDelivery'] == 'true',
            image: qp['image'] != null ? Uri.decodeComponent(qp['image']!) : null,
            phone: qp['phone'] != null ? Uri.decodeComponent(qp['phone']!) : null,
            userType: qp['userType'] != null ? int.tryParse(qp['userType']!) : null,
            isShopOnVacation: qp['isShopOnVacation'] == 'true',
            isShopTemporaryClosed: qp['isShopTemporaryClosed'] == 'true',
          );
        },
      ),

      GoRoute(
        path: inboxScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          return InboxScreen(
            isBackButtonExist: qp['isBackButtonExist'] == 'true',
            fromNotification: qp['fromNotification'] == 'true',
            initIndex: int.tryParse(qp['initIndex'] ?? '0') ?? 0,
          );
        },
      ),

      GoRoute(
        path: mediaViewerScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;

          int clickedIndex = int.tryParse(qp['clickedIndex'] ?? '0') ?? 0;

          List<Attachment>? serverMedia;
          if (qp['serverMedia'] != null) {
            try {
              final decoded = jsonDecode(Uri.decodeComponent(qp['serverMedia']!)) as List;
              serverMedia = decoded.map((e) => Attachment.fromJson(e)).toList();
            } catch (_) {}
          }

          List<XFile>? localMedia;
          if (qp['localMedia'] != null) {
            try {
              final decoded = jsonDecode(Uri.decodeComponent(qp['localMedia']!)) as List;
              localMedia = decoded.map((e) => XFile(e.toString())).toList();
            } catch (_) {}
          }

          return MediaViewerScreen(
            clickedIndex: clickedIndex,
            serverMedia: serverMedia,
            localMedia: localMedia,
          );
        },
      ),

      GoRoute(
        path: checkoutScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;

          final cartListStr = qp['cartList'] ?? '[]';

          List<CartModel> cartList;

          try {
            // Attempt to decode
            final decoded = Uri.decodeComponent(cartListStr);
            final jsonList = jsonDecode(decoded) as List;
            cartList = jsonList.map((e) => CartModel.fromJson(e)).toList();
          } catch (e) {
            // Fallback in case of invalid encoding
            final jsonList = jsonDecode(cartListStr) as List;
            cartList = jsonList.map((e) => CartModel.fromJson(e)).toList();
          }


          return CheckoutScreen(
            cartList: cartList,
            fromProductDetails: qp['fromProductDetails'] == 'true',
            totalOrderAmount: double.tryParse(qp['totalOrderAmount'] ?? '0') ?? 0,
            shippingFee: double.tryParse(qp['shippingFee'] ?? '0') ?? 0,
            discount: double.tryParse(qp['discount'] ?? '0') ?? 0,
            tax: double.tryParse(qp['tax'] ?? '0') ?? 0,
            sellerId: qp['sellerId'] != null ? int.tryParse(qp['sellerId']!) : null,
            onlyDigital: qp['onlyDigital'] == 'true',
            hasPhysical: qp['hasPhysical'] == 'true',
            quantity: int.tryParse(qp['quantity'] ?? '1') ?? 1,
          );
        },
      ),

      GoRoute(
        path: digitalPaymentScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          return DigitalPaymentScreen(
            url: qp['url'] ?? '',
            fromWallet: qp['fromWallet'] == 'true',
            orderId : qp['orderId'] ?? '',
          );
        },
      ),


      GoRoute(
        path: clearanceSaleAllProductScreen,
        builder: (context, state) => const ClearanceSaleAllProductScreen(),
      ),

      GoRoute(
        path: clearanceSaleShopProductScreen,
        builder: (context, state) {
          final slug = state.uri.queryParameters['slug'] ?? '';
          return ClearanceSaleShopProductScreen(slug: slug);
        },
      ),

      GoRoute(
        path: compareProductScreen,
        builder: (context, state) => const CompareProductScreen(),
      ),

      GoRoute(
        path: contactUsScreen,
        builder: (context, state) => const ContactUsScreen(),
      ),

      GoRoute(
        path: couponListScreen,
        builder: (context, state) => const CouponList(),
      ),

      GoRoute(
        path: featuredDealScreenView,
        builder: (context, state) => const FeaturedDealScreenView(),
      ),

      GoRoute(
        path: flashDealScreenView,
        builder: (context, state) => const FlashDealScreenView(),
      ),

      GoRoute(
        path: viewAllProductScreen,
        builder: (context, state) {
          final productTypeStr = state.uri.queryParameters['productType'] ?? ProductType.allProduct.name;
          final productType = ProductType.values.firstWhere(
            (e) => e.name == productTypeStr,
            orElse: () => ProductType.allProduct,
          );
          return ViewAllProductScreen(productType: productType);
        },
      ),

      GoRoute(
        path: loyaltyPointScreen,
        builder: (context, state) => const LoyaltyPointScreen(),
      ),

      GoRoute(
        path: maintenanceScreen,
        builder: (context, state) => const MaintenanceScreen(),
      ),

      GoRoute(
        path: referAndEarnScreen,
        builder: (context, state) => const ReferAndEarnScreen(),
      ),

      GoRoute(
        path: restockListScreen,
        builder: (context, state) => const RestockListScreen(),
      ),

      GoRoute(
        path: settingsScreen,
        builder: (context, state) => const SettingsScreen(),
      ),

      GoRoute(
        path: notificationScreen,
        builder: (context, state) {
          final fromNotification = state.uri.queryParameters['fromNotification'] == 'true';
          return NotificationScreen(fromNotification: fromNotification);
        },
      ),

      GoRoute(
        path: guestTrackOrderScreen,
        builder: (context, state) => const GuestTrackOrderScreen(),
      ),

      GoRoute(
        path: htmlViewScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          BusinessPageModel? page;

          if (qp['page'] != null) {
            try {
              final decodedJson = utf8.decode(base64Url.decode(qp['page']!));
              page = BusinessPageModel.fromJson(jsonDecode(decodedJson));
            } catch (e) {
              debugPrint('Error decoding BusinessPageModel: $e');
            }
          }

          return HtmlViewScreen(page: page);
        },
      ),

      GoRoute(
        path: supportTicketScreen,
        builder: (context, state) => const SupportTicketScreen(),
      ),

      GoRoute(
        path: faqScreen,
        builder: (context, state) {
          final title = state.uri.queryParameters['title'] != null
            ? Uri.decodeComponent(state.uri.queryParameters['title']!) : null;
          return FaqScreen(title: title);
        },
      ),

      GoRoute(
        path: orderScreen,
        builder: (context, state) {
          final isBackButtonExist = state.uri.queryParameters['isBackButtonExist'] == 'true';
          final fromPlaceOrder = state.uri.queryParameters['fromPlaceOrder'] == 'true';

          return OrderScreen(isBacButtonExist: isBackButtonExist, fromPlaceOrder: fromPlaceOrder);
        },
      ),

      GoRoute(
        path: orderDetailsScreen,
        builder: (context, state) {
          final qp = state.uri.queryParameters;
          return OrderDetailsScreen(
            orderId: int.tryParse(qp['orderId'] ?? '') ?? 0,
            isNotification: qp['isNotification'] == 'true',
            phone: qp['phone'] != null ? Uri.decodeComponent(qp['phone']!) : null,
            fromTrack: qp['fromTrack'] == 'true',
          );
        },
      ),


      GoRoute(
        path: productImageScreen,
        builder: (context, state) {
          String? title = state.uri.queryParameters['title'];
          List<ImageFullUrl>? imageList;

          if (state.uri.queryParameters['imageList'] != null) {
            try {
              String decoded = utf8.decode(
                  base64Url.decode('${state.uri.queryParameters['imageList']?.replaceAll(' ', '+')}')
              );
              List<dynamic> jsonList = jsonDecode(decoded);
              imageList = jsonList.map((e) => ImageFullUrl.fromJson(e)).toList();
            } catch (e) {
              imageList = [];
            }
          }

          return ProductImageScreen(
            title: title,
            imageList: imageList,
          );
        },
      ),

      GoRoute(
        path: specificationScreen,
        builder: (context, state) {
          // Get the 'spec' query parameter
          String? specification = state.uri.queryParameters['spec'] ?? '';
          return SpecificationScreen(specification: specification);
        },
      ),


      GoRoute(
        path: RouterHelper.reviewScreen,
        builder: (context, state) {
          final reviewsParam = state.uri.queryParameters['reviews'];
          List<ReviewModel>? reviewList;

          if (reviewsParam != null) {
            reviewList = (jsonDecode(utf8.decode(base64Url.decode(reviewsParam))) as List).map((e) => ReviewModel.fromJson(e)).toList();
          }

          return ReviewScreen(reviewList: reviewList);
        },
      ),

      GoRoute(
        path: RouterHelper.searchScreen,
        builder: (context, state) => const SearchScreen(),
      ),

      GoRoute(
        path: allTopSellerScreen,
        builder: (context, state) {
          final title = state.uri.queryParameters['title'] != null
            ? Uri.decodeComponent(state.uri.queryParameters['title']!)
            : '';
          return AllTopSellerScreen(title: title);
        },
      ),

      GoRoute(
        path: addTicketScreen,
        builder: (context, state) {
          final ticketParam = state.uri.queryParameters['ticket'];
          final categoryIndexParam = state.uri.queryParameters['categoryIndex'];

          late TicketModel ticketModel;
          if (ticketParam != null) {
            ticketModel = TicketModel.fromJson(
              jsonDecode(
                utf8.decode(base64Url.decode(ticketParam)),
              ),
            );
          }

          final categoryIndex = int.tryParse(categoryIndexParam ?? '0') ?? 0;

          return AddTicketScreen(
            ticketModel: ticketModel,
            categoryIndex: categoryIndex,
          );
        },
      ),

      GoRoute(
        path: supportConversationScreen,
        builder: (context, state) {
          final ticketParam = state.uri.queryParameters['supportTicket'];

          late SupportTicketModel supportTicketModel;
          if (ticketParam != null) {
            supportTicketModel = SupportTicketModel.fromJson(
              jsonDecode(
                utf8.decode(base64Url.decode(ticketParam)),
              ),
            );
          }

          return SupportConversationScreen(
            supportTicketModel: supportTicketModel,
          );
        },
      ),

      GoRoute(
        path: trackingResultScreen,
        builder: (context, state) {
          final orderID = state.uri.queryParameters['orderID'] ?? '';
          return TrackingResultScreen(orderID: orderID);
        },
      ),

      GoRoute(
        path: updateScreen,
        builder: (context, state) => const UpdateScreen(),
      ),

      GoRoute(
        path: walletScreen,
        builder: (context, state) {
          final isBackButtonExist = state.uri.queryParameters['isBackButtonExist']?.toLowerCase() == 'true';
          return WalletScreen(isBacButtonExist: isBackButtonExist);
        },
      ),

      GoRoute(
        path: RouterHelper.addFundToWalletScreen,
        builder: (context, state) {
          final url = state.uri.queryParameters['url'] != null
              ? Uri.decodeComponent(state.uri.queryParameters['url']!)
              : '';
          return AddFundToWalletScreen(url: url);
        },
      ),

      GoRoute(
        path: RouterHelper.wishListScreen,
        builder: (context, state) {
          return const WishListScreen();
        },
      ),


      GoRoute(path: selectLocationScreen, builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SelectLocationScreen(
          googleMapController : extra?['googleMapController'] as GoogleMapController?,
        );
      }),


      GoRoute(path: offlinePaymentScreen, builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final ticketParam = state.uri.queryParameters['payableAmount'];

        return OfflinePaymentScreen (
          payableAmount: double.parse(ticketParam.toString()),
          callback : extra!['callback'] as Function,
        );
      }),

      GoRoute(path: shopOverviewScreen, builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final slug = state.uri.queryParameters['slug'];

        return ShopOverviewScreen (
          slug : slug.toString(),
          scrollController : extra!['scrollController'] as ScrollController,
        );
      }),

      GoRoute(path: orderOfflinePaymentScreen, builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final qp = state.uri.queryParameters;

        return order_offline.OrderOfflinePaymentScreen (
          payableAmount: double.parse(qp['payableAmount'].toString()),
          callback : extra!['callback'] as Function,
          orderId: qp['orderId']!,
        );
      }),


    ]
  );
}
