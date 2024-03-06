class ChatModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatModel({this.chatroomid, this.participants, this.lastMessage});

  ChatModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroomid": chatroomid,
      "participants": participants,
      "lastmessage": lastMessage
    };
  }
}
