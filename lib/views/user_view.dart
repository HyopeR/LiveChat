import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/locator.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/repositories/user_repository.dart';
import 'package:live_chat/services/auth_base.dart';

enum UserViewState { Idle, Busy }

class UserView with ChangeNotifier implements AuthBase {

  UserViewState _state = UserViewState.Idle;
  UserRepository _userRepo = locator<UserRepository>();
  UserModel _user;

  String emailErrorMessage;
  String passwordErrorMessage;
  String userErrorMessage;

  UserViewState get state => _state;
  UserModel get user => _user;

  set state(UserViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try{
      state = UserViewState.Busy;
      _user = await _userRepo.getCurrentUser();
      return _user;
    }catch(err) {

      print('getCurrentUser Error: ${err.toString()}');
      return null;

    } finally {
      state = UserViewState.Idle;
    }
  }

  Stream<UserModel> streamCurrentUser(String userId) {
    try{
      _userRepo.streamCurrentUser(userId).listen((user) {
        _user = user;
      });

      return _userRepo.streamCurrentUser(userId);
    }catch(err) {

      print('getCurrentUser Error: ${err.toString()}');
      return null;

    }
  }

  @override
  Future<UserModel> signInAnonymously() async {

    try{
      state = UserViewState.Busy;
      _user = await _userRepo.signInAnonymously();
      return _user;
    }catch(err) {

      print('signInAnonymously Error: ${err.toString()}');
      return null;

    } finally {
      state = UserViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {

    try{
      state = UserViewState.Busy;
      _user = null;
      bool result = await _userRepo.signOut();
      return result;

    }catch(err) {

      print('signOut Error: ${err.toString()}');
      return null;

    } finally {
      state = UserViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {

    try{
      state = UserViewState.Busy;
      _user = await _userRepo.signInWithGoogle();
      return _user;

    }catch(err) {

      print('signInWithGoogle Error: ${err.toString()}');
      return null;

    } finally {
      state = UserViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInWithFacebook() async {

    try{
      state = UserViewState.Busy;
      _user = await _userRepo.signInWithFacebook();
      return _user;

    }catch(err) {

      print('signInWithFacebook Error: ${err.toString()}');
      return null;

    } finally {
      state = UserViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    if(_checkEmailAndPassword(email, password)) {
      userErrorMessage = null;

      try{
        _user = await _userRepo.signInWithEmailAndPassword(email, password);
        return _user;
      }catch(err) {

        print('signInWithEmailAndPassword Error: ${err.toString()}');
        userErrorMessage = 'Bu kullanıcı bulunamadı. Bilgilerinizi kontrol edin.';
        return null;
      }finally{
        state = UserViewState.Idle;
      }


    } else {
      return null;
    }
  }

  @override
  Future<UserModel> createUserEmailAndPassword(String email, String password) async {

    if(_checkEmailAndPassword(email, password)) {
      userErrorMessage = null;
      try{

        bool result = await _userRepo.controllerUser(email);
        if(result) {
          _user = await _userRepo.createUserEmailAndPassword(email, password);
        } else {
          userErrorMessage = 'Bu email adresi zaten kayıtlı. Giriş yapın.';
        }

        return _user;
      }catch(err) {
        print('createUserEmailAndPassword Error: ${err.toString()}');
        return null;

      } finally {
        state = UserViewState.Idle;
      }

    } else {
      return null;
    }
  }


  bool _checkEmailAndPassword(String email, String password) {
    bool result = true;
    
    if(!email.contains('@')) {
      emailErrorMessage = 'Geçersiz email adresi.';
      result = false;
    }else
      emailErrorMessage = null;


    if(password.length < 6){
      passwordErrorMessage = 'Şifre en az 6 karakter olmalıdır.';
      result = false;
    }else
      passwordErrorMessage = null;

    return result;
  }

  Future<bool> updateUserName(String userId, String newUserName) async {

    try{

      bool result = await _userRepo.updateUserName(userId, newUserName);

      // if(result) {
      //   _user.userName = newUserName;
      //   _user.updatedAt = DateTime.now();
      // }

      return result;

    }catch(err) {

      print('updateUserName Error: ${err.toString()}');
      return null;
    }

  }

  Future<String> uploadProfilePhoto(String userId, String fileType, File file) async {

    try{
      String fileUrl = await _userRepo.uploadProfilePhoto(userId, fileType, file);

      // if(fileUrl != null) {
      //   _user.userProfilePhotoUrl = fileUrl;
      //   _user.updatedAt = DateTime.now();
      // }

      return fileUrl;

    }catch(err) {

      print('uploadFile Error: ${err.toString()}');
      return null;
    }

  }

}