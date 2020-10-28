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

  UserViewState get state => _state;
  UserModel get user => _user;

  set state(UserViewState value) {
    _state = value;
    notifyListeners();
  }

  UserView() {
    getCurrentUser();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    _user = await _userRepo.getCurrentUser();
    print(_user.toString());
    return _user;
  }

  @override
  Future<UserModel> signInAnonymously() async {
    state = UserViewState.Busy;
    _user = await _userRepo.signInAnonymously();
    state = UserViewState.Idle;

    return _user;
  }

  @override
  Future<bool> signOut() async {
    state = UserViewState.Busy;
    _user = null;
    bool result = await _userRepo.signOut();
    state = UserViewState.Idle;

    return result;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    state = UserViewState.Busy;
    _user = await _userRepo.signInWithGoogle();
    state = UserViewState.Idle;

    return _user;
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    state = UserViewState.Busy;
    _user = await _userRepo.signInWithFacebook();
    state = UserViewState.Idle;

    return _user;
  }





}