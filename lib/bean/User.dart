import 'dart:convert' as dartConvert;

class User {
  String account;
  String password;

  User({this.account, this.password});

  @override
  Map<String, dynamic> toJson() => {
        'account': account,
        'password': password,
      };

  User.fromJson(Map<String, dynamic> map) {
    if (map != null) {
      account = map['account'];
      password = map['password'];
    }
  }

  @override
  User fromJsonMap(Map<String, dynamic> map) {
    return User.fromJson(map);
  }
}
