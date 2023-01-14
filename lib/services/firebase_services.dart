import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String getUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  final CollectionReference productRef =
  FirebaseFirestore.instance.collection("Products");

  final CollectionReference orderRef =
  FirebaseFirestore.instance.collection("Orders");

  final CollectionReference cartRef =
  FirebaseFirestore.instance.collection("Users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Cart");

  final CollectionReference userOrderRef =
  FirebaseFirestore.instance.collection("Users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Orders");

  final CollectionReference usersRef =
  FirebaseFirestore.instance.collection("Users");

}
