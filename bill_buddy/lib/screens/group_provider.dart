import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'group.dart';

class GroupProvider with ChangeNotifier {
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  GroupProvider() {
    getGroupsFromFirestore(FirebaseAuth.instance.currentUser?.uid ?? '');
  }

  List<GroupModel> _groups = [];

  List<GroupModel> get groups => _groups;

  Future<void> getGroupsFromFirestore(String uid) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('groups').get();

      final List<GroupModel> loadedGroups = [];

      for (final DocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        final Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;

        final String name = data['name'] as String;
        final Map<String, String> members =
            Map<String, String>.from(data['members']);
        if (members.keys.contains(uid)) {
          final GroupModel group = GroupModel(name, members);
          loadedGroups.add(group);
        }
      }

      _groups = loadedGroups;
      notifyListeners();
    } catch (e) {
      // Handle errors here
      print('Error retrieving groups from Firestore: $e');
    }
  }

  Future<void> addGroup(GroupModel group) async {
    try {
      await FirebaseFirestore.instance.collection('groups').add({
        'name': group.name,
        'members': group.members,
      });

      // Optionally, you can update the local list of groups if the Firestore addition is successful.
      _groups.add(group);
      notifyListeners();
    } catch (e) {
      // Handle errors here
      print('Error adding group to Firestore: $e');
    }
  }
}
