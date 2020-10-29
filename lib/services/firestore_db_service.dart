import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat/models/user_model.dart';
import 'package:live_chat/services/db_base.dart';
var r = Random();

class FireStoreDbService implements DbBase {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {

    Map newUser = user.toMap();
    newUser['userName'] = 'User ' +  String.fromCharCodes(List.generate(10, (index) => r.nextInt(33) + 89));
    newUser['createdAt'] = FieldValue.serverTimestamp();
    newUser['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore.collection('users').doc(user.userId).set(newUser);
    
    DocumentSnapshot _getUser =  await _firestore.doc('users/${newUser['userId']}').get();
    print('Save User: ${_getUser.data()}');
    
    return true;
  }

}