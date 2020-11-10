import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {

  String messageId;
  String sendBy;
  String message;
  String messageType;
  int duration;
  Timestamp date;

  String ownerImageUrl;
  bool fromMe;

  MessageModel({
    this.messageId,
    this.sendBy,
    this.message,
    this.messageType,
    this.duration,
    this.date
  });


  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'sendBy': sendBy,
      'message': message,
      'messageType': messageType,
      'duration': duration ?? null,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map) :
        messageId = map['messageId'],
        sendBy = map['sendBy'],
        message = map['message'],
        messageType = map['messageType'],
        duration = map['duration'],
        date = map['date'],
        ownerImageUrl = map['ownerImageUrl'],
        fromMe = map['fromMe'];


  @override
  String toString() {
    return 'MessageModel{'
        'messageId: $messageId, '
        'sendBy: $sendBy, '
        'message: $message, '
        'messageType: $messageType, '
        'duration: $duration, '
        'date: $date}, '
        'ownerImageUrl: $ownerImageUrl}, '
        'fromMe: $fromMe'
    ;
  }
}