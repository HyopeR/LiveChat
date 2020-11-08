import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {

  String sendBy;
  String message;
  String messageType;
  int duration;
  Timestamp date;

  bool fromMe;

  MessageModel({
    this.sendBy,
    this.message,
    this.messageType,
    this.duration,
    this.date
  });


  Map<String, dynamic> toMap() {
    return {
      'sendBy': sendBy,
      'message': message,
      'messageType': messageType,
      'duration': duration ?? null,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map) :
        sendBy = map['sendBy'],
        fromMe = map['fromMe'],
        message = map['message'],
        messageType = map['messageType'],
        duration = map['duration'],
        date = map['date'];


  @override
  String toString() {
    return 'MessageModel{'
        'sendBy: $sendBy, '
        'fromMe: $fromMe, '
        'message: $message, '
        'messageType: $messageType, '
        'duration: $duration, '
        'date: $date}';
  }
}