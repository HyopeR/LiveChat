import 'dart:async';
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

  List<UserModel> users;
  UserModel interlocutorUser;

  List<GroupModel> _groups;
  String groupType;

  GroupModel selectedChat;
  SelectedChatState _selectedChatState = SelectedChatState.Empty;

  List<MessageModel> _messages;

  File voiceFile;

  List<GroupModel> get groups => _groups;
  List<MessageModel> get messages => _messages;
  SelectedChatState get selectedChatState => _selectedChatState;

  set selectedChatState(SelectedChatState value) {
    _selectedChatState = value;
    notifyListeners();
  }

  Future<bool> clearState() async {
    users = List<UserModel>();
    _groups = List<GroupModel>();
    _messages = List<MessageModel>();
    groupType = null;
    selectedChat = null;
    interlocutorUser = null;
    selectedChatState = SelectedChatState.Empty;
    return true;
  }



  UserModel selectChatUser(String userId) {
    UserModel user = users.where((user) => user.userId == userId).first;
    return user;
  }

  void resetMessages() {
    _messages = List<MessageModel>();
  }

  void unSelectChat() {
    selectedChat = null;
  }

  GroupModel selectChat(String groupId) {
    selectedChat = _groups.where((group) => group.groupId == groupId).first;
    selectedChatState = SelectedChatState.Loaded;
    return selectedChat;
  }

  findChatByUserIdList(List<String> userIdList) {
    if(_groups.length > 0) {
      GroupModel findGroup;
      findGroup = _groups.map((group) => group).firstWhere((element) => element.createdBy == userIdList[0]
          ? listEquals(element.members, userIdList)
          : listEquals(element.members, userIdList.reversed.toList()),

          orElse: () => null,
      );

      if(findGroup != null) {
        selectedChatState = SelectedChatState.Loaded;
        selectedChat = findGroup;
      } else {
        selectedChatState = SelectedChatState.Empty;
        selectedChat = null;
      }

    }
  }

  // Future<List<UserModel>> searchUsers(String userName) async {
  //   try{
  //     return _chatRepo.searchUsers(userName);
  //   } catch(err) {
  //     print('searchUsers Error: ${err.toString()}');
  //     return null;
  //   }
  // }
  //
  // Stream<List<UserModel>> getAllContacts(List<dynamic> contactsIdList) {
  //   try{
  //     _chatRepo.getAllContacts(contactsIdList).listen((contactsData) {
  //       contacts = contactsData;
  //     });
  //
  //     return _chatRepo.getAllContacts(contactsIdList);
  //   }catch(err) {
  //     print('getAllContacts Error: ${err.toString()}');
  //     return null;
  //   }
  // }

  Stream<List<UserModel>> getAllUsers() {
    try{
      _chatRepo.getAllUsers().listen((usersData) {
        users = usersData;
      });

      return _chatRepo.getAllUsers();
    }catch(err) {
      print('getAllUsers Error: ${err.toString()}');
      return null;
    }
  }

  Stream<List<GroupModel>> getAllGroups(String userId) {
    try{
      _chatRepo.getAllGroups(userId).listen((groupData) {
        // Eğer bir chat sayfasında değilsek selectedChat boş oluyor. Dolayısıyla eğerki biz bir chat sayfasındaysak
        // ve o group içerisinde yeni bir mesaj atılmış ise bunu buradan dinleyerek gördüğümüz mesajı database'e görüldü
        // olarak anlatmak amacıyla kendi gördüğümüz mesaj sayısını arttırıyoruz.
        if(selectedChat != null && groupData.isNotEmpty) {
          GroupModel activeGroup = groupData.firstWhere((group) => group.groupId == selectedChat.groupId, orElse: () => null);

          if(activeGroup != null)
            if(activeGroup.totalMessage != activeGroup.actions[userId]['seenMessage']) {
              _chatRepo.messagesMarkAsSeen(userId, activeGroup.groupId, activeGroup.totalMessage);
            }
        }

        _groups = groupData;
      });
      return _chatRepo.getAllGroups(userId);
    }catch(err) {
      print('getAllChats Error: ${err.toString()}');
      return null;
    }
  }

  Stream<List<MessageModel>> getMessages(String groupId) {

    try{
      _chatRepo.getMessages(groupId).listen((messagesData) {
        _messages = messagesData;
      });

      return _chatRepo.getMessages(groupId);
    }catch(err) {
      print('getMessages Error: ${err.toString()}');
      return null;
    }
  }

  Future<GroupModel> getGroupIdByUserIdList(String userId, String groupType, List<String> userIdList) async {
    try{
      selectedChatState = SelectedChatState.Loading;
      selectedChat = await _chatRepo.getGroupIdByUserIdList(userId, groupType, userIdList);
      selectedChatState = SelectedChatState.Loaded;
      return selectedChat;
    }catch(err) {
      selectedChatState = SelectedChatState.Empty;
      print('getGroupIdByUserIdList Error: ${err.toString()}');
      return null;
    }
  }

  Future<bool> saveMessage(MessageModel message, UserModel messageOwner, String groupId) async {
    try{
      return _chatRepo.saveMessage(message, messageOwner, groupId);
    }catch(err) {
      print('saveMessage Error: ${err.toString()}');
      return null;
    }
  }

  Future<void> updateMessageAction(int actionCode, String userId, String groupId) async {
    try{
      return _chatRepo.updateMessageAction(actionCode, userId, groupId);
    }catch(err) {
      print('updateMessageAction Error: ${err.toString()}');
    }
  }

  Future<String> uploadVoiceNote(String groupId, String fileType, File file) async {
    try{
      return _chatRepo.uploadVoiceNote(groupId, fileType, file);
    }catch(err) {
      print('uploadVoiceNote Error: ${err.toString()}');
      return null;
    }
  }

  Future<Map<String, String>> uploadImage(String groupId, String fileType, File file) async {
    try{
      return _chatRepo.uploadImage(groupId, fileType, file);
    }catch(err) {
      print('uploadImage Error: ${err.toString()}');
      return null;
    }
  }

  Future<String> uploadGroupPhoto(String groupId, String fileType, File file) async {
    try{
      return _chatRepo.uploadGroupPhoto(groupId, fileType, file);
    }catch(err) {
      print('uploadGroupPhoto Error: ${err.toString()}');
      return null;
    }
  }

  Stream<GroupModel> streamOneGroup(String groupId) {
    try{
      return _chatRepo.streamOneGroup(groupId);
    }catch(err) {
      print('streamOneGroup Error: ${err.toString()}');
      return null;
    }
  }

  Stream<UserModel> streamOneUser(String userId) {
    try{
      return _chatRepo.streamOneUser(userId);
    }catch(err) {
      print('streamOneUser Error: ${err.toString()}');
      return null;
    }
  }

  Future<String> createGroupId() async {
    try{
      return _chatRepo.createGroupId();
    }catch(err) {
      print('createGroup Error: ${err.toString()}');
      return null;
    }
  }


  Future<GroupModel> createGroup(UserModel user, GroupModel group) async {
    try{
      return _chatRepo.createGroup(user, group);
    }catch(err) {
      print('createGroup Error: ${err.toString()}');
      return null;
    }
  }

  // Voice record ile ilgili fonksiyonlar.
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


}