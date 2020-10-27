import 'package:flutter/cupertino.dart';

class UserModel {

  String userId;

  UserModel({@required this.userId});

  @override
  String toString() {
    return 'UserModel{userId: $userId}';
  }
}