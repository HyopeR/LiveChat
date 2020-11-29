import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat/models/message_model.dart';
/*
  Bu model private ve plural olmak üzere 2 tip group'a veri sağlayacaktır.
*/

class GroupModel {

  String groupId;
  String groupName;
  String groupStatement;
  String groupType;
  String groupImageUrl;

  List<dynamic> members;

  MessageModel recentMessage;
  Map<String, dynamic> actions;
  int totalMessage;

  String createdBy;
  Timestamp createdAt;
  Timestamp updatedAt;

  GroupModel.private({
    this.groupId,
    this.groupType,
    this.members,
    this.recentMessage,
    this.actions,
    this.totalMessage,
    this.createdBy,
    this.createdAt,
    this.updatedAt
  });

  GroupModel.plural({
    this.groupId,
    this.groupName,
    this.groupStatement,
    this.groupType,
    this.groupImageUrl,
    this.members,
    this.recentMessage,
    this.actions,
    this.totalMessage,
    this.createdBy,
    this.createdAt,
    this.updatedAt
  });

  Map<String, dynamic> toMapPlural() {

    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupStatement': groupStatement,
      'groupType': groupType,
      'groupImageUrl': groupImageUrl ?? 'https://img.webme.com/pic/c/creative-blog/users_black.png',

      'members': members ?? [],

      'recentMessage': recentMessage == null ? null : recentMessage.toMap(),
      'actions': actions ?? Map<String, Map<String, dynamic>>(),
      'totalMessage': totalMessage ?? 0,

      'createdBy': createdBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  GroupModel.fromMapPlural(Map<String, dynamic> map) :
        groupId = map['groupId'],
        groupName = map['groupName'],
        groupStatement = map['groupStatement'],
        groupType = map['groupType'],
        groupImageUrl = map['groupImageUrl'],
        members = map['members'],
        recentMessage = map['recentMessage'] == null ? null : MessageModel.fromMap(map['recentMessage']),
        totalMessage = map['totalMessage'],
        actions = map['actions'],
        createdBy = map['createdBy'],
        createdAt = map['createdAt'],
        updatedAt = map['updatedAt'];


  Map<String, dynamic> toMapPrivate() {

    return {
      'groupId': groupId,
      'groupType': groupType,

      'members': members ?? [],

      'recentMessage': recentMessage == null ? null : recentMessage.toMap(),
      'actions': actions ?? Map<String, Map<String, dynamic>>(),
      'totalMessage': totalMessage ?? 0,

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
        actions = map['actions'],
        totalMessage = map['totalMessage'],
        createdBy = map['createdBy'],
        createdAt = map['createdAt'],
        updatedAt = map['updatedAt'];


  @override
  String toString() {
    return 'GroupModel{'
        'groupId: $groupId, '
        'groupName: $groupName, '
        'groupStatement: $groupStatement, '
        'groupType: $groupType, '
        'groupImageUrl: $groupImageUrl, '
        'members: $members, '
        'recentMessage: ${recentMessage != null ? recentMessage.toString() : null}, '
        'actions: $actions, '
        'totalMessage: $totalMessage, '
        'createdBy: $createdBy, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt}';
  }
}