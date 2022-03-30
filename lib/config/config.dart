class Config {
  static const String API_URL = "http://192.168.1.2:8080";

  static const String Page_User     = "/user";
  static const String Page_Comment  = "/comment";
  static const String Page_Topic    = "/topic";
  static const String Page_like     = "/like";

  //profile
  static const String API_Register_Info   = API_URL + Page_User + "/userinfoWrite";
  static const String API_Register        = API_URL + Page_User + "/register";
  static const String API_Register_Pic    = API_URL + Page_User + "/picprofileWrite";
  static const String API_Login_Google    = API_URL + Page_User + "/logingoogle";
  static const String API_Login_Facebook  = API_URL + Page_User + "/loginfb";
  static const String API_Login           = API_URL + Page_User + "/login";

  //topic
  static const String API_TOPIC_FINDALL   = API_URL + Page_Topic + "/findAll";
  static const String API_TOPIC_ADD       = API_URL + Page_Topic + "/add";
  static const String API_TOPIC_REMOVE    = API_URL + Page_Topic + "/remove";
  static const String API_TOPIC_FINDME    = API_URL + Page_Topic + "/findMyTopic";

  //Comment
  static const String API_COMMENT_FINDALL   = API_URL + Page_Comment + "/findAll";
  static const String API_TOPIC_TOPICID     = API_URL + Page_Comment + "/findByTopicID";
  static const String API_COMMENT_ADD       = API_URL + Page_Comment + "/add";
  static const String API_COMMENT_REMOVE    = API_URL + Page_Comment + "/remove";
  static const String API_COMMENT_FINDME    = API_URL + Page_Comment + "/findMyTopic";

}