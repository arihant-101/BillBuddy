import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HumansProvider extends ChangeNotifier {
  Map<String, String> _humans = {}; // Store UID-to-Name mapping

  Map<String, String> get humans => _humans;

  HumansProvider(String uid) {
    // Initialize the friends list when the provider is created
    loadHumansFromFirestore(uid);
  }

  Future<void> loadHumansFromFirestore(String uid) async {
    try {
      final QuerySnapshot allUsersSnapshot =
          await FirebaseFirestore.instance.collection('humans').get();

      final Map<String, String> humansData = {};

      allUsersSnapshot.docs.forEach((doc) {
        final uid = doc.id as String;
        final name = doc['name'] as String;
        humansData[uid] = name;
      });

      _humans = humansData;
      notifyListeners();
    } catch (e) {
      print('Error loading friends from Firestore: $e');
    }
  }

  Future<void> loadHumans() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      await loadHumansFromFirestore(uid);
    }
  }
}
