import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tracio_fe/core/constants/api_url.dart';

import '../../data/auth/sources/auth_local_source/auth_local_source.dart';
import '../../service_locator.dart';

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
    String token = await sl<AuthLocalSource>().getToken();

    options.headers['Authorization'] = "Bearer $token";
    handler.next(options); // continue with the Request
  }
}
