import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginController with ChangeNotifier {
  Map? userData;
  String? loginStatusMessage;
  late LoginResult result;
  final FacebookAuth facebookAuth = FacebookAuth.instance;

  Future<void> login() async {
    // 1. Reset state
    userData = null;
    loginStatusMessage = null;

    // Default to 'enabled' (Classic) for all non-iOS platforms
    var loginTracking = LoginTracking.enabled;

    // 2. Platform-specific pre-login setup
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        final status = await AppTrackingTransparency.requestTrackingAuthorization();
        debugPrint('ATT Status: $status');

        loginTracking = LoginTracking.enabled;
      } catch (e) {
        // Handle potential PlatformException if the plugin setup is incomplete
        debugPrint('ATT Error: $e');
        loginStatusMessage = 'iOS ATT failed: $e';
        notifyListeners();
        return;
      }
    }




    try {
      result = await facebookAuth.login(
        permissions: ['public_profile', 'email'],
        loginTracking: loginTracking,
      );
    } catch (e) {
      loginStatusMessage = 'Login Exception: $e';
      debugPrint(loginStatusMessage);
      notifyListeners();
      return;
    }


    // 4. Handle the Login Result
    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken!;

      debugPrint('Access Token Type: ${accessToken.type}');

      // The AccessTokenType check handles the different tokens returned by the Facebook SDK
      // (Limited on iOS when ATT is denied, Classic otherwise)
      if (accessToken.type == AccessTokenType.classic) {
        // This is a full token, safe to call Graph API
        userData = await FacebookAuth.instance.getUserData(fields: 'name, email');
        loginStatusMessage = 'Login Success (Classic Token). User Data fetched.';
      } else {
        // This is a limited token (usually iOS/ATT denied). Graph API calls will fail.
        loginStatusMessage = 'Login Success (Limited Token). Cannot use for Graph API requests.';
        debugPrint('Limited Token: Graph API calls for additional data (like getUserData) will fail.');
      }

    } else if (result.status == LoginStatus.cancelled) {
      loginStatusMessage = 'Login Cancelled.';
    } else if (result.status == LoginStatus.failed) {
      loginStatusMessage = 'Login Failed: ${result.message}';
      debugPrint('Facebook Login Error: ${result.message}');
    }

    notifyListeners();
  }
}
