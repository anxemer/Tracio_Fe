import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tracio_fe/core/constants/api_url.dart';

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
        'Error message: ${err.response}'); //Debug log
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
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
    // final token = sharedPreferences.getString('accessToken');
    if (options.path.contains(ApiUrl.loginWithEP)) {
      handler.next(options);
      return;
    }
    // String token = await sl<AuthLocalSource>().getToken(); 
    String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJGNUYxNGF2SWZBWDhKVFVSS2F2b25YZkdQUVMyIiwianRpIjoiMGRkMDA5NDEtZWUxZi00ZjM1LTg5NTctNDY5OGVlNzFlODNhIiwicm9sZSI6InVzZXIiLCJ1bmlxdWVfbmFtZSI6Ikzhu5ljIFRy4bqnbiBNaW5oIChTRTE3MTI0NikiLCJlbWFpbCI6InRybWlubG9jQGdtYWlsLmNvbSIsImN1c3RvbV9pZCI6IjYiLCJhdmF0YXIiOiJodHRwczovL3VzZXJhdmF0YXJ0cmFjaW8uczMuYW1hem9uYXdzLmNvbS83ZmNkMjNmYi03NDJhLTQ2YWYtODI0MC01YWRmYTU0YTQ1MmNfYXZhdGFyJTIwZmluYWwuanBnIiwibmJmIjoxNzQyMjk3Njc5LCJleHAiOjE3NDIzMDEyNzksImlhdCI6MTc0MjI5NzY3OSwiaXNzIjoiVXNlciIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjUwMDMifQ.ZVpIT0skjq_rn1RIkjldqlqD_MPwjKYoAnyX9yFo45I";
    options.headers['Authorization'] = "Bearer $token";
    handler.next(options); // continue with the Request
  }
}
