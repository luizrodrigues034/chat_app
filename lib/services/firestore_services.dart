import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  Future addUser(Map<String, dynamic> userInfoMap, String id) async {
    FirebaseFirestore.instance.collection('user').doc(id).set(userInfoMap);
  }
}
