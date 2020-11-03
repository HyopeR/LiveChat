import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {

  String senderId;
  String receiverId;
  bool fromWho;
  String message;
  DateTime date;

  ChatModel({
    this.senderId,
    this.receiverId,
    this.fromWho,
    this.message,
    this.date
  });


  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'fromWho': fromWho,
      'message': message,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map) :
        senderId = map['senderId'],
        receiverId = map['receiverId'],
        fromWho = map['fromWho'],
        message = map['message'],
        date = (map['date'] as Timestamp).toDate();


  @override
  String toString() {
    return 'ChatModel{'
        'senderId: $senderId, '
        'receiverId: $receiverId, '
        'fromWho: $fromWho, '
        'message: $message, '
        'date: $date}';
  }
}