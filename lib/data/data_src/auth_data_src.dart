import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zenbaba_funiture/constants.dart';
import 'package:zenbaba_funiture/data/model/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> signUpWithEmailnPassword(
      UserModel userModel, String password, File file);
  Future<void> signUpWithGoogle(UserModel? userModel, String priority);
  // Future<void> signUpWithFacebook(UserModel? userModel, String priority);
  Future<UserModel> signInWithEmailnPassword(String email, String password);
  Future<void> forgetPassword(String email);
  Future<void> signOut();
  Future<UserModel> getUser();
  Future<void> setUser(UserModel userModel);
}

class AuthDataSourceImpl extends AuthDataSource {
  FirebaseAuth firebaseAuth;
  GoogleSignIn googleSignIn;
  FirebaseFirestore firebaseFirestore;
  FirebaseStorage firebaseStorage;
  AuthDataSourceImpl(
      {required this.firebaseStorage,
      required this.firebaseAuth,
      required this.googleSignIn,
      required this.firebaseFirestore,});

  @override
  Future<void> forgetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserModel> getUser() async {
    if (firebaseAuth.currentUser != null) {
      final userDs = await firebaseFirestore
          .collection(FirebaseConstants.users)
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      return UserModel.fromFirebase(userDs);
    } else {
      throw Exception("not logged in.");
    }
  }

  @override
  Future<void> setUser(UserModel userModel) async {
    String? uid = firebaseAuth.currentUser?.uid;
    if (uid != null) {
      await firebaseFirestore
          .collection(FirebaseConstants.users)
          .doc(uid)
          .set(userModel.toMap(), SetOptions(merge: true));
    }
  }

  @override
  Future<UserModel> signInWithEmailnPassword(
      String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return await getUser();
  }

  @override
  Future<void> signOut() async {
    bool isGoogle =
        firebaseAuth.currentUser!.providerData[0].providerId == "google.com";

    await firebaseAuth.signOut();
    if (isGoogle) {
      GoogleSignIn().signOut();
    }
  }

  @override
  Future<UserModel> signUpWithEmailnPassword(
      UserModel userModel, String password, File file) async {
    UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
            email: userModel.email, password: password);

    final ref = firebaseStorage.ref().child(
        "${FirebaseConstants.users}/${userCredential.user!.uid.toString()}.png");

    UploadTask uploadTask = ref.putFile(file);

    String imgUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    final newUser =
        userModel.copyWith(id: userCredential.user!.uid, image: imgUrl);

    await firebaseFirestore
        .collection(FirebaseConstants.users)
        .doc(userCredential.user?.uid)
        .set(newUser.toMap(), SetOptions(merge: true));

    return newUser;
  }

  // @override
  // Future<void> signUpWithFacebook(UserModel? userModel, String priority) async {
  //   final LoginResult loginResult = await facebookAuth.login();

  //   if (loginResult.accessToken != null) {
  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //     UserCredential cred =
  //         await firebaseAuth.signInWithCredential(facebookAuthCredential);

  //     String uid = cred.user!.uid;

  //     if (userModel != null) {
  //       await firebaseFirestore
  //           .collection(FirebaseConstants.users)
  //           .doc(uid)
  //           .set(userModel.toMap(), SetOptions(merge: true));
  //     } else {
  //       UserModel newUser = UserModel(
  //           id: cred.user?.uid ?? "",
  //           image: cred.user?.photoURL ?? "",
  //           name: cred.user?.displayName ?? "",
  //           priority: priority,
  //           email: cred.user?.email ?? "");

  //       await firebaseFirestore
  //           .collection(FirebaseConstants.users)
  //           .doc(uid)
  //           .set(newUser.toMap(), SetOptions(merge: true));
  //     }
  //   }
  // }

  @override
  Future<void> signUpWithGoogle(UserModel? userModel, String priority) async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential cred = await firebaseAuth.signInWithCredential(credential);

      String uid = cred.user!.uid;

      if (userModel != null) {
        await firebaseFirestore
            .collection(FirebaseConstants.users)
            .doc(uid)
            .set(userModel.toMap(), SetOptions(merge: true));
      } else {
        UserModel newUser = UserModel(
            id: cred.user?.uid ?? "",
            image: cred.user?.photoURL ?? "",
            name: cred.user?.displayName ?? "",
            priority: priority,
            phoneNumber: cred.user?.phoneNumber ?? "",
            email: cred.user?.email ?? "");

        await firebaseFirestore
            .collection(FirebaseConstants.users)
            .doc(uid)
            .set(newUser.toMap(), SetOptions(merge: true));
      }
    }
  }
}
