import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/ViewModel/AppFunctions/DuplicateFunctions/duplicate_functions.dart';
import 'package:get/get.dart';

class SettingsFunctions extends DuplicateFunctions {
  // Boolean to determine whether the user can leave the profie edit screen or not
  bool canClose = true;

  // Instance of firebase storage upload task
  UploadTask? uploadTask;

  // Function to fetch edit fields hint text
  String? fetchHintText(
      {required bool isPasswordField, required String? hintText}) {
    if (isPasswordField) {
      return hintText?.replaceAll(RegExp('.'), '⦁');
    } else {
      return hintText;
    }
  }

  // Function to set new avatar from gallery
  Future<String?> setNewAvatar() async {
    final File? imageFile = await imagePicker();
    return imageFile?.path;
  }

// Function to relogin in firebase auth
  Future<void> _relogin({required AppUser currentUser}) async {
    // Here checking if the password is empty or not to decide on
    // the type of relogin.
    if (currentUser.password != null && currentUser.password!.isNotEmpty) {
      await firebaseAuth.signInWithEmailAndPassword(
          email: currentUser.email, password: currentUser.password!);
    } else {
      await firebaseAuth.signInWithProvider(GoogleAuthProvider());
    }
  }

  // Function to check can update the user in DB or not
  (bool, AppUser?) _checkCanUpdate(
      {required AppUser currentUser,
      required UserEntity userEntity,
      String? imageURL}) {
    // Checking if full name changed or not
    final bool fullNameCheck = userEntity.fullName != null &&
        userEntity.fullName!.isNotEmpty &&
        userEntity.fullName != currentUser.fullName;
    // Checking if email changed or not
    final bool emailCheck =
        userEntity.email.isNotEmpty && userEntity.email != currentUser.email;
    // Checking if password changed or not
    final bool passwordCheck = userEntity.password.isNotEmpty &&
        userEntity.password != currentUser.password;
    // Checking if avatar changed or not
    final bool avatarCheck = imageURL != null &&
        imageURL.isNotEmpty &&
        imageURL != currentUser.profileImageUrl;

    if (fullNameCheck || emailCheck || passwordCheck || avatarCheck) {
      return (
        true,
        AppUser(
            fullName:
                fullNameCheck ? userEntity.fullName : currentUser.fullName,
            email: emailCheck ? userEntity.email : currentUser.email,
            password:
                passwordCheck ? userEntity.password : currentUser.password,
            profileImageUrl: imageURL ?? currentUser.profileImageUrl,
            userUID: currentUser.userUID)
      );
    } else {
      return (false, null);
    }
  }

  //  Function to update the user in firebase auth and firesotre DB
  Future<void> _userUpdater(
      {required AppUser currentUser, required AppUser updatedUser}) async {
    final bool emailCheck = updatedUser.email != currentUser.email;
    final bool passwordCheck = updatedUser.password != currentUser.password &&
        updatedUser.password != null &&
        updatedUser.password!.isNotEmpty;

    // Here cheking if email and password changed or not
    if (emailCheck && passwordCheck) {
      await _relogin(currentUser: currentUser);
      await firebaseAuth.currentUser!.updateEmail(updatedUser.email);
      await firebaseAuth.currentUser!.updatePassword(updatedUser.password!);
    } else {
      // Here cheking if email changed or not
      if (emailCheck) {
        await _relogin(currentUser: currentUser);
        await firebaseAuth.currentUser!.updateEmail(updatedUser.email);
      }
      // Here cheking if password changed or not
      if (passwordCheck) {
        await _relogin(currentUser: currentUser);
        await firebaseAuth.currentUser!.updatePassword(updatedUser.password!);
      }
    }

    await mergeInDB(appUser: updatedUser);
  }

  // Function to upload avatar in firebase stroage
  Future<void> _avatarUploder({
    required Reference storageReference,
    required String avatarFilePath,
    required Future<void> Function() whenComplete,
  }) async {
    final File compressedImageFile =
        await imageCompressor(imageFile: File(avatarFilePath));
    uploadTask = storageReference.putFile(compressedImageFile);
    await uploadTask!.whenComplete(() async {
      if (uploadTask?.snapshot.state == TaskState.success) {
        await whenComplete.call();
      }
    });
  }

  // Function to save profile without avatar
  Future<void> saveWithoutAvatar(
      {required AppUser currentUser, required UserEntity userEntity}) async {
    canClose = false;

    // First part is a boolean that shows can update the user in DB or not and
    // Second part is a AppUser? thats returns new AppUser when first parts boolean is true.
    final (bool, AppUser?) canUpdate =
        _checkCanUpdate(currentUser: currentUser, userEntity: userEntity);
    if (canUpdate.$1) {
      final AppUser updatedUser = canUpdate.$2!;
      await _userUpdater(currentUser: currentUser, updatedUser: updatedUser);
      canClose = true;
    }
  }

  // Function to save profile with avatar
  Future<bool> saveWithAvatar({
    required AppUser currentUser,
    required UserEntity userEntity,
    required String imageFilePath,
  }) async {
    bool isSuccess = false;
    final Reference storageReference =
        firebaseStorage.ref("$avatarsBucket/${currentUser.userUID}");
    String profileImageUrl = "";
    await _avatarUploder(
      storageReference: storageReference,
      avatarFilePath: imageFilePath,
      whenComplete: () async {
        profileImageUrl = await storageReference.getDownloadURL();
        // First part is a boolean that shows can update the user in DB or not and
        // Second part is a AppUser? thats returns new AppUser when first parts boolean is true.
        final (bool, AppUser?) canUpdate = _checkCanUpdate(
            currentUser: currentUser,
            userEntity: userEntity,
            imageURL: profileImageUrl);
        if (canUpdate.$1) {
          AppUser updatedUser = canUpdate.$2!;
          await _userUpdater(
              currentUser: currentUser, updatedUser: updatedUser);
          isSuccess = true;
        }
      },
    );
    return isSuccess;
  }

  // Function to return back to home screen
  void returnToHomeScreen() {
    navigator!.popUntil((route) => route.isFirst);
  }

  // Function to cancel avatar uploading
  Future<void> _cancelAvatarUploading() async {
    await uploadTask?.cancel();
    uploadTask = null;
  }

  // Edit profile screens on will pop function
  Future<bool> onWillPop() async {
    if (canClose) {
      await _cancelAvatarUploading();
      return true;
    } else {
      return false;
    }
  }

  // Edit profile screens close function
  Future<void> closeEditProfile() async {
    if (canClose) {
      await _cancelAvatarUploading();
      Get.back();
    }
  }
}
