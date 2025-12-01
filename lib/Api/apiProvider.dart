import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:posramanastab/Bloc/Response/errorResponse.dart';
import 'package:posramanastab/ModelClass/Authentication/Post_login_model.dart';
import 'package:posramanastab/ModelClass/ShiftClosing/getShiftClosingModel.dart';
import 'package:posramanastab/ModelClass/ShiftClosing/postDailyClosingModel.dart';
import 'package:posramanastab/ModelClass/ShopDetails/getStockMaintanencesModel.dart';
import 'package:posramanastab/Reusable/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All API Integration in ApiProvider
class ApiProvider {
  late Dio _dio;

  /// dio use ApiProvider
  ApiProvider() {
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    );
    _dio = Dio(options);
  }

  /// LoginWithOTP API Integration
  Future<PostLoginModel> loginAPI(String email, String password) async {
    try {
      final dataMap = {"email": email, "password": password};
      var data = json.encode(dataMap);
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}auth/users/login'.trim(),
        options: Options(
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
        ),
        data: data,
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          PostLoginModel postLoginResponse = PostLoginModel.fromJson(
            response.data,
          );
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString(
            "token",
            postLoginResponse.token.toString(),
          );
          sharedPreferences.setString(
            "role",
            postLoginResponse.user!.role.toString(),
          );
          sharedPreferences.setString(
            "userId",
            postLoginResponse.user!.id.toString(),
          );
          return postLoginResponse;
        }
      }
      return PostLoginModel()
        ..errorResponse = ErrorResponse(message: "Unexpected error occurred.");
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return PostLoginModel()..errorResponse = errorResponse;
    } catch (error) {
      return PostLoginModel()..errorResponse = handleError(error);
    }
  }

  /***** Shift closing *****/
  /// Shift Closing - API Integration
  Future<GetShiftClosingModel> getShiftClosingAPI(String? date) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    debugPrint("token:$token");
    debugPrint(
      "BaseUrl:${Constants.baseUrl}api/dashboard/dailyclosing?date=$date",
    );

    try {
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}api/dashboard/dailyclosing?date=$date',
        options: Options(
          method: 'GET',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          GetShiftClosingModel getShiftClosingResponse =
              GetShiftClosingModel.fromJson(response.data);
          return getShiftClosingResponse;
        }
      } else {
        return GetShiftClosingModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
      return GetShiftClosingModel()
        ..errorResponse = ErrorResponse(
          message: "Unexpected error occurred.",
          statusCode: 500,
        );
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return GetShiftClosingModel()..errorResponse = errorResponse;
    } catch (error) {
      final errorResponse = handleError(error);
      return GetShiftClosingModel()..errorResponse = errorResponse;
    }
  }

  /// save ShiftClosing API Integration
  Future<PostDailyClosingModel> postDailyShiftAPI(
    String date,
    String upiAmount,
    String enteredUpiAmount,
    String cardAmount,
    String enteredCardAmount,
    String hdAmount,
    String enteredHdAmount,
    String totalCashAmount,
    String cashInHandAmount,
    String enteredCashInHandAmount,
    String expectedCashAmount,
    String totalSalesAmount,
    String totalExpensesAmount,
    String overallExpensesAmount,
    String differenceAmount,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    debugPrint("token:$token");
    try {
      final dataMap = {
        "date": date,
        "UpiAmount": upiAmount,
        "EnteredUpiAmount": enteredUpiAmount,
        "CardAmount": cardAmount,
        "EnteredCardAmount": enteredCardAmount,
        "HdAmount": hdAmount,
        "EnteredHdAmount": enteredHdAmount,
        "totalcashAmount": totalCashAmount,
        "CashInhandAmount": cashInHandAmount,
        "EnteredCashInhandAmount": enteredCashInHandAmount,
        "expectedCashAmount": expectedCashAmount,
        "TotalSalesAmount": totalSalesAmount,
        "TotalExpensesAmount": totalExpensesAmount,
        "overallExpensesAmount": overallExpensesAmount,
        "DifferenceAmount": differenceAmount,
      };
      var data = json.encode(dataMap);
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}api/dashboard/dailyclosing',
        options: Options(
          method: 'POST',
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: data,
      );
      if (response.statusCode == 201 && response.data != null) {
        try {
          PostDailyClosingModel postDailyClosingResponse =
              PostDailyClosingModel.fromJson(response.data);
          return postDailyClosingResponse;
        } catch (e) {
          return PostDailyClosingModel()
            ..errorResponse = ErrorResponse(
              message: "Failed to parse response: $e",
            );
        }
      } else {
        return PostDailyClosingModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return PostDailyClosingModel()..errorResponse = errorResponse;
    } catch (error) {
      return PostDailyClosingModel()..errorResponse = handleError(error);
    }
  }

  /// Stock Details - Fetch API Integration
  Future<GetStockMaintanencesModel> getStockDetailsAPI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("token");
    try {
      var dio = Dio();
      var response = await dio.request(
        '${Constants.baseUrl}api/shops',
        options: Options(
          method: 'GET',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          GetStockMaintanencesModel getShopDetailsResponse =
              GetStockMaintanencesModel.fromJson(response.data);
          return getShopDetailsResponse;
        }
      } else {
        return GetStockMaintanencesModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            statusCode: response.statusCode,
          );
      }
      return GetStockMaintanencesModel()
        ..errorResponse = ErrorResponse(
          message: "Unexpected error occurred.",
          statusCode: 500,
        );
    } on DioException catch (dioError) {
      final errorResponse = handleError(dioError);
      return GetStockMaintanencesModel()..errorResponse = errorResponse;
    } catch (error) {
      return GetStockMaintanencesModel()..errorResponse = handleError(error);
    }
  }

  /// handle Error Response
  ErrorResponse handleError(Object error) {
    ErrorResponse errorResponse = ErrorResponse();
    Errors errorDescription = Errors();

    if (error is DioException) {
      DioException dioException = error;

      switch (dioException.type) {
        case DioExceptionType.cancel:
          errorDescription.code = "0";
          errorDescription.message = "Request Cancelled";
          errorResponse.statusCode = 0;
          break;

        case DioExceptionType.connectionTimeout:
          errorDescription.code = "522";
          errorDescription.message = "Connection Timeout";
          errorResponse.statusCode = 522;
          break;

        case DioExceptionType.sendTimeout:
          errorDescription.code = "408";
          errorDescription.message = "Send Timeout";
          errorResponse.statusCode = 408;
          break;

        case DioExceptionType.receiveTimeout:
          errorDescription.code = "408";
          errorDescription.message = "Receive Timeout";
          errorResponse.statusCode = 408;
          break;

        case DioExceptionType.badResponse:
          if (dioException.response != null) {
            final statusCode = dioException.response!.statusCode!;
            errorDescription.code = statusCode.toString();
            errorResponse.statusCode = statusCode;

            if (statusCode == 401) {
              try {
                final message =
                    dioException.response!.data["message"] ??
                    dioException.response!.data["error"] ??
                    dioException.response!.data["errors"]?[0]?["message"];

                if (message != null &&
                    (message.toLowerCase().contains("token") ||
                        message.toLowerCase().contains("expired"))) {
                  errorDescription.message =
                      "Session expired. Please login again.";
                  errorResponse.message =
                      "Session expired. Please login again.";
                } else if (message != null &&
                    (message.toLowerCase().contains("invalid credentials") ||
                        message.toLowerCase().contains("unauthorized") ||
                        message.toLowerCase().contains("incorrect"))) {
                  errorDescription.message =
                      "Invalid credentials. Please try again.";
                  errorResponse.message =
                      "Invalid credentials. Please try again.";
                } else {
                  errorDescription.message = message;
                  errorResponse.message = message;
                }
              } catch (_) {
                errorDescription.message = "Unauthorized access";
                errorResponse.message = "Unauthorized access";
              }
            } else if (statusCode == 403) {
              errorDescription.message = "Access forbidden";
              errorResponse.message = "Access forbidden";
            } else if (statusCode == 404) {
              errorDescription.message = "Resource not found";
              errorResponse.message = "Resource not found";
            } else if (statusCode == 500) {
              errorDescription.message = "Internal Server Error";
              errorResponse.message = "Internal Server Error";
            } else if (statusCode >= 400 && statusCode < 500) {
              // Client errors - try to get API message
              try {
                final apiMessage =
                    dioException.response!.data["message"] ??
                    dioException.response!.data["errors"]?[0]?["message"];
                errorDescription.message =
                    apiMessage ?? "Client error occurred";
                errorResponse.message = apiMessage ?? "Client error occurred";
              } catch (_) {
                errorDescription.message = "Client error occurred";
                errorResponse.message = "Client error occurred";
              }
            } else if (statusCode >= 500) {
              // Server errors
              errorDescription.message = "Server error occurred";
              errorResponse.message = "Server error occurred";
            } else {
              // Other status codes - fallback to API-provided message
              try {
                final message =
                    dioException.response!.data["message"] ??
                    dioException.response!.data["errors"]?[0]?["message"];
                errorDescription.message = message ?? "Something went wrong";
                errorResponse.message = message ?? "Something went wrong";
              } catch (_) {
                errorDescription.message = "Unexpected error response";
                errorResponse.message = "Unexpected error response";
              }
            }
          } else {
            errorDescription.code = "500";
            errorDescription.message = "Internal Server Error";
            errorResponse.statusCode = 500;
            errorResponse.message = "Internal Server Error";
          }
          break;

        case DioExceptionType.unknown:
          errorDescription.code = "500";
          errorDescription.message = "Unknown error occurred";
          errorResponse.statusCode = 500;
          errorResponse.message = "Unknown error occurred";
          break;

        case DioExceptionType.badCertificate:
          errorDescription.code = "495";
          errorDescription.message = "Bad SSL Certificate";
          errorResponse.statusCode = 495;
          errorResponse.message = "Bad SSL Certificate";
          break;

        case DioExceptionType.connectionError:
          errorDescription.code = "500";
          errorDescription.message = "Connection error occurred";
          errorResponse.statusCode = 500;
          errorResponse.message = "Connection error occurred";
          break;
      }
    } else {
      errorDescription.code = "500";
      errorDescription.message = "An unexpected error occurred";
      errorResponse.statusCode = 500;
      errorResponse.message = "An unexpected error occurred";
    }

    errorResponse.errors = [errorDescription];
    return errorResponse;
  }
}
