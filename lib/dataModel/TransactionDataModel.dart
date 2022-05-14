class TransactionDataModel {
  String? tranId;
  String? tranTx;
  String? tranRx;
  int? tranAmount;
  String? tranContentId;
  String? tranStatus;
  String? createdDateForOrder;
  int? createdDate;
  UserInfoDataTx? userInfoDataTx;
  UserInfoDataTx? userInfoDataRx;
  String? topicContent;
  String? topicId;
  String? commentContent;
  String? commentId;
  CommentData? commentData;
  TopicData? topicData;

  TransactionDataModel(
      {this.tranId,
        this.tranTx,
        this.tranRx,
        this.tranAmount,
        this.tranContentId,
        this.tranStatus,
        this.createdDateForOrder,
        this.createdDate,
        this.userInfoDataTx,
        this.userInfoDataRx,
        this.topicContent,
        this.topicId,
        this.commentContent,
        this.commentId,
        this.commentData,
        this.topicData});

  TransactionDataModel.fromJson(Map<String, dynamic> json) {
    tranId = json['tranId'];
    tranTx = json['tranTx'];
    tranRx = json['tranRx'];
    tranAmount = json['tranAmount'];
    tranContentId = json['tranContentId'];
    tranStatus = json['tranStatus'];
    createdDateForOrder = json['createdDateForOrder'];
    createdDate = json['createdDate'];
    userInfoDataTx = json['userInfoDataTx'] != null
        ? new UserInfoDataTx.fromJson(json['userInfoDataTx'])
        : null;
    userInfoDataRx = json['userInfoDataRx'] != null
        ? new UserInfoDataTx.fromJson(json['userInfoDataRx'])
        : null;
    topicContent = json['topicContent'];
    topicId = json['topicId'];
    commentContent = json['commentContent'];
    commentId = json['commentId'];
    commentData = json['commentData'] != null
        ? new CommentData.fromJson(json['commentData'])
        : null;
    topicData = json['topicData'] != null
        ? new TopicData.fromJson(json['topicData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tranId'] = this.tranId;
    data['tranTx'] = this.tranTx;
    data['tranRx'] = this.tranRx;
    data['tranAmount'] = this.tranAmount;
    data['tranContentId'] = this.tranContentId;
    data['tranStatus'] = this.tranStatus;
    data['createdDateForOrder'] = this.createdDateForOrder;
    data['createdDate'] = this.createdDate;
    if (this.userInfoDataTx != null) {
      data['userInfoDataTx'] = this.userInfoDataTx!.toJson();
    }
    if (this.userInfoDataRx != null) {
      data['userInfoDataRx'] = this.userInfoDataRx!.toJson();
    }
    data['topicContent'] = this.topicContent;
    data['topicId'] = this.topicId;
    data['commentContent'] = this.commentContent;
    data['commentId'] = this.commentId;
    if (this.commentData != null) {
      data['commentData'] = this.commentData!.toJson();
    }
    if (this.topicData != null) {
      data['topicData'] = this.topicData!.toJson();
    }
    return data;
  }
}

class UserInfoDataTx {
  String? userInfoId;
  String? userName;
  String? firstName;
  String? lastName;
  String? profilePic;
  bool? verifyStatus;
  Null? expert;
  String? userCaption;
  double? tokenCount;
  int? likeCount;

  UserInfoDataTx(
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

  UserInfoDataTx.fromJson(Map<String, dynamic> json) {
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

class CommentData {
  String? commentId;
  String? commentContentId;
  String? commentUserId;
  String? commentCaption;
  int? commentIsSubComment;
  int? commentLikeCount;
  int? commentDonateCount;
  int? commentReportStatus;
  String? createdDateForOrder;
  int? createdDate;

  CommentData(
      {this.commentId,
        this.commentContentId,
        this.commentUserId,
        this.commentCaption,
        this.commentIsSubComment,
        this.commentLikeCount,
        this.commentDonateCount,
        this.commentReportStatus,
        this.createdDateForOrder,
        this.createdDate});

  CommentData.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    commentContentId = json['commentContentId'];
    commentUserId = json['commentUserId'];
    commentCaption = json['commentCaption'];
    commentIsSubComment = json['commentIsSubComment'];
    commentLikeCount = json['commentLikeCount'];
    commentDonateCount = json['commentDonateCount'];
    commentReportStatus = json['commentReportStatus'];
    createdDateForOrder = json['createdDateForOrder'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['commentContentId'] = this.commentContentId;
    data['commentUserId'] = this.commentUserId;
    data['commentCaption'] = this.commentCaption;
    data['commentIsSubComment'] = this.commentIsSubComment;
    data['commentLikeCount'] = this.commentLikeCount;
    data['commentDonateCount'] = this.commentDonateCount;
    data['commentReportStatus'] = this.commentReportStatus;
    data['createdDateForOrder'] = this.createdDateForOrder;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

class TopicData {
  String? topicId;
  String? topicHeadline;
  String? topicCaption;
  String? topicUserId;
  int? topicLikeCount;
  int? topicCommentCount;
  int? topicReadCount;
  int? topicDonateCount;
  String? topicGroupId;
  int? topicReportStatus;
  String? createdDateForOrder;
  Null? topicCreateDate;
  int? createdDate;

  TopicData(
      {this.topicId,
        this.topicHeadline,
        this.topicCaption,
        this.topicUserId,
        this.topicLikeCount,
        this.topicCommentCount,
        this.topicReadCount,
        this.topicDonateCount,
        this.topicGroupId,
        this.topicReportStatus,
        this.createdDateForOrder,
        this.topicCreateDate,
        this.createdDate});

  TopicData.fromJson(Map<String, dynamic> json) {
    topicId = json['topicId'];
    topicHeadline = json['topicHeadline'];
    topicCaption = json['topicCaption'];
    topicUserId = json['topicUserId'];
    topicLikeCount = json['topicLikeCount'];
    topicCommentCount = json['topicCommentCount'];
    topicReadCount = json['topicReadCount'];
    topicDonateCount = json['topicDonateCount'];
    topicGroupId = json['topicGroupId'];
    topicReportStatus = json['topicReportStatus'];
    createdDateForOrder = json['createdDateForOrder'];
    topicCreateDate = json['topicCreateDate'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topicId'] = this.topicId;
    data['topicHeadline'] = this.topicHeadline;
    data['topicCaption'] = this.topicCaption;
    data['topicUserId'] = this.topicUserId;
    data['topicLikeCount'] = this.topicLikeCount;
    data['topicCommentCount'] = this.topicCommentCount;
    data['topicReadCount'] = this.topicReadCount;
    data['topicDonateCount'] = this.topicDonateCount;
    data['topicGroupId'] = this.topicGroupId;
    data['topicReportStatus'] = this.topicReportStatus;
    data['createdDateForOrder'] = this.createdDateForOrder;
    data['topicCreateDate'] = this.topicCreateDate;
    data['createdDate'] = this.createdDate;
    return data;
  }
}