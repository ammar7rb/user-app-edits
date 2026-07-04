import 'dart:io';
import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class OrderDetailsRepositoryInterface<T> extends RepositoryInterface{

  Future<dynamic> getOrderFromOrderId(String orderID);

  Future<dynamic> getOrderInvoice(String orderID);

  Future<dynamic> downloadDigitalProduct(int orderDetailsId);

  Future<dynamic> resendOtpForDigitalProduct(int orderId);

  Future<dynamic> otpVerificationForDigitalProduct(int orderId, String otp);

  Future<dynamic> trackYourOrder(String orderId, String phoneNumber);

  Future<dynamic> getTrackOrderDetailsId(String orderId);

  Future<HttpClientResponse> productDownload(String url);

  Future<dynamic> duePaymentByCod(int orderId, String paymentMethod, String? bringChangeAmount);

  Future<dynamic> duePaymentByDigitalPayment(int orderId, String paymentMethod, String? guestId, String? orderDuePaymentNote, String? currencyCode);

  Future<dynamic> duePaymentByWallet(int orderId, String paymentMethod);

  Future<dynamic> duePaymentByOfflinePayment(int orderId, String paymentMethod, String? orderDueNote, String? methodId);

}