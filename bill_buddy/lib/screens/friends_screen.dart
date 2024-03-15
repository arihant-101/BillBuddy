import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'friends_provider.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<FriendsProvider>(context, listen: false).loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    final friendsProvider = Provider.of<FriendsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: friendsProvider.friends.length,
              itemBuilder: (context, index) {
                final friendUid = friendsProvider.friends.keys.elementAt(index);
                final friendName = friendsProvider.friends[friendUid];
                return FriendCard(name: friendName ?? 'Unknown');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _addFriend(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Button background color
                onPrimary: Colors.white, // Text color
                elevation: 5, // Button elevation
                padding: EdgeInsets.all(15), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Add Friend',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addFriend(BuildContext context) async {
    final PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      final contact = await _selectContact();
      if (contact != null) {
        String? phoneNumber = contact.phones?.first.value;
        if (phoneNumber != null && phoneNumber.isNotEmpty) {
          if (phoneNumber.startsWith('+91')) {
            phoneNumber = phoneNumber.substring(3); // Remove +91 prefix
          }

          // Now, you can sync the phone number as required
          final friendsProvider =
              Provider.of<FriendsProvider>(context, listen: false);
          final friend =
              await friendsProvider.findFriendByPhoneNumber(phoneNumber);

          if (friend != null) {
            friendsProvider.addFriend(friend['uid']!, friend['name']!);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Friend Not Found'),
                  content:
                      Text('No user found with the provided phone number.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    } else {
      // Handle contact permission not granted
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text('Permission to access contacts was denied.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted) {
      return await Permission.contacts.request();
    } else {
      return status;
    }
  }

  Future<Contact?> _selectContact() async {
    try {
      return await ContactsService.openDeviceContactPicker();
    } catch (e) {
      // Handle any exception that might come up
      return null;
    }
  }
}

class FriendCard extends StatelessWidget {
  final String name;

  FriendCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.person,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
