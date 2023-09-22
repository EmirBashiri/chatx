import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:path/path.dart';

abstract class DuplicateFunctions {
  // Insrances of firebase auth & firebase firestore & firebase storage
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // Function to merge user information in Database
  Future<void> mergeInDB({required AppUser appUser}) async => await firestore
      .collection(usersCollectionPath)
      .doc(appUser.userUID)
      .set(AppUser.userEntityToJSON(appUser: appUser), SetOptions(merge: true));

  // Fuction to pick image from user storage
  Future<File?> imagePicker() async {
    final XFile? xFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      final File file = File(xFile.path);
      return file;
    }
    return null;
  }

  // Function to compress image
  Future<File> imageCompressor({required File imageFile}) async {
    File compressedImageFile;
    Future<File> compressImage({required int quality}) async {
      final String targetPath =
          "${imageFile.path}-compressed-${extension(imageFile.path)}";
      final XFile? compressor = await FlutterImageCompress.compressAndGetFile(
          imageFile.path, targetPath,
          quality: quality);
      imageFile.deleteSync(recursive: true);
      return File(compressor!.path);
    }

    // Convert bit to megabit
    final double imageSize = imageFile.lengthSync() / 1000000;
    if (imageSize < 1) {
      compressedImageFile = await compressImage(quality: 90);
      return compressedImageFile;
    } else if (imageSize < 3) {
      compressedImageFile = await compressImage(quality: 80);
      return compressedImageFile;
    } else if (imageSize < 6) {
      compressedImageFile = await compressImage(quality: 65);
      return compressedImageFile;
    } else {
      compressedImageFile = await compressImage(quality: 50);
      return compressedImageFile;
    }
  }
}
