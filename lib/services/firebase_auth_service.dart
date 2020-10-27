import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel> getCurrentUser() async {
    try{
      User firebaseUser = _firebaseAuth.currentUser;
      UserModel user = _userFromFirebase(firebaseUser);

      return user;
    }catch(err) {
      print('Current User Hata: ${err.toString()}');

      return null;
    }
  }

  @override
  Future<UserModel> signInAnonymously() async {
    print('signInAnonymously');
    try{
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      UserModel user = _userFromFirebase(userCredential.user);

      return user;
    } catch(err) {
      print('Sign In Anonymously Hata: ${err.toString()}');

      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    print('signOut');
    try{
      await _firebaseAuth.signOut();

      return true;
    } catch(err) {
      print('Sign Out Hata: ${err.toString()}');

      return null;
    }
  }

  UserModel _userFromFirebase(User firebaseUser) {
    if(firebaseUser == null)
      return null;

    return  UserModel(userId: firebaseUser.uid);
  }

}