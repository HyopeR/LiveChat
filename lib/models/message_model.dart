import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {

  String messageId;
  String sendBy;
  String message;
  String messageType;
  Timestamp date;

  int duration;
  MessageModel markedMessage;
  String attach;

  String ownerUsername;
  String ownerImageUrl;
  bool fromMe;

  MessageModel({
    this.messageId,
    this.sendBy,
    this.message,
    this.messageType,
    this.date
  });


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'messageId': messageId,
      'sendBy': sendBy,
      'message': message,
      'messageType': messageType,
      'date': date ?? FieldValue.serverTimestamp(),
    };

    if(duration != null) {
      map['duration'] = duration;
    }

    if(attach != null) {
      map['attach'] = attach;
    }

    if(markedMessage != null) {
      Map<String, dynamic> mapMarkedMessage = markedMessage.toMap();
      mapMarkedMessage.remove('markedMessage');
      map['markedMessage'] = mapMarkedMessage;
    }

    return map;
  }

  MessageModel.fromMap(Map<String, dynamic> map) :
        messageId = map['messageId'],
        sendBy = map['sendBy'],
        message = map['message'],
        messageType = map['messageType'],
        duration = map['duration'],
        date = map['date'],
        markedMessage = map['markedMessage'] == null ? null : MessageModel.fromMap(map['markedMessage']),
        attach = map['attach'],
        ownerUsername = map['ownerUsername'],
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
        'date: $date, '
        'markedMessage: ${markedMessage != null ? markedMessage.toString() : null}, '
        'attach: $attach, '
        'ownerUsername: $ownerUsername, '
        'ownerImageUrl: $ownerImageUrl, '
        'fromMe: $fromMe }';
  }
}