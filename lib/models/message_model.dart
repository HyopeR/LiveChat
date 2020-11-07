import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {

  String senderId;
  String receiverId;
  bool fromMe;
  String message;
  String messageType;
  int duration;
  Timestamp date;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.fromMe,
    this.message,
    this.messageType,
    this.duration,
    this.date
  });


  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'fromMe': fromMe,
      'message': message,
      'messageType': messageType,
      'duration': duration,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map) :
        senderId = map['senderId'],
        receiverId = map['receiverId'],
        fromMe = map['fromMe'],
        message = map['message'],
        messageType = map['messageType'],
        duration = map['duration'],
        date = map['date'];


  @override
  String toString() {
    return 'ChatModel{'
        'senderId: $senderId, '
        'receiverId: $receiverId, '
        'fromMe: $fromMe, '
        'message: $message, '
        'messageType: $messageType, '
        'duration: $duration, '
        'date: $date}';
  }
}