import 'dart:io';

abstract class OrderDetailsServiceInterface {

  Future<dynamic> getOrderFromOrderId(String orderID);

  Future <dynamic> getOrderDetails(String orderID);

  Future <dynamic> getOrderInvoice(String orderID);

  Future<dynamic> downloadDigitalProduct(int orderDetailsId);

  Future<dynamic> resentDigitalProductOtp(int orderId);

  Future<dynamic> verifyDigitalProductOtp(int orderId, String otp);

  Future<dynamic> trackOrder(String orderId, String phoneNumber);

  Future<dynamic> getTrackOrderDetailsId(String orderId);

  Future<HttpClientResponse> productDownload(String url);

  Future<dynamic> duePaymentByCod(int orderId, String paymentMethod, String? bringChangeAmount);

  Future<dynamic> duePaymentByDigitalPayment(int orderId, String paymentMethod, String? guestId, String? orderDuePaymentNote, String? currencyCode);

  Future<dynamic> duePaymentByWallet(int orderId, String paymentMethod);

  Future<dynamic> duePaymentByOfflinePayment(int orderId, String paymentMethod, String? orderDueNote, String? methodId);

}
