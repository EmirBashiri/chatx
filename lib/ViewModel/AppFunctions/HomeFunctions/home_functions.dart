import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';
import 'package:flutter_chatx/Model/Entities/user_entity.dart';
import 'package:flutter_chatx/View/Screens/HomeScreen/bloc/home_bloc.dart';

class HomeFunctioins {
  // Instance of firestore for get user list stream
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fech user list from Database
  Future<void> _fechUserList({
    required QuerySnapshot<Map<String, dynamic>> event,
    required List<AppUser> userList,
  }) async {
    for (var json in event.docs) {
      userList.add(AppUser.fromJson(json.data()));
    }
  }

  // Listen to Database user list
  void listenToUsers({required HomeBloc homeBloc}) async {
    final List<AppUser> userList = [];
    final Stream<QuerySnapshot<Map<String, dynamic>>> userListStream =
        _firestore.collection(usersCollectionPath).snapshots();
    userListStream.listen(
      (event) async {
        await _fechUserList(event: event, userList: userList);
        homeBloc.add(HomeFechUserList(userList));
      },
    );
  }

  //  Fech current user
  AppUser fechCurrentUser(
      {required List<AppUser> userList, required User firebaseCurrentUser}) {
    return userList
        .firstWhere((appUser) => appUser.userUID == firebaseCurrentUser.uid);
  }
}
