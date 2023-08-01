import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';

class AuthFunctions {
  // Insrances of firebase auth and firebase firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Text fields validator function

  String? Function(String?) validator =
      (value) => value != null && value.isNotEmpty ? null : validateError;

  // Build UserEntity to use in authentication screen

  UserEntity? buildUserEntity(
      {required GlobalKey<FormState> emailKey,
      required GlobalKey<FormState> passwordKey,
      GlobalKey<FormState>? nameKey,
      required TextEditingController emailController,
      required TextEditingController passwordController,
      TextEditingController? nameController}) {
    nameKey != null ? nameKey.currentState!.validate() : null;
    emailKey.currentState!.validate();
    passwordKey.currentState!.validate();

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      return UserEntity(
          email: emailController.text,
          password: passwordController.text,
          fullName: nameController?.text);
    } else {
      return null;
    }
  }

  // Signup functaion

  Future<void> signup(
      {required UserEntity userEntity, required bool isPrivacyAgreed}) async {
    if (isPrivacyAgreed) {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: userEntity.email,
        password: userEntity.password,
      );

      final AppUser appUser = AppUser(
          fullName: userEntity.fullName,
          email: userEntity.email,
          password: userEntity.password,
          userUID: userCredential.user!.uid);

      await _mergeInDB(appUser: appUser);
    } else {
      showSnakeBar(title: appName, message: agreeThePrivacy);
    }
  }

  // Login function
  Future<void> login({required UserEntity userEntity}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: userEntity.email,
      password: userEntity.password,
    );
  }

  // Continue with google function
  Future<void> continueWithGoogle() async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithProvider(GoogleAuthProvider());
    final AppUser appUser = AppUser(
      email: userCredential.user!.email!,
      userUID: userCredential.user!.uid,
    );
    await _mergeInDB(appUser: appUser);
  }

  //  Merge information in Database
  Future<void> _mergeInDB({required AppUser appUser}) async => await _firestore
      .collection(usersCollectionPath)
      .doc(appUser.email)
      .set(appUser.userEntityJSON, SetOptions(merge: true));
}
