class CommentDataModel {
  int? likeStatus;
  String? commentData;
  String? commentId;
  String? commentContentId;
  String? commentUserId;
  String? commentCaption;
  int? commentIsSubComment;
  int? commentLikeCount;
  double? commentDonateCount;
  int? commentReportStatus;
  UserInfoData? userInfoData;
  List<CommentDataModel>? subComment;
  int? createdDate;

  CommentDataModel(
      {this.likeStatus,
        this.commentData,
        this.commentId,
        this.commentContentId,
        this.commentUserId,
        this.commentCaption,
        this.commentIsSubComment,
        this.commentLikeCount,
        this.commentDonateCount,
        this.commentReportStatus,
        this.userInfoData,
        this.subComment,
        this.createdDate});

  CommentDataModel.fromJson(Map<String, dynamic> json) {
    likeStatus = json['likeStatus'];
    commentData = json['commentData'];
    commentId = json['commentId'];
    commentContentId = json['commentContentId'];
    commentUserId = json['commentUserId'];
    commentCaption = json['commentCaption'];
    commentIsSubComment = json['commentIsSubComment'];
    commentLikeCount = json['commentLikeCount'];
    commentDonateCount = json['commentDonateCount'];
    commentReportStatus = json['commentReportStatus'];
    userInfoData = json['userInfoData'] != null
        ? new UserInfoData.fromJson(json['userInfoData'])
        : null;
    subComment = json['subComment'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['likeStatus'] = this.likeStatus;
    data['commentData'] = this.commentData;
    data['commentId'] = this.commentId;
    data['commentContentId'] = this.commentContentId;
    data['commentUserId'] = this.commentUserId;
    data['commentCaption'] = this.commentCaption;
    data['commentIsSubComment'] = this.commentIsSubComment;
    data['commentLikeCount'] = this.commentLikeCount;
    data['commentDonateCount'] = this.commentDonateCount;
    data['commentReportStatus'] = this.commentReportStatus;
    if (this.userInfoData != null) {
      data['userInfoData'] = this.userInfoData!.toJson();
    }
    data['subComment'] = this.subComment;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

class UserInfoData {
  String? userInfoId;
  String? userName;
  String? firstName;
  String? lastName;
  String? profilePic;
  bool? verifyStatus;
  Null? expert;
  String? userCaption;
  int? tokenCount;
  int? likeCount;

  UserInfoData(
      {this.userInfoId,
        this.userName,
        this.firstName,
        this.lastName,
        this.profilePic,
        this.verifyStatus,
        this.expert,
        this.userCaption,
        this.tokenCount,
        this.likeCount});

  UserInfoData.fromJson(Map<String, dynamic> json) {
    userInfoId = json['userInfoId'];
    userName = json['userName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePic = json['profilePic'];
    verifyStatus = json['verifyStatus'];
    expert = json['expert'];
    userCaption = json['userCaption'];
    tokenCount = json['tokenCount'];
    likeCount = json['likeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userInfoId'] = this.userInfoId;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['profilePic'] = this.profilePic;
    data['verifyStatus'] = this.verifyStatus;
    data['expert'] = this.expert;
    data['userCaption'] = this.userCaption;
    data['tokenCount'] = this.tokenCount;
    data['likeCount'] = this.likeCount;
    return data;
  }
}