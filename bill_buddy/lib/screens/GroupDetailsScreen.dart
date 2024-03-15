import 'package:flutter/material.dart';
import 'group.dart' as GroupPackage;
import 'add_group_payment_screen.dart';

class GroupDetailsScreen extends StatelessWidget {
  final GroupPackage.GroupModel group;

  GroupDetailsScreen({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Details'),
        elevation: 0, // Remove app bar shadow
        backgroundColor: Colors.blue, // Set app bar color
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Group Name: ${group.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'People in the Group:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: group.members.keys.map((member) {
                return ListTile(
                  title: Text(
                    group.members[member].toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.blue,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddGroupPaymentScreen(group: group),
                ));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Button color
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Add Group Payment',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
