import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/order_place_bottomsheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/route_healper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/animated_custom_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/order_place_dialog_widget.dart';
import 'package:provider/provider.dart';

class DigitalPaymentScreen extends StatefulWidget {
  final String url;
  final bool fromWallet;
  final String orderId;
  const DigitalPaymentScreen({super.key, required this.url, this.fromWallet = false, this.orderId = ''});

  @override
  DigitalPaymentScreenState createState() => DigitalPaymentScreenState();
}

class DigitalPaymentScreenState extends State<DigitalPaymentScreen> {
  late final WebViewController controller;
  bool _isLoading = true;
  bool _canRedirect = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    controller = WebViewController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initWebViewController();
      _isInitialized = true;
    }
  }

  void _initWebViewController() {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).cardColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() => _isLoading = false);
            }
          },
          onPageStarted: (String url) => _checkRedirect(url),
          onPageFinished: (String url) => _checkRedirect(url),
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView Error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            if (_isRedirectUrl(request.url)) {
              _checkRedirect(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  bool _isRedirectUrl(String url) {
    return ((url.contains('success') && url.contains('token')) || url.contains('fail') || url.contains('cancel'))
        && url.contains(AppConstants.baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomSafePadding = MediaQuery.of(context).padding.bottom;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (val, _) {
        if (_canRedirect) _exitApp(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          title: Text(getTranslated('payment', context) ?? 'Payment'),
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: () => _exitApp(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: bottomSafePadding),
          ],
        ),
      ),
    );
  }

  void _checkRedirect(String url) {

    if (_canRedirect && _isRedirectUrl(url)) {
      _canRedirect = false;
      
      bool isSuccess = url.contains('success');
      bool isFailed = url.contains('fail');
      bool isCancel = url.contains('cancel');
      bool isNewUser = _getIsNewUser(url);
      String? orderIds = _getOrderIds(url);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handlePaymentResult(isSuccess, isFailed, isCancel, isNewUser, orderIds);
      });
    }
  }

  void _handlePaymentResult(bool isSuccess, bool isFailed, bool isCancel, bool isNewUser, String? orderIds) {
    bool isLoggedIn = Provider.of<AuthController>(context, listen: false).isLoggedIn();

    // if (Navigator.canPop(context)) {
    //   Navigator.pop(context);
    // }

    if (isSuccess) {
      if (widget.orderId.trim().isNotEmpty &&  orderIds == null) {
        RouterHelper.getOrderDetailsScreenRoute(
          orderId: int .parse(widget.orderId),
          action: RouteAction.pushReplacement,
          isNotification: true
        );
      } else if (isLoggedIn && orderIds != null && orderIds.isNotEmpty) {
        RouterHelper.getOrderScreenRoute(isBackButtonExist: true, action: RouteAction.push, fromPlaceOrder: true);
      } else {
        RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page: 'home');
      }

      if(widget.orderId.trim() == 'null') {
        _showResultUI(
          isBottomSheet: true,
          orderIds: orderIds,
          isNewUser: isNewUser,
          icon: Icons.check,
          titleKey: isNewUser ? 'order_placed_Account_Created' : 'order_placed',
          descKey: 'your_order_placed'
        );
      }
    } else {
      RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page: 'home');

      _showResultUI(
          isBottomSheet: false,
          icon: Icons.clear,
          titleKey: isFailed ? 'payment_failed' : 'payment_cancelled',
          descKey: isFailed ? 'your_payment_failed' : 'your_payment_cancelled',
          isFailed: true
      );
    }
  }

  void _showResultUI({
    required bool isBottomSheet,
    String? orderIds,
    bool isNewUser = false,
    required IconData icon,
    required String titleKey,
    required String descKey,
    bool isFailed = false
  }) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (isBottomSheet) {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20))
              ),
              child: OrderPlaceBottomSheetWidget(
                orderID: orderIds,
                icon: icon,
                title: getTranslated(titleKey, Get.context!),
                description: getTranslated(descKey, Get.context!),
                isFailed: isFailed
              ),
            ),
          ),
        );
      } else {
        showAnimatedDialog(
            Get.context!,
            OrderPlaceDialogWidget(
                icon: icon,
                title: getTranslated(titleKey, Get.context!),
                description: getTranslated(descKey, Get.context!),
                isFailed: isFailed
            ),
            dismissible: false,
            willFlip: true
        );
      }
    });
  }

  bool _getIsNewUser(String url) {
    try {
      Uri uri = Uri.parse(url);
      return uri.queryParameters['new_user'] == '1';
    } catch (e) {
      return false;
    }
  }

  String? _getOrderIds(String url) {
    try {
      Uri uri = Uri.parse(url);
      String? encodedData = uri.queryParameters['order_ids'];
      if (encodedData != null && encodedData.isNotEmpty) {
        String decoded = utf8.decode(base64.decode(encodedData));
        return Provider.of<CheckoutController>(context, listen: false).extractId(decoded);
      }
    } catch (e) {
      debugPrint("Order ID Extraction Error: $e");
    }
    return '';
  }

  Future<void> _exitApp(BuildContext context) async {
    if (!_canRedirect) return;
    _canRedirect = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      RouterHelper.getDashboardRoute(action: RouteAction.pushReplacement, page: 'home');
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      showAnimatedDialog(
        Get.context!,
        OrderPlaceDialogWidget(
          icon: Icons.clear,
          title: getTranslated('payment_cancelled', Get.context!),
          description: getTranslated('your_payment_cancelled', Get.context!),
          isFailed: true,
        ),
        dismissible: false,
        willFlip: true,
      );
    });
  }

}