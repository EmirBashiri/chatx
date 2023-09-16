import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/HomeScreen/bloc/home_bloc.dart';

class HomeFunctioins {
  // Instance of firestore for get user list stream
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Application user list for use in the whole class
  List<AppUser> _userList = [];

  // Function to Fetch user list from Database
  Future<void> _fetchUserList(
      {required QuerySnapshot<Map<String, dynamic>> event}) async {
    _userList =
        event.docs.map((json) => AppUser.fromJson(json.data())).toList();
  }

  // Function to Listen to Database user list
  void listenToUsers({required HomeBloc homeBloc}) async {
    final Stream<QuerySnapshot<Map<String, dynamic>>> userListStream =
        _firestore.collection(usersCollectionPath).snapshots();
    userListStream.listen((event) async {
      await _fetchUserList(event: event);
      homeBloc.add(HomeUpdate(_userList));
    }, onError: (error) => homeBloc.add(HomeError(error)));
  }

  // Function to Fetch current user
  AppUser fetchCurrentUser(
      {required List<AppUser> userList, required User firebaseCurrentUser}) {
    return userList
        .firstWhere((appUser) => appUser.userUID == firebaseCurrentUser.uid);
  }
}
