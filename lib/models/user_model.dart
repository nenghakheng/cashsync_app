class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? authMethod;
  String? imageUrl;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.authMethod,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['data']['id'],
      name: json['data']['name'],
      email: json['data']['email'],
      password: json['data']['password'],
      authMethod: json['data']['authMethod'],
      imageUrl: json['data']['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }
}
