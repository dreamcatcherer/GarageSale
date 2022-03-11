class PersonInfoBean {
  int id;
  String first_name;
  String last_name;
  String email;
  String gender;
  String ip_address;
  String language;

  PersonInfoBean(
      {this.id,
      this.email,
      this.first_name,
      this.gender,
      this.ip_address,
      this.language,
      this.last_name});

  PersonInfoBean.fromJson(Map<String, dynamic> map) {
    if (map != null) {
      id = map['id'];
      first_name = map['first_name'];
      last_name = map['last_name'];
      email = map['email'];
      gender = map['gender'];
      ip_address = map['ip_address'];
      language = map['language'];
    }
  }

  @override
  PersonInfoBean fromJsonMap(Map<String, dynamic> map) {
    return PersonInfoBean.fromJson(map);
  }
}
