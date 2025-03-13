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
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJKYm9qZEVjQUxTWUdhRlBGUVNZTW00bG00TGsxIiwianRpIjoiODU3ODQzMjctOTdkOC00MmVlLWIyN2YtZDdlMzU2Y2E1YmYwIiwicm9sZSI6InVzZXIiLCJ1bmlxdWVfbmFtZSI6IlRyYW4gTWluaCBMb2MiLCJlbWFpbCI6InRybWlubG9jQGdtYWlsLmNvbSIsImN1c3RvbV9pZCI6IjYiLCJuYmYiOjE3NDE4MjMyODcsImV4cCI6MTc0MTgyNjg4NywiaWF0IjoxNzQxODIzMjg3LCJpc3MiOiJVc2VyIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NTAwMyJ9.CpW-HRDQGaO5AmRi8hL8ptAuMffi1fq87VBU18AV1kQ";
    options.headers['Authorization'] = "Bearer $token";
    handler.next(options); // continue with the Request
  }
}
