import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _uid = FirebaseAuth.instance.currentUser?.uid ?? ''; // User's own UID

  FriendsProvider(this._uid);

  Map<String, String> _friends =
      {}; // Map of friends (UID as key, name as value)

  Map<String, String> get friends => _friends;

  Future<void> loadFriends() async {
    try {
      final friendsCollection = _firestore.collection('humans');
      final friendsSnapshot = await friendsCollection
          .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
          .get();

      if (friendsSnapshot.exists) {
        final friendsData = friendsSnapshot.data() as Map<String, dynamic>;
        _friends = Map<String, String>.from(friendsData['friends']);
      } else {
        _friends = {};
      }

      notifyListeners();
    } catch (error) {
      print('Error loading friends: $error');
    }
  }

  Future<void> addFriend(String friendUid, String friendName) async {
    try {
      final friendsCollection = _firestore.collection('humans');
      final userDoc = friendsCollection.doc(_uid);
      final friendDoc = friendsCollection.doc(friendUid);

      final userData = await userDoc.get();
      final friendData = await friendDoc.get();

      final existingUserData = userData.data() as Map<String, dynamic>;
      final existingFriendData = friendData.data() as Map<String, dynamic>;

      // Update the current user's friends map with the new friend
      _friends[friendUid] = friendName;
      existingUserData['friends'][friendUid] = friendName;

      // Update the friend's friends map with the current user's data
      existingFriendData['friends'][_uid] = existingUserData['name'];

      await userDoc.update({'friends': existingUserData['friends']});
      await friendDoc.update({'friends': existingFriendData['friends']});

      notifyListeners();
    } catch (error) {
      print('Error adding friend: $error');
    }
  }

  Future<Map<String, String>?> findFriendByPhoneNumber(
      String phoneNumber) async {
    try {
      final usersCollection = _firestore.collection('humans');
      final userQuery = await usersCollection
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userData = userQuery.docs.first.data() as Map<String, dynamic>;
        final uid = userQuery.docs.first.id;
        final name = userData['name'] as String;

        // Check if the user is already a friend
        if (_friends.containsKey(uid)) {
          return null; // Already a friend
        }

        if (uid == _uid) {
          return null; // Cannot add yourself as a friend
        }

        return {'uid': uid, 'name': name};
      } else {
        return null; // Friend not found
      }
    } catch (error) {
      print('Error finding friend by phone number: $error');
      return null;
    }
  }
}
