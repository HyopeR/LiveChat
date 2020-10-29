import 'package:flutter/cupertino.dart';

class UserModel {

  String userId;

  UserModel({@required this.userId});

  Map<String, dynamic> toMap() {

    return {
      'userId': userId
    };
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId}';
  }
}