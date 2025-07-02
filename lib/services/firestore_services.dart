import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static Future addUser(Map<String, dynamic> userInfoMap, String id) async {
    print('teste');

    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
    print('teste');
  }
}
