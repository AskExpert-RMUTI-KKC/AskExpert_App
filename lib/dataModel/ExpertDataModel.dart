class ExpertDataModel {
  String? expertGroupId;
  String? expertPath;
  int? expertStatus;

  ExpertDataModel({this.expertGroupId, this.expertPath, this.expertStatus});

  ExpertDataModel.fromJson(Map<String, dynamic> json) {
    expertGroupId = json['expertGroupId'];
    expertPath = json['expertPath'];
    expertStatus = json['expertStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expertGroupId'] = this.expertGroupId;
    data['expertPath'] = this.expertPath;
    data['expertStatus'] = this.expertStatus;
    return data;
  }
}