class topicDataModel {
  String? topicId;
  String? topicHeadline;
  String? topicCaption;
  String? topicOwnerId;
  String? topicGroup;
  String? topicPic;

  topicDataModel(
      {this.topicId,
      this.topicHeadline,
      this.topicCaption,
      this.topicOwnerId,
      this.topicGroup,
      this.topicPic});

  topicDataModel.fromJson(Map<String, dynamic> json) {
    topicId = json['topicId'];
    topicHeadline = json['topicHeadline'];
    topicCaption = json['topicCaption'];
    topicOwnerId = json['topicOwnerId'];
    topicGroup = json['topicGroup'];
    topicPic = json['topicPic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topicId'] = this.topicId;
    data['topicHeadline'] = this.topicHeadline;
    data['topicCaption'] = this.topicCaption;
    data['topicOwnerId'] = this.topicOwnerId;
    data['topicGroup'] = this.topicGroup;
    data['topicPic'] = this.topicPic;
    return data;
  }
}
