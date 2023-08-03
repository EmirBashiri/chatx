import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatx/Model/Constant/const.dart';

class HomeFunctioins {
  // Instance of firestore for get user list stream
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User list stream function
  Stream<QuerySnapshot<Map<String, dynamic>>> userListStream() {
    return _firestore.collection(usersCollectionPath).snapshots();
  }
}
