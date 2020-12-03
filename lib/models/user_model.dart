import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
var r = Random();

class UserModel {

  String userId;
  String userName;
  String userEmail;
  String userProfilePhotoUrl;
  String userWallpaper;
  String userStatement;

  // List<dynamic> contacts;
  List<dynamic> groups;

  Timestamp lastSeen;
  bool online;

  Timestamp createdAt;
  Timestamp updatedAt;

  UserModel({@required this.userId, @required this.userEmail});

  Map<String, dynamic> toMap() {

    return {
      'userId': userId,
      'userName': userName ?? 'User ' +  String.fromCharCodes(List.generate(10, (index) => r.nextInt(33) + 89)),
      'userEmail': userEmail,
      'userProfilePhotoUrl': userProfilePhotoUrl ?? 'https://img.webme.com/pic/c/creative-blog/user_black.png',
      'userWallpaper': userWallpaper ?? '',
      'userStatement': userStatement ?? 'Müsait',

      // 'contacts': contacts ?? [],
      'groups': groups ?? [],

      'lastSeen': lastSeen ?? FieldValue.serverTimestamp(),
      'online': online ?? true,

      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  UserModel.fromMap(Map<String, dynamic> map) :
      userId = map['userId'],
      userName = map['userName'],
      userEmail = map['userEmail'],
      userProfilePhotoUrl = map['userProfilePhotoUrl'],
      userWallpaper = map['userWallpaper'],
      userStatement = map['userStatement'],
      // contacts = map['contacts'],
      groups = map['groups'],
      lastSeen = map['lastSeen'],
      online = map['online'],
      createdAt = map['createdAt'],
      updatedAt = map['updatedAt'];

  @override
  String toString() {
    return 'UserModel{'
        'userId: $userId, '
        'userName: $userName, '
        'userEmail: $userEmail, '
        'userProfilePhotoUrl: $userProfilePhotoUrl, '
        'userWallpaper: $userWallpaper, '
        'userStatement: $userStatement, '
        // 'contacts: $contacts, '
        'groups: $groups, '
        'lastSeen: $lastSeen, '
        'online: $online, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        '}';
  }
}