import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {

  String senderId;
  String receiverId;
  bool fromMe;
  String message;
  Timestamp date;

  ChatModel({
    this.senderId,
    this.receiverId,
    this.fromMe,
    this.message,
    this.date
  });


  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'fromMe': fromMe,
      'message': message,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map) :
        senderId = map['senderId'],
        receiverId = map['receiverId'],
        fromMe = map['fromMe'],
        message = map['message'],
        date = map['date'];


  @override
  String toString() {
    return 'ChatModel{'
        'senderId: $senderId, '
        'receiverId: $receiverId, '
        'fromMe: $fromMe, '
        'message: $message, '
        'date: $date}';
  }
}