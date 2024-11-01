class RaisesModel {
  int? postId;
  String? userId;

  RaisesModel({this.postId, this.userId});

  RaisesModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = postId;
    data['user_id'] = userId;
    return data;
  }
}
