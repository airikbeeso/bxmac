import 'dart:ffi';

class Qitem {
  String mode;
  Int ih;
  Int im;
  Int isec;
  Int init;
  Int end;
  Int date;
  Int timestamp;
  String status;
  String question;
  dynamic listQuestions;
  String userId;
  String genId;
  String email;
  String name;
  Int answerOn;

  Qitem(
      {required this.mode,
      required this.ih,
      required this.im,
      required this.isec,
      required this.init,
      required this.end,
      required this.date,
      required this.timestamp,
      required this.status,
      required this.question,
      required this.listQuestions,
      required this.userId,
      required this.genId,
      required this.email,
      required this.name,
      required this.answerOn});

  toJSONEncodable() {
    Map<String, dynamic> m = {};

    m['mode'] = mode;
    m['ih'] = ih;
    m['im'] = im;
    m['isec'] = isec;
    m['init'] = init;
    m['end'] = end;
    m['date'] = date;
    m['timestamp'] = timestamp;
    m['status'] = status;
    m['question'] = question;
    m['listQuestions'] = listQuestions;
    m['userId'] = userId;
    m['genId'] = genId;
    m['email'] = email;
    m['name'] = name;
    m['answerOn'] = answerOn;
    return m;
  }
}

class QitemList {
  List<Qitem> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
