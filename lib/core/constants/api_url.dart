class ApiUrl {
  //base Url
  static const baseURL = 'http://192.168.1.9:';
  //port
  static const portUser = '5186';
  static const portBlog = '5265';

  //Api User
  static const registerWithEP = '$portUser/api/auth/register-user';
  static const loginWithEP = '$portUser/api/auth/login';

  //Api Blog

  static Uri urlGetBlog([Map<String, String>? params]) {
    return Uri.parse('$portBlog/api/blogs').replace(queryParameters: params);
  }
}
