// To parse this JSON data, do
//
//     final checkerRequest = checkerRequestFromMap(jsonString);

import 'dart:convert';

CheckerRequest checkerRequestFromMap(String str) =>
    CheckerRequest.fromMap(json.decode(str));

String checkerRequestToMap(CheckerRequest data) => json.encode(data.toMap());

class CheckerRequest {
  CheckerRequest({
    required this.tn,
    required this.uid,
    required this.refN,
    required this.depo,
    required this.fine,
    required this.gtot,
    required this.sids,
    required this.sid,
    required this.tid,
    required this.stkrs,
  });

  final String tn;
  final int uid;
  final String refN;
  final int depo;
  final int fine;
  final int gtot;
  final String sids;
  final String sid;
  final int tid;
  final List<Stkr> stkrs;

  CheckerRequest copyWith({
    String? tn,
    int? uid,
    String? refN,
    int? depo,
    int? fine,
    int? gtot,
    String? sids,
    String? sid,
    int? tid,
    List<Stkr>? stkrs,
  }) =>
      CheckerRequest(
        tn: tn ?? this.tn,
        uid: uid ?? this.uid,
        refN: refN ?? this.refN,
        depo: depo ?? this.depo,
        fine: fine ?? this.fine,
        gtot: gtot ?? this.gtot,
        sids: sids ?? this.sids,
        sid: sid ?? this.sid,
        tid: tid ?? this.tid,
        stkrs: stkrs ?? this.stkrs,
      );

  factory CheckerRequest.fromMap(Map<String, dynamic> json) => CheckerRequest(
        tn: json["tn"],
        uid: json["uid"],
        refN: json["ref_n"],
        depo: json["depo"],
        fine: json["fine"],
        gtot: json["gtot"],
        sids: json["sids"],
        sid: json["sid"],
        tid: json["tid"],
        stkrs: List<Stkr>.from(json["stkrs"].map((x) => Stkr.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "tn": tn,
        "uid": uid,
        "ref_n": refN,
        "depo": depo,
        "fine": fine,
        "gtot": gtot,
        "sids": sids,
        "sid": sid,
        "tid": tid,
        "stkrs": List<dynamic>.from(stkrs.map((x) => x.toMap())),
      };
}

class Stkr {
  Stkr({
    required this.sid,
    required this.flag,
  });

  final String sid;
  final String flag;

  Stkr copyWith({
    String? sid,
    String? flag,
  }) =>
      Stkr(
        sid: sid ?? this.sid,
        flag: flag ?? this.flag,
      );

  factory Stkr.fromMap(Map<String, dynamic> json) => Stkr(
        sid: json["sid"],
        flag: json["flag"],
      );

  Map<String, dynamic> toMap() => {
        "sid": sid,
        "flag": flag,
      };
}
