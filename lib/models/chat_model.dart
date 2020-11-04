import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {

  String speaker;

  String interlocutor;
  String interlocutorProfilePhotoUrl;
  String interlocutorUserName;
  String interlocutorEmail;

  String lastMessage;
  bool seenNotification;
  Timestamp createdAt;
  Timestamp seenAt;

  ChatModel({
    this.speaker,
    this.interlocutor,
    this.lastMessage,
    this.seenNotification,
    this.createdAt,
    this.seenAt
  });


  Map<String, dynamic> toMap() {
    return {
      'speaker': speaker,
      'interlocutor': interlocutor,
      'lastMessage': lastMessage,
      'seenNotification': seenNotification,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'seenAt': seenAt ?? FieldValue.serverTimestamp(),
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map) :
        speaker = map['speaker'],
        interlocutor = map['interlocutor'],
        lastMessage = map['lastMessage'],
        seenNotification = map['seenNotification'],
        createdAt = map['createdAt'],
        seenAt = map['seenAt'];

  @override
  String toString() {
    return 'ChatModel{'
        'speaker: $speaker, '
        'interlocutor: $interlocutor, '
        'interlocutorProfilePhotoUrl: $interlocutorProfilePhotoUrl, '
        'interlocutorUserName: $interlocutorUserName, '
        'interlocutorEmail: $interlocutorEmail, '
        'lastMessage: $lastMessage, '
        'seenNotification: $seenNotification, '
        'createdAt: $createdAt, '
        'seenAt: $seenAt}';
  }
}