import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
var r = Random();

class UserModel {

  String userId;
  String userName;
  String userEmail;
  String userProfilePhotoUrl;
  int userLevel;

  DateTime createdAt;
  DateTime updatedAt;

  UserModel({@required this.userId, @required this.userEmail, });

  Map<String, dynamic> toMap() {
    print(FieldValue.serverTimestamp());

    return {
      'userId': userId,
      'userName': userName ?? 'User ' +  String.fromCharCodes(List.generate(10, (index) => r.nextInt(33) + 89)),
      'userEmail': userEmail,
      'userProfilePhotoUrl': userProfilePhotoUrl ?? 'https://img.webme.com/pic/c/creative-blog/user_black.png',
      'userLevel': userLevel ?? 1,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  UserModel.fromMap(Map<String, dynamic> map) :
      userId = map['userId'],
      userName = map['userName'],
      userEmail = map['userEmail'],
      userProfilePhotoUrl = map['userProfilePhotoUrl'],
      userLevel = map['userLevel'],
      createdAt = (map['createdAt'] as Timestamp).toDate(),
      updatedAt = (map['updatedAt'] as Timestamp).toDate();

  @override
  String toString() {
    return 'UserModel{'
        'userId: $userId, '
        'userName: $userName, '
        'userEmail: $userEmail, '
        'userProfilePhotoUrl: $userProfilePhotoUrl, '
        'userLevel: $userLevel, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        '}';
  }
}