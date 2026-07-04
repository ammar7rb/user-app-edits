import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_toast.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:fluttertoast/fluttertoast.dart';

 void showCustomSnackBar(String? message, BuildContext context, {bool isError = true, bool isToaster = false}) {
   Fluttertoast.showToast(
     msg: message!,
     toastLength: Toast.LENGTH_SHORT,
     gravity: ToastGravity.BOTTOM,

     timeInSecForIosWeb: 1,
     backgroundColor: isError ? const Color(0xFFFF0014) : const Color(0xFF1E7C15),
     textColor: Colors.white,
     fontSize: 16.0
   );
}

enum SnackBarType {
  error,
  warning,
  success,
}

void showCustomSnackBarWidget(String? message, BuildContext? context, {SnackBarType snackBarType = SnackBarType.success}) {
  final scaffold = ScaffoldMessenger.of(context ?? Get.context!);
  scaffold.showSnackBar(
    SnackBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      content: CustomToast(text: message ?? '', sanckBarType: snackBarType),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showOverlaySnackBar(BuildContext context, String? message,
    {SnackBarType snackBarType = SnackBarType.success, Duration duration = const Duration(seconds: 3)}) {
  final overlay = Overlay.of(context);
  if (message == null || message.isEmpty) return;

  final bottomInset = MediaQuery.of(context).viewInsets.bottom;

  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, bottom: bottomInset + Dimensions.paddingSizeDefault,
      child: Material(color: Colors.transparent, child: CustomToast(text: message, sanckBarType: snackBarType))),
  );

  overlay.insert(overlayEntry);

  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}