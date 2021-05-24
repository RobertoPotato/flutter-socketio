class MessageModel {
  final String sender;
  final String receiver;
  final int date;
  final String content;

  MessageModel({
    this.receiver,
    this.sender,
    this.date,
    this.content,
  });

  MessageModel.fromJson(
    Map<String, dynamic> json,
  )   : sender = json["sender"],
        date = json["date"],
        content = json["content"],
        receiver = json["receiver"];

  Map<String, dynamic> toJson() {
    return {
      "sender": sender,
      "receiver": receiver,
      "date": date,
      "content": content
    };
  }
}
