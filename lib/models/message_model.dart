class MessageModel {
  final String sender;
  final int date;
  final String content;

  MessageModel({
    this.sender,
    this.date,
    this.content,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : sender = json["sender"],
        date = json["date"],
        content = json["content"];

  Map<String, dynamic> toJson() {
    return {"sender": sender, "date": date, "content": content};
  }
}
