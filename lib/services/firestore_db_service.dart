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
    bool checkUser = response.data().isEmpty;
    if(response.data().isEmpty)
      return {'check': checkUser, 'user': null};
    else
      return {'check': checkUser, 'user': UserModel.fromMap(response.data())};

  }

}