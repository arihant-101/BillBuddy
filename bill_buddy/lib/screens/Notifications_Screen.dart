import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool getGroupNotifications = true;
  bool getExpenseNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text('Get group notifications'),
            trailing: Switch(
              value: getGroupNotifications,
              onChanged: (value) {
                setState(() {
                  getGroupNotifications = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Get notifications when added to an expense'),
            trailing: Switch(
              value: getExpenseNotifications,
              onChanged: (value) {
                setState(() {
                  getExpenseNotifications = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationsScreen(),
  ));
}
