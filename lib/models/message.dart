// class Message {
//   Message({
//     required this.msg,
//     required this.toId,
//     required this.read,
//     required this.type,
//     required this.fromId,
//     required this.sent,
//   });
//   late final String msg;
//   late final String toId;
//   late final String read;
//   late final String fromId;
//   late final String sent;
//   late final  Type type;

//   Message.fromJson(Map<String, dynamic> json) {
//     msg = json['msg'].toString();
//     toId = json['toId'].toString();
//     read = json['read'].toString();
//     type = json['type'].toString() == Type.image.name? Type.image:Type.text;
//     fromId = json['fromId'].toString();
//     sent = json['sent'].toString();
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['msg'] = msg;
//     data['toId'] = toId;
//     data['read'] = read;
//     data['type'] = type.name;
//     data['fromId'] = fromId;
//     data['sent'] = sent;
//     return data;
//   }
// }
// enum Type{text,image}

class Message {
  Message({
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
  });

  late final String msg;
  late final String toId;
  late final String read;
  late final String fromId;
  late final String sent;
  late final Type type;

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    toId = json['toId'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['toId'] = toId;
    data['read'] = read;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sent'] = sent;
    return data;
  }

  static Message typingMessage(String fromId, String toId) {
    return Message(
      msg: 'typing...',
      toId: toId,
      read: 'false',
      type: Type.text,
      fromId: fromId,
      sent: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }
}

enum Type { text, image }
