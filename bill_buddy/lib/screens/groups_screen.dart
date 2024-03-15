import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'group_provider.dart';
import 'group.dart';
import 'add_group_screen.dart';
import 'GroupDetailsScreen.dart';
import 'group_finance_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    // Listen for changes in the GroupProvider
    Provider.of<GroupProvider>(context, listen: false)
        .getGroupsFromFirestore(FirebaseAuth.instance.currentUser?.uid ?? '');
    Provider.of<GroupProvider>(context, listen: false)
        .addListener(_refreshPage);
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    Provider.of<GroupProvider>(context, listen: false)
        .removeListener(_refreshPage);
    super.dispose();
  }

  _refreshPage() {
    // Trigger a rebuild of the widget using setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    final List<GroupModel> groups = groupProvider.groups;

    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GroupDetailsScreen(group: group),
              ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  group.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.group, color: Colors.white),
                ),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddGroupScreen(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Coming Soon'),
          content: Text('$featureName feature is coming soon.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  BottomNavItem({
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
