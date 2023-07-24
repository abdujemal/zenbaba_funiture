import 'package:cloud_firestore/cloud_firestore.dart';

import 'data/model/user_model.dart';

class UserRepo {
  FirebaseFirestore firestore;
  UserRepo(this.firestore);

  Future<UserModel> getData(String userID) async {
    final ds = await firestore.collection('users').doc(userID).get();
    return UserModel.fromFirebase(ds);
  }
}
