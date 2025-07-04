class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? authMethod;

  UserModel({this.id, this.name, this.email, this.password, this.authMethod});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['data']['id'],
      name: json['data']['name'],
      email: json['data']['email'],
      password: json['data']['password'],
      authMethod: json['data']['authMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }
}
