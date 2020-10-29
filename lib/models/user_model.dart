import 'package:flutter/cupertino.dart';

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

    return {
      'userId': userId,
      'userName': userName ?? '',
      'userEmail': userEmail,
      'userProfilePhotoUrl': userProfilePhotoUrl ?? 'https://img.webme.com/pic/c/creative-blog/user_black.png',
      'userLevel': userLevel ?? 1,
      'createdAt': createdAt ?? '',
      'updatedAt': updatedAt ?? '',
    };
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId}';
  }
}