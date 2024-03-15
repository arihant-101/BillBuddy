import 'package:flutter/material.dart';
import 'EditProfile_Screen.dart';
import 'SecurityPrivacy_Screen.dart';
import 'Notifications_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart'; // Make sure to import your sign-up screen

class SettingsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget _buildSettingsButton(
      BuildContext context, String text, Widget screen) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Color(0xFF3F51B5), Color(0xFF303F9F)],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => screen));
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: ElevatedButton(
        onPressed: () async {
          await _auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.0),
        ),
        child: Text(
          'LOG OUT',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color(0xFF303F9F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSettingsButton(context, 'Edit Profile', EditProfileScreen()),
            SizedBox(height: 16),
            _buildSettingsButton(
                context, 'Notifications', NotificationsScreen()),
            SizedBox(height: 16),
            _buildSettingsButton(
                context, 'Security and Privacy', SecurityPrivacyScreen()),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.language,
                color: Color(0xFF303F9F),
              ),
              title: Text('Language', style: TextStyle(fontSize: 18)),
              subtitle: Text('English',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              onTap: () {},
            ),
            Divider(
              color: Colors.grey,
              height: 32,
            ),
            ListTile(
              leading: Icon(
                Icons.feedback,
                color: Color(0xFF303F9F),
              ),
              title: Text('Send Feedback', style: TextStyle(fontSize: 18)),
              onTap: () {},
            ),
            Spacer(),
            _buildLogoutButton(context),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SettingsScreen(),
  ));
}
