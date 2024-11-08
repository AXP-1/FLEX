class UserModel {
  String? id;
  String? email;
  String? createdAt;
  Metadata? metadata;
  bool? isVerified;
  List<String>? following; // نوع المتابعين محدد كـ List<String> لـ uuid[]

  UserModel({
    this.email,
    this.metadata,
    this.createdAt,
    this.id,
    this.isVerified,
    this.following,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    createdAt = json['created_at'];
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    isVerified = json['is_verified'];
    following = json['following'] != null ? List<String>.from(json['following']) : []; // جلب المتابعين
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['id'] = id;
    data['created_at'] = createdAt;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['is_verified'] = isVerified;
    data['following'] = following; // حفظ المتابعين
    return data;
  }
}

class Metadata {
  String? sub;
  String? name;
  String? email;
  String? image;
  String? description;
  bool? emailVerified;
  bool? phoneVerified;

  Metadata(
      {this.sub,
      this.name,
      this.email,
      this.image,
      this.description,
      this.emailVerified,
      this.phoneVerified});

  Metadata.fromJson(Map<String, dynamic> json) {
    sub = json['sub'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    description = json['description'];
    emailVerified = json['email_verified'];
    phoneVerified = json['phone_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sub'] = sub;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['description'] = description;
    data['email_verified'] = emailVerified;
    data['phone_verified'] = phoneVerified;
    return data;
  }
}
