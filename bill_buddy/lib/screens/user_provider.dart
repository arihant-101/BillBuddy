import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  String _userName = '';

  Future<String> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('humans')
            .doc(uid)
            .get();
        if (userDoc.exists) {
          final name = userDoc.get('name');
          return name ?? '';
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
    return '';
  }

  String? get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }
}
