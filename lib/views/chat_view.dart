import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/locator.dart';
import 'package:live_chat/models/group_model.dart';
import 'package:live_chat/models/message_model.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/repositories/chat_repository.dart';

enum SelectedChatState { Empty, Loading, Loaded }

class ChatView with ChangeNotifier {

  ChatRepository _chatRepo = locator<ChatRepository>();

  List<UserModel> _users;
  List<GroupModel> _groups = [];

  GroupModel _selectedChat;
  SelectedChatState _selectedChatState = SelectedChatState.Empty;

  File voiceFile;

  GroupModel get selectedChat => _selectedChat;
  SelectedChatState get selectedChatState => _selectedChatState;

  set selectedChatState(SelectedChatState value) {
    _selectedChatState = value;
    notifyListeners();
  }

  UserModel selectChatUser(String userId) {
    UserModel user = _users.where((user) => user.userId == userId).first;
    return user;
  }

  GroupModel selectChat(String groupId) {
    _selectedChat = _groups.where((group) => group.groupId == groupId).first;
    selectedChatState = SelectedChatState.Loaded;
    return _selectedChat;
  }

  findChatByUserIdList(List<String> userIdList) {
    if(_groups.length > 0) {
      GroupModel findGroup = _groups.map((group){
        if(listEquals(group.members, userIdList))
          return group;
        else
          return null;
      }).first;

      if(findGroup != null) {
        selectedChatState = SelectedChatState.Loaded;
        _selectedChat = findGroup;
      } else {
        selectedChatState = SelectedChatState.Empty;
        _selectedChat = null;
      }
    }

  }

  Future<List<UserModel>> getAllUsers() async {
    try{
      _users = await _chatRepo.getAllUsers();
      return _users;
    }catch(err) {
      print('getAllUsers Error: ${err.toString()}');
      return null;
    }
  }

  Stream<List<GroupModel>> getAllGroups(String userId) async* {

    try{
      _chatRepo.getAllGroups(userId).forEach((element) {
        _groups = element;
      });

      yield _groups;
    }catch(err) {

      print('getAllChats Error: ${err.toString()}');
      yield null;
    }

  }

  Stream<List<MessageModel>> getMessages(String groupId) {

    try{
      return _chatRepo.getMessages(groupId);
    }catch(err) {
      print('getMessages Error: ${err.toString()}');
      return null;
    }
  }

  Future<GroupModel> getGroupIdByUserIdList(String userId, String groupType, List<String> userIdList) async {
    try{
      selectedChatState = SelectedChatState.Loading;
      _selectedChat = await _chatRepo.getGroupIdByUserIdList(userId, groupType, userIdList);
      selectedChatState = SelectedChatState.Loaded;
      return _selectedChat;
    }catch(err) {
      selectedChatState = SelectedChatState.Empty;
      print('getGroupIdByUserIdList Error: ${err.toString()}');
      return null;
    }
  }

  Future<bool> saveMessage(MessageModel message, String groupId) async {
    try{
      return _chatRepo.saveMessage(message, groupId);
    }catch(err) {
      print('saveMessage Error: ${err.toString()}');
      return null;
    }
  }

  void recordStart() async {
    return _chatRepo.recordStart();
  }

  Future<File> recordStop() async {
    voiceFile = await _chatRepo.recordStop();
    return voiceFile;
  }

  Future<bool> clearStorage() async {
    return _chatRepo.clearStorage();
  }

  Future<String> uploadVoiceNote(String userId, String fileType, File file) async {
    return _chatRepo.uploadVoiceNote(userId, fileType, file);
  }


}