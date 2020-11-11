import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat/models/message_model.dart';
/*
  Bu model private ve plural olmak üzere 2 tip group'a veri sağlayacaktır.
*/

class GroupModel {

  String groupId;
  String groupName;
  String groupType;
  String groupImageUrl;

  List<dynamic> members;

  MessageModel recentMessage;

  String createdBy;
  Timestamp createdAt;
  Timestamp updatedAt;

  GroupModel.private({
    this.groupId,
    this.groupType,
    this.members,
    this.recentMessage,
    this.createdBy,
    this.createdAt,
    this.updatedAt
  });

  GroupModel.plural({
    this.groupId,
    this.groupName,
    this.groupType,
    this.groupImageUrl,
    this.members,
    this.recentMessage,
    this.createdBy,
    this.createdAt,
    this.updatedAt
  });

  Map<String, dynamic> toMapPlural() {

    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupType': groupType,
      'groupImageUrl': groupImageUrl ?? 'https://img.webme.com/pic/c/creative-blog/users_black.png',

      'members': members ?? [],

      'recentMessage': recentMessage == null ? null : recentMessage.toMap(),

      'createdBy': createdBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  GroupModel.fromMapPlural(Map<String, dynamic> map) :
        groupId = map['groupId'],
        groupName = map['groupName'],
        groupType = map['groupType'],
        groupImageUrl = map['groupImageUrl'],
        members = map['members'],
        recentMessage = map['recentMessage'] == null ? null : MessageModel.fromMap(map['recentMessage']),
        createdBy = map['createdBy'],
        createdAt = map['createdAt'],
        updatedAt = map['updatedAt'];


  Map<String, dynamic> toMapPrivate() {

    return {
      'groupId': groupId,
      'groupType': groupType,

      'members': members ?? [],

      'recentMessage': recentMessage == null ? null : recentMessage.toMap(),

      'createdBy': createdBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  GroupModel.fromMapPrivate(Map<String, dynamic> map) :
        groupId = map['groupId'],
        groupType = map['groupType'],
        members = map['members'],
        recentMessage = map['recentMessage'] == null ? null : MessageModel.fromMap(map['recentMessage']),
        createdBy = map['createdBy'],
        createdAt = map['createdAt'],
        updatedAt = map['updatedAt'];


  @override
  String toString() {
    return 'GroupModel{'
        'groupId: $groupId, '
        'groupName: $groupName, '
        'groupType: $groupType, '
        'groupImageUrl: $groupImageUrl, '
        'members: $members, '
        'recentMessage: ${recentMessage.toString()}, '
        'createdBy: $createdBy, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt}';
  }
}