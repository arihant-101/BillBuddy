import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'group_provider.dart';
import 'friends_provider.dart';
import 'group.dart';
import 'user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'friends_screen.dart'; // Import the FriendsScreen

class AddGroupScreen extends StatefulWidget {
  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  TextEditingController groupNameController = TextEditingController();
  String currentUserName = '';
  String currentuseruid = '';
  Map<String, String> selectedMembers = {};

  @override
  void initState() {
    super.initState();
    // Initialize data when the widget is first created
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Retrieve the current user's name and set it
    final userName =
        await Provider.of<UserProvider>(context, listen: false).getUserName();

    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    setState(() {
      currentUserName = userName;
      currentuseruid = userId;
    });

    // Load the list of friends when the screen is initialized
    await Provider.of<FriendsProvider>(context, listen: false).loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the list of friend names from FriendsProvider
    final Map<String, String> people =
        Provider.of<FriendsProvider>(context).friends;

    if (people.keys.contains(currentuseruid)) {
      people.removeWhere((key, value) => value == currentUserName);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            SizedBox(height: 16.0),
            Text('Select Group Members:'),
            Expanded(
              child: ListView(
                children: people.keys.map((person) {
                  return CheckboxListTile(
                    title: Text(people[person].toString()),
                    value: selectedMembers.containsKey(person),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            selectedMembers[person] = people[person].toString();
                          } else {
                            selectedMembers
                                .removeWhere((key, value) => key == person);
                          }
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                selectedMembers[currentuseruid] = currentUserName;
                String groupName = groupNameController.text;

                if (groupName.isNotEmpty && selectedMembers.isNotEmpty) {
                  // Create a new group with name and members' UIDs
                  GroupModel group = GroupModel(groupName, selectedMembers);

                  // Use Provider to add the group to the list
                  Provider.of<GroupProvider>(context, listen: false)
                      .addGroup(group);

                  // Navigate back to the GroupsScreen
                  Navigator.of(context).pop();
                }
              },
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the FriendsScreen when "Add Friends" is clicked
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FriendsScreen(),
          ));
        },
        child: Icon(Icons.person_add),
      ),
    );
  }
}
