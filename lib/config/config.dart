class Config {
  static const int appbarBg = 0xFFF1F4F8;
  static const int textColor = 0xFF0F1113;
  static const int buttonPrimary = 0xFFF1F4F8;
  static const int buttonSecondary =  0xFF0F1113;
  static const int warningSnackBar = 0xFFE3170A;
  static const int warningSnackBarText = 0xFFEFEFFEA;
  static const int iconEmail = 0xFF0F1113;
  static const int cursorColor = 0xFF0F1113;




  static const String apiUrl = "http://192.168.1.2:8080";

  static const String pageUser = "/user";
  static const String pageComment = "/Comment";
  static const String pageImg = "/image";
  static const String pageTopic = "/Topic";
  static const String pageLike = "/like";
  static const String pageExpertGroupList = "/expertGroupList";
  static const String pageReport = "/report";
  static const String pageTopicGroupList = "/TopicGroupList";
  static const String pageTransaction = "/transaction";
  static const String pageVerify = "/verify";

  //user
  static const String apiRegisterInfo = apiUrl + pageUser + "/userinfoWrite";
  static const String apiRegister = apiUrl + pageUser + "/register";
  static const String apiRegisterUpdate = apiUrl + pageUser + "/update";
  static const String apiLoginGoogle = apiUrl + pageUser + "/loginGoogle";
  static const String apiLoginFacebook = apiUrl + pageUser + "/loginFb";
  static const String apiLogin = apiUrl + pageUser + "/login";
  static const String apiFindByText = apiUrl + pageUser + "/findByText";

  //Topic
  static const String apiTopicFindAll = apiUrl + pageTopic + "/findAll";
  static const String apiTopicAdd = apiUrl + pageTopic + "/add";
  static const String apiTopicRemove = apiUrl + pageTopic + "/remove";
  static const String apiTopicTopicId = apiUrl + pageTopic + "/findMyTopic";
  static const String apiTopicRead = apiUrl + pageTopic + "/read";
  static const String apiTopicFindByText = apiUrl+pageTopic+"/findByText";

  //Comment
  static const String apiCommentFindAll = apiUrl + pageComment + "/findAll";
  static const String apiTopicTopicID = apiUrl + pageComment + "/findByTopicID";
  static const String apiCommentAdd = apiUrl + pageComment + "/add";
  static const String apiCommentRemove = apiUrl + pageComment + "/remove";
  static const String apiCommentFindMe = apiUrl + pageComment + "/findMyTopic";
  static const String apiFindByCommentId = apiUrl +pageComment+"/findByCommentId";
  static const String apiFindByContentId = apiUrl+pageComment+"/findByContentId";
  static const String apiFindByComment = apiUrl+pageComment+"/findMyComment";

  //Like
  static const String apiLikeSet = apiUrl + pageLike + "/setStatus";
  static const String apiLikeGet = apiUrl + pageLike + "/getStatus";

  //expertGroupList
  static const String apiExpertAdd = apiUrl + pageExpertGroupList +"/add";
  static const String apiExpertRemove = apiUrl + pageExpertGroupList+"/remove";
  static const String apiExpertFindAll = apiUrl + pageExpertGroupList +"/findAll";
  static const String apiExpertFindById = apiUrl + pageExpertGroupList + "/findById";
  static const String apiExpertUpdate = apiUrl+pageExpertGroupList+"/update";

  //Img
  static const String apiImgUserInfoDataProfile = apiUrl + pageImg + "/userInfoDataProfile";
  static const String apiImgTopicImg = apiUrl + pageImg + "/topicImg";
  static const String apiImgCommentImg = apiUrl + pageImg + "/commentImg";
  static const String apiImgVerifyImg = apiUrl + pageImg + "/verifyImg";

  //report
  static const String apiReportAdd = apiUrl + pageReport +"/add";
  static const String apiReportUpdate = apiUrl + pageReport +"/update";
  static const String apiReportFindAll = apiUrl + pageReport +"/findAll";
  static const String apiReportFindByContentId = apiUrl + pageReport +"/findByContentId";

  //TopicGroupList
  static const String apiTopicGroupListAdd = apiUrl+pageTopicGroupList+"/add";
  static const String apiTopicGroupListRemove = apiUrl+pageTopicGroupList+"/remove";
  static const String apiTopicGroupListFindAll = apiUrl+pageTopicGroupList+"/findAll";
  static const String apiTopicGroupListFindById = apiUrl+pageTopicGroupList+"/findById";
  static const String apiTopicGroupListUpdate = apiUrl+pageTopicGroupList+"/update";

  //transaction
  static const String apiTransactionTransfer = apiUrl + pageTransaction + "/";
  static const String apiTransactionWithdraw = apiUrl + pageTransaction + "/withdraw";
  static const String apiTransactionDeposit = apiUrl + pageTransaction + "/deposit";
  static const String apiTransactionTransactionHistory = apiUrl + pageTransaction + "/transactionHistory";
  static const String apiTransactionFindMyPay = apiUrl + pageTransaction + "/findMyPay";

  //verify
  static const String apiVerifyAdd = apiUrl + pageVerify +  "/add";
  static const String apiVerifyFindAll = apiUrl + pageVerify +  "/findAll";
  static const String apiVerifyFindById = apiUrl + pageVerify +  "/findById";
  static const String apiVerifyFindMyVerify = apiUrl + pageVerify +  "/findMyVerify";
  static const String apiVerifyUpdate = apiUrl + pageVerify +  "/update";
}
