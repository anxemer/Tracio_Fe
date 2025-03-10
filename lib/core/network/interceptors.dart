import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true));

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request ==> $requestPath'); //Error log
    logger.d('Error type: ${err.error} \n '
        'Error message: ${err.message}'); //Debug log
    handler.next(err); //Continue with the Error
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request ==> $requestPath'); //Info log
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('STATUSCODE: ${response.statusCode} \n '
        'STATUSMESSAGE: ${response.statusMessage} \n'
        'HEADERS: ${response.headers} \n'
        'Data: ${response.data}'); // Debug log
    handler.next(response); // continue with the Response
  }
}

class AuthorizationInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    // final token = sharedPreferences.getString('accessToken');
    final token =
        "eyJhbGciOiJSUzI1NiIsImtpZCI6ImJjNDAxN2U3MGE4MWM5NTMxY2YxYjY4MjY4M2Q5OThlNGY1NTg5MTkiLCJ0eXAiOiJKV1QifQ.eyJyb2xlIjoiY3ljbGlzdCIsImN1c3RvbV9pZCI6NiwiaXNzIjoiaHR0cHM6Ly9zZWN1cmV0b2tlbi5nb29nbGUuY29tL3RyYWNpby1jYmQyNiIsImF1ZCI6InRyYWNpby1jYmQyNiIsImF1dGhfdGltZSI6MTc0MTMyODU2OSwidXNlcl9pZCI6Ikpib2pkRWNBTFNZR2FGUEZRU1lNbTRsbTRMazEiLCJzdWIiOiJKYm9qZEVjQUxTWUdhRlBGUVNZTW00bG00TGsxIiwiaWF0IjoxNzQxMzI4NTY5LCJleHAiOjE3NDEzMzIxNjksImVtYWlsIjoidHJtaW5sb2NAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsidHJtaW5sb2NAZ21haWwuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.Qah4c_aFHO0bq8nBovzn_epHy5g-5ad7v1HiPzM2CvyJDlm8qKF-vAE2r0-40i4A5vKWo0KW4WtrpSauKFQQRBOyqVWuN6_PFVLVnLcKSzJs9k0Ojj3RDpDTpHdveESZr074moB11MoYJPJ5QjmW4g9HkCE5iG7p2ESfCUv7AGm9GOgw8WoPyeSSi09yBK-Aa2jMLHLxfZw2dmlHJFTZ_dunEX8lK9Ec1H0kCFQ5Kr9tZ87eI0HQwVbESeeC1ToLnlpkplx4nO6MMnO0-veXx7_o70-asSGSuuh_RN9cAv62EPko6QzXZ-5dyiIv2LUuI9p0XItC60NuCx0IyxviXQ";
    options.headers['Authorization'] = "Bearer $token";
    handler.next(options); // continue with the Request
  }
}
