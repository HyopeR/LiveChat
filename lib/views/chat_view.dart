import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/locator.dart';
import 'package:live_chat/models/chat_model.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/repositories/chat_repository.dart';

enum UserViewState { Idle, Busy }

class ChatView with ChangeNotifier {

  UserViewState _state = UserViewState.Idle;
  ChatRepository _chatRepo = locator<ChatRepository>();

  List<ChatModel> _chats;

  List<ChatModel> get chats => _chats;
  UserViewState get state => _state;

  set state(UserViewState value) {
    _state = value;
    notifyListeners();
  }

  selectChatUser(String userId) {
    return _chatRepo.findUserFromList(userId);
  }

  Future<List<UserModel>> getAllUsers() async {
    try{
      return  _chatRepo.getAllUsers();
    }catch(err) {
      print('getAllUsers Error: ${err.toString()}');
      return null;
    }
  }

  Future<List<ChatModel>> getAllChats(String userId) async {

    try{
      return _chatRepo.getAllChats(userId);
    }catch(err) {

      print('getAllChats Error: ${err.toString()}');
      return null;
    }

  }


  Stream<List<MessageModel>> getMessages(String currentUserId, String chatUserId) {

    try{
      return _chatRepo.getMessages(currentUserId, chatUserId);
    }catch(err) {
      print('getMessages Error: ${err.toString()}');
      return null;
    }

  }

  Future<bool> saveMessage(MessageModel message) async {
    try{
      return _chatRepo.saveMessage(message);
    }catch(err) {
      print('saveMessage Error: ${err.toString()}');
      return null;
    }
  }


}