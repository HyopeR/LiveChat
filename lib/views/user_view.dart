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

  UserView() {
    getCurrentUser();
  }

  @override
  Future<UserModel> getCurrentUser() async {
    state = UserViewState.Busy;
    _user = await _userRepo.getCurrentUser();
    state = UserViewState.Idle;
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

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    if(_checkEmailAndPassword(email, password)) {
      userErrorMessage = null;

      try{
        _user = await _userRepo.signInWithEmailAndPassword(email, password);
        return _user;
      }catch(err) {
        state = UserViewState.Busy;
        userErrorMessage = 'Bu email adresi bulunamadı. Kayıt olun.';
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
      UserModel result = await _userRepo.controllerUser(email, password);

      if(result != null) {
        state = UserViewState.Busy;
        userErrorMessage = 'Bu email adresi zaten kayıtlı. Giriş yapın.';
        state = UserViewState.Idle;
        return null;
      }else {
        state = UserViewState.Busy;
        _user = await _userRepo.createUserEmailAndPassword(email, password);
        state = UserViewState.Idle;
        return _user;
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

}