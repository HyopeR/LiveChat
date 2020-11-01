import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/db_base.dart';

class FireStoreDbService implements DbBase {

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {

    await _fireStore.collection('users').doc(user.userId).set(user.toMap());

    return true;
  }

  @override
  Future<UserModel> readUser(String userId) async {

    // DocumentSnapshot response = await _fireStore.collection('users').doc(userId).get();
    DocumentSnapshot response =  await _fireStore.doc('users/$userId').get();
    UserModel readUser = UserModel.fromMap(response.data());

    return readUser;
  }

  @override
  Future<Map<String, dynamic>> checkUser(String userId) async {
    DocumentSnapshot response =  await _fireStore.doc('users/$userId').get();
    bool checkUser = response.data() == null ? false : true;

    if(!checkUser){
      return {'check': checkUser};
    } else {
      return {'check': checkUser, 'user': UserModel.fromMap(response.data())};
    }

  }

  @override
  Future<bool> updateUserName(String userId, String newUserName) async {
    QuerySnapshot response =  await _fireStore.collection('users').where('userName', isEqualTo: newUserName).get();
    if(response.docs.length >= 1) {
      return false;
    } else {
      
      await _fireStore.collection('users').doc(userId).update({
        'userName': newUserName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    }
    
  }

  @override
  Future<bool> updateProfilePhoto(String userId, String fileUrl) async {
    await _fireStore.collection('users').doc(userId).update({
      'userProfilePhotoUrl': fileUrl,
    });

    return true;
  }

}