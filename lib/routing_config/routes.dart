class YRRoutes {
  YRRoutes._privateConstructor();

  /// base pages
  static const initialLoading = "/initialLoading";
  static const unknown = "/unknown";

  static const login = "/login";
  static const register = "/register";
  static const resetPassword = "/reset-password";
  static const resetPasswordSuccess = "/reset-password-success";

  /// nav bar pages
  static const dashBoard = "/dashboard";
  static const blog = "/blog";
  static const profileMenu = "/menu-and-settings";
}

extension RouteData on String {
  String addDataTag(String data) {
    return "$this?data=$data";
  }
}
