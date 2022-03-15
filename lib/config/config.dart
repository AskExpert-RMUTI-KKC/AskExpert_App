class Config {
  static const String API_URL = "http://192.168.1.6:8080";

  static const String Page_User     = "/user";
  static const String Page_Comment  = "/comment";
  static const String Page_Topic    = "/topic";
  static const String Page_like     = "/like";

  static const String API_Register_Info   = API_URL + Page_User + "/userinfoWrite";
  static const String API_Register        = API_URL + Page_User + "/register";
  static const String API_Register_Pic    = API_URL + Page_User + "/picprofileWrite";
  static const String API_Login_Google    = API_URL + Page_User + "/logingoogle";
  static const String API_Login_Facebook  = API_URL + Page_User + "/loginfb";
  static const String API_Login           = API_URL + Page_User + "/login";
}