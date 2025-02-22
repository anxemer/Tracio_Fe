class ApiUrl {
  //base Url
  static const baseURL = 'http://192.168.1.9:';
  // static const baseURL = 'http://172.20.10.2:';
  // static const baseURL = 'http://10.87.46.103:';
  //port
  static const portUser = '5186';
  static const portBlog = '5265';

  //Api User
  static const registerWithEP = '$portUser/api/auth/register-user';
  static const loginWithEP = '$portUser/api/auth/login';

  //Api Blog
  static const reactBlog = '$portBlog/api/reactions';
  static const unReactBlog = '$portBlog/api/reactions';
  static const getReactBlog = '$portBlog/api/reactions';
  static Uri urlGetBlog([Map<String, String>? params]) {
    return Uri.parse('$portBlog/api/blogs').replace(queryParameters: params);
  }

  static const createBlog = '$portBlog/api/blogs';
  static const categoryBlog = '$portBlog/categories';
}
