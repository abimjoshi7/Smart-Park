// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'dart:convert';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
  UserModel({
    required this.msgType,
    required this.msg,
    required this.uid,
    required this.uname,
    required this.fn,
    required this.ln,
    required this.ph,
    required this.ad,
    required this.em,
    required this.sx,
    required this.flag,
    required this.sid,
    required this.pp,
  });

  final String msgType;
  final String msg;
  final int uid;
  final String uname;
  final String fn;
  final String ln;
  final String ph;
  final String ad;
  final String em;
  final String sx;
  final int flag;
  final int sid;
  final String pp;

  UserModel copyWith({
    String? msgType,
    String? msg,
    int? uid,
    String? uname,
    String? fn,
    String? ln,
    String? ph,
    String? ad,
    String? em,
    String? sx,
    int? flag,
    int? sid,
    String? pp,
  }) =>
      UserModel(
        msgType: msgType ?? this.msgType,
        msg: msg ?? this.msg,
        uid: uid ?? this.uid,
        uname: uname ?? this.uname,
        fn: fn ?? this.fn,
        ln: ln ?? this.ln,
        ph: ph ?? this.ph,
        ad: ad ?? this.ad,
        em: em ?? this.em,
        sx: sx ?? this.sx,
        flag: flag ?? this.flag,
        sid: sid ?? this.sid,
        pp: pp ?? this.pp,
      );

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        msgType: json["msgType"],
        msg: json["msg"],
        uid: json["uid"],
        uname: json["uname"],
        fn: json["fn"],
        ln: json["ln"],
        ph: json["ph"],
        ad: json["ad"],
        em: json["em"],
        sx: json["sx"],
        flag: json["flag"],
        sid: json["sid"],
        pp: json["pp"],
      );

  Map<String, dynamic> toMap() => {
        "msgType": msgType,
        "msg": msg,
        "uid": uid,
        "uname": uname,
        "fn": fn,
        "ln": ln,
        "ph": ph,
        "ad": ad,
        "em": em,
        "sx": sx,
        "flag": flag,
        "sid": sid,
        "pp": pp,
      };
}
