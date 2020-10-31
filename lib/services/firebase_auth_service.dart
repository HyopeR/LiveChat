import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // İşlevsel fonksiyonlar
  UserModel _userFromFirebase(User firebaseUser) {
    if(firebaseUser == null)
      return null;

    return  UserModel(userId: firebaseUser.uid, userEmail: firebaseUser.email);
  }

  // Network fonksiyonlar
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
    try{
      // Default Logout
      await _firebaseAuth.signOut();

      // Google Logout
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

      // Facebook Logout
      final _facebookLogin = FacebookLogin();
      await _facebookLogin.logOut();


      return true;
    } catch(err) {
      print('Sign Out Hata: ${err.toString()}');

      return null;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

    if(_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if((_googleAuth.idToken != null) && (_googleAuth.accessToken != null)) {

        UserCredential result = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(
            idToken: _googleAuth.idToken,
            accessToken: _googleAuth.accessToken)
        );

        User firebaseUser = result.user;
        UserModel user = _userFromFirebase(firebaseUser);

        return user;

      } else
          return null;
    } else
        return null;
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    FacebookLogin _facebookLogin = FacebookLogin();
    FacebookLoginResult _faceResult = await _facebookLogin.logIn(['public_profile', 'email']);
    
    switch(_faceResult.status) {
      case FacebookLoginStatus.loggedIn:

        UserCredential result = await _firebaseAuth.signInWithCredential(FacebookAuthProvider.credential(_faceResult.accessToken.token));
        User firebaseUser = result.user;
        UserModel user = _userFromFirebase(firebaseUser);

        return user;
        break;

      case FacebookLoginStatus.cancelledByUser:
        print('Cancelled by user.');
        break;

      case FacebookLoginStatus.error:
        print('Error: ${_faceResult.errorMessage}');
        break;

      default:
        break;
    }

    return null;
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      UserModel user = _userFromFirebase(userCredential.user);

      return user;
    } catch(err) {
      print('signInWithEmailAndPassword Error: ${err.toString()}');

      return null;
    }
  }

  @override
  Future<UserModel> createUserEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    UserModel user = _userFromFirebase(userCredential.user);

    return user;
    // try{
    //   UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    //   UserModel user = _userFromFirebase(userCredential.user);
    //
    //   return user;
    // } catch(err) {
    //   print('createUserEmailAndPassword Error: ${err.toString()}');
    //
    //   return null;
    // }
  }

}