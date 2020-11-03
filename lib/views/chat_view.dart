import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/locator.dart';
import 'package:live_chat/models/chat_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/repositories/chat_repository.dart';

enum UserViewState { Idle, Busy }

class ChatView with ChangeNotifier {

  UserViewState _state = UserViewState.Idle;
  ChatRepository _chatRepo = locator<ChatRepository>();

  UserViewState get state => _state;

  set state(UserViewState value) {
    _state = value;
    notifyListeners();
  }

  Stream<List<ChatModel>> getMessages(String currentUserId, String chatUserId) {

    try{
      return _chatRepo.getMessages(currentUserId, chatUserId);
    }catch(err) {
      print('getMessages Error: ${err.toString()}');
      return null;
    }

  }

  Future<bool> saveMessage(ChatModel message) async {
    try{
      return _chatRepo.saveMessage(message);
    }catch(err) {
      print('saveMessage Error: ${err.toString()}');
      return null;
    }
  }

}