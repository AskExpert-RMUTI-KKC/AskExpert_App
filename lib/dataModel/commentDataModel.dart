class commentDataModel {
  String? commentId;
  String? commentTopicOwnerId;
  String? commentOwnerId;
  String? commentCaption;
  String? commentPic;
  String? createdDateForOrder;
  int? createdDate;

  commentDataModel(
      {this.commentId,
        this.commentTopicOwnerId,
        this.commentOwnerId,
        this.commentCaption,
        this.commentPic,
        this.createdDateForOrder,
        this.createdDate});

  commentDataModel.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    commentTopicOwnerId = json['commentTopicOwnerId'];
    commentOwnerId = json['commentOwnerId'];
    commentCaption = json['commentCaption'];
    commentPic = json['commentPic'];
    createdDateForOrder = json['createdDateForOrder'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['commentTopicOwnerId'] = this.commentTopicOwnerId;
    data['commentOwnerId'] = this.commentOwnerId;
    data['commentCaption'] = this.commentCaption;
    data['commentPic'] = this.commentPic;
    data['createdDateForOrder'] = this.createdDateForOrder;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
