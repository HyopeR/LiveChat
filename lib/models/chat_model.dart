// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChatModel {
//
//   String speaker;
//
//   String interlocutor;
//   String interlocutorProfilePhotoUrl;
//   String interlocutorUserName;
//
//   String recentMessage;
//   String sentBy;
//
//   Timestamp createdAt;
//
//   ChatModel({
//     this.speaker,
//     this.interlocutor,
//     this.recentMessage,
//     this.sentBy,
//     this.createdAt,
//   });
//
//
//   Map<String, dynamic> toMap() {
//     return {
//       'speaker': speaker,
//       'interlocutor': interlocutor,
//       'recentMessage': recentMessage,
//       'sentBy': sentBy,
//       'createdAt': createdAt ?? FieldValue.serverTimestamp(),
//     };
//   }
//
//   ChatModel.fromMap(Map<String, dynamic> map) :
//         speaker = map['speaker'],
//         interlocutor = map['interlocutor'],
//         recentMessage = map['recentMessage'],
//         sentBy = map['sentBy'],
//         createdAt = map['createdAt'];
//
//   @override
//   String toString() {
//     return 'ChatModel{'
//         'speaker: $speaker, '
//         'interlocutor: $interlocutor, '
//         'interlocutorProfilePhotoUrl: $interlocutorProfilePhotoUrl, '
//         'interlocutorUserName: $interlocutorUserName, '
//         'recentMessage: $recentMessage, '
//         'sentBy: $sentBy, '
//         'createdAt: $createdAt, ';
//   }
// }