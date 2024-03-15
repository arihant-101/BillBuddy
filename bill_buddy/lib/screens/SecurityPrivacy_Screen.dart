import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  @override
  _SecurityPrivacyScreenState createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reenterPasswordController = TextEditingController();

  String errorMessage = '';

  Future<void> _changePassword() async {
    final localAuth = LocalAuthentication();

    try {
      // Check if biometric authentication is available
      final isAvailable = await localAuth.isDeviceSupported();

      if (isAvailable) {
        // Authenticate with biometrics
        final isAuthenticated = await localAuth.authenticate(
          localizedReason: 'Authenticate for password change',
        );

        if (isAuthenticated) {
          // Biometric authentication successful, proceed with password change logic
          String currentPassword = currentPasswordController.text;
          String newPassword = newPasswordController.text;
          String reenteredPassword = reenterPasswordController.text;

          if (newPassword == reenteredPassword) {
            // Passwords match, proceed to change the password
            // You can implement the password change logic here
            // Reset text fields and error message
            currentPasswordController.clear();
            newPasswordController.clear();
            reenterPasswordController.clear();
            setState(() {
              errorMessage = '';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Password changed successfully.'),
              ),
            );
          } else {
            // Passwords don't match, show an error message
            setState(() {
              errorMessage = 'Passwords do not match.';
            });
          }
        } else {
          // Biometric authentication failed
          setState(() {
            errorMessage = 'Biometric authentication failed.';
          });
        }
      } else {
        // Biometric authentication is not available on this device
        setState(() {
          errorMessage =
              'Biometric authentication is not available on this device.';
        });
      }
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions
      setState(() {
        errorMessage = 'Biometric authentication error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security and Privacy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: reenterPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Re-enter New Password'),
            ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
