import 'dart:io';

import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/repositories/order_details_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class OrderDetailsRepository implements OrderDetailsRepositoryInterface{
  final DioClient? dioClient;
  OrderDetailsRepository({required this.dioClient});

  @override
  Future<ApiResponseModel> get(String orderID) async {
    try {
      final response = await dioClient!.get(AppConstants.orderDetailsUri+orderID);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getOrderFromOrderId(String orderID) async {
    try {
      final response = await dioClient!.get('${AppConstants.getOrderFromOrderId}$orderID&guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponseModel> downloadDigitalProduct(int orderDetailsId) async {
    try {
      final response = await dioClient!.get('${AppConstants.downloadDigitalProduct}$orderDetailsId?guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> resendOtpForDigitalProduct(int orderId) async {
    try {
      final response = await dioClient!.post(AppConstants.otpVResendForDigitalProduct,
      data: {'order_details_id' : orderId});
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> otpVerificationForDigitalProduct(int orderId, String otp) async {
    try {
      final response = await dioClient!.get('${AppConstants.otpVerificationForDigitalProduct}?order_details_id=$orderId&otp=$otp&guest_id=1',);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> trackYourOrder(String orderId, String phoneNumber) async {
    try {
      final response = await dioClient!.post(
        AppConstants.orderTrack,
        data: {
          'order_id': orderId,
          'phone_number' : phoneNumber
        }
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> reorder(String orderId) async {
    try {
      final response = await dioClient!.post(AppConstants.reorder,
          data: {'order_id': orderId,
          });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> getTrackOrderDetailsId(String orderID) async {
    try {
      final response = await dioClient!.get('${AppConstants.orderDetailsTrack}$orderID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }


  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future getOrderInvoice(String orderID) async{
    try {
      final response = await dioClient!.get('${AppConstants.generateInvoice}$orderID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }




  @override
  Future<HttpClientResponse> productDownload(String? url) async {
      HttpClient client = HttpClient();
    final response = await client.getUrl(Uri.parse(url!)).then((HttpClientRequest request) {
          return request.close();
        },
      );
    return response;
  }

  @override
  Future<ApiResponseModel> duePaymentByCod(int orderId, String paymentMethod, String? bringChangeAmount) async {
    try {
      final response = await dioClient!.post(AppConstants.duePaymentByCodUri,
          data: {
            'order_id': orderId,
            'payment_method': paymentMethod,
            'bring_change_amount': bringChangeAmount
          });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponseModel> duePaymentByDigitalPayment(int orderId, String paymentMethod, String? guestId, String? orderDuePaymentNote, String? currencyCode) async {
    try {
      final response = await dioClient!.post(AppConstants.duePaymentByDigitalPayment,
          data: {
            'order_id': orderId,
            'payment_method': paymentMethod,
            'guest_id': guestId,
            'payment_platform': 'app',
            'order_due_payment_note': orderDuePaymentNote,
            'payment_request_from': 'app',
            'current_currency_code' : currencyCode,
          });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponseModel> duePaymentByOfflinePayment(int orderId, String paymentMethod, String? orderDueNote, String? methodId) async {
    try {
      final response = await dioClient!.post(AppConstants.duePaymentByOfflinePayment,
          data: {
            'order_id': orderId,
            'payment_method': paymentMethod,
            'order_due_payment_note': orderDueNote,
            'method_id': methodId,
          });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }




  @override
  Future<ApiResponseModel> duePaymentByWallet(int orderId, String paymentMethod) async {
    try {
      final response = await dioClient!.post(AppConstants.duePaymentByWallet,
        data: {
          'order_id': orderId,
          'payment_method': paymentMethod
        });
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // @override
  // Future<ApiResponseModel> duePaymentByOfflinePayment(int orderId, String paymentMethod, String? orderDuePaymentNote, String? methodId) async {
  //   try {
  //     final response = await dioClient!.post(AppConstants.duePaymentByDigitalPayment,
  //       data: {
  //         'order_id': orderId,
  //         'payment_method': paymentMethod,
  //         'order_due_payment_note': orderDuePaymentNote,
  //         'method_id' : methodId,
  //       }
  //     );
  //     return ApiResponseModel.withSuccess(response);
  //   } catch (e) {
  //     return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
  //   }
  // }


  // duePaymentByOfflinePayment


}
