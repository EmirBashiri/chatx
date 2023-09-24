import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Widgets/widgets.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/DuplicateFunctions/duplicate_functions.dart';

class AuthFunctions extends DuplicateFunctions {
  // Text fields validator function
  String? Function(String?) validator =
      (value) => value != null && value.isNotEmpty ? null : validateErrorDialog;

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
      final UserEntity userEntity = UserEntity(
        email: emailController.text,
        password: passwordController.text,
        fullName: nameController?.text,
      );
      emailController.clear();
      passwordController.clear();
      nameController?.clear();
      return userEntity;
    } else {
      return null;
    }
  }

  // Signup functaion
  Future<void> signup(
      {required UserEntity userEntity, required bool isPrivacyAgreed}) async {
    if (isPrivacyAgreed) {
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: userEntity.email,
        password: userEntity.password,
      );
      final AppUser appUser = AppUser(
          fullName: userEntity.fullName,
          email: userEntity.email.trim(),
          password: userEntity.password,
          userUID: userCredential.user!.uid);
      await mergeInDB(appUser: appUser);
    } else {
      showSnakeBar(title: appName, message: agreeThePrivacyDialog);
    }
  }

  // Login function
  Future<void> login({required UserEntity userEntity}) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: userEntity.email.trim(),
      password: userEntity.password,
    );
  }

  // Continue with google function
  Future<void> continueWithGoogle() async {
    UserCredential userCredential =
        await firebaseAuth.signInWithProvider(GoogleAuthProvider());
    final AppUser appUser = AppUser(
        fullName: userCredential.user!.displayName,
        email: userCredential.user!.email!,
        userUID: userCredential.user!.uid,
        profileImageUrl:
            userCredential.user!.photoURL ?? defaultUserProfileUrl);
    await mergeInDB(appUser: appUser);
  }
}
