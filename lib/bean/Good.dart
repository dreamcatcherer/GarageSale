import 'dart:convert' as dartConvert;

class Good {
  String name;
  String amt;
  String img;
  String desc;

  Good({this.name, this.amt, this.img, this.desc});

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'amt': amt,
        'img': img,
        'desc': desc,
      };

  Good.fromJson(Map<String, dynamic> map) {
    if (map != null) {
      name = map['name'];
      amt = map['amt'];
      img = map['img'];
      desc = map['desc'];
    }
  }

  @override
  Good fromJsonMap(Map<String, dynamic> map) {
    return Good.fromJson(map);
  }
}
