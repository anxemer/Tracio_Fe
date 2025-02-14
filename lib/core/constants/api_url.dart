class ApiUrl {
  static const baseURL = 'http://192.168.1.9:';
  static const portUser = '5186';
  static const portBlog = '7005';

  static const registerWithEP = '$portUser/api/auth/register-user';
  static const loginWithEP = '$portUser/api/auth/login';
  static Uri getBlog(String endpoint, [Map<String, String>? params]) {
    return Uri.parse('$portBlog').replace(queryParameters: params);
  }
}
