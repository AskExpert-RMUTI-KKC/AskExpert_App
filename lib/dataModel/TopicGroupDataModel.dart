class TopicGroupDataModel {
  String? topicGroupId;
  String? topicGroupPath;
  int? topicGroupStatus;

  TopicGroupDataModel(
      {this.topicGroupId, this.topicGroupPath, this.topicGroupStatus});

  TopicGroupDataModel.fromJson(Map<String, dynamic> json) {
    topicGroupId = json['topicGroupId'];
    topicGroupPath = json['topicGroupPath'];
    topicGroupStatus = json['topicGroupStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topicGroupId'] = this.topicGroupId;
    data['topicGroupPath'] = this.topicGroupPath;
    data['topicGroupStatus'] = this.topicGroupStatus;
    return data;
  }
}