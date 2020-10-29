import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/db_base.dart';

class FireStoreDbService implements DbBase {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {

    await _firestore.collection('users').doc(user.userId).set(user.toMap());
    
    DocumentSnapshot response =  await _firestore.doc('users/${user.userId}').get();
    UserModel readUser = UserModel.fromMap(response.data());
    print('Okunan User: ${readUser.toString()}');

    return true;
  }

}