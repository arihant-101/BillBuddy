import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async {
    return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  }

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
        // You were missing commas after each element in the authMessages list

        localizedReason: 'Use Biometric', // Add a comma here
        // Use 'AuthenticationOptions' instead of 'AuthenticationOptions'
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint('error $e');
      return false;
    }
  }
}

// You can remove the AndroidAuthMessage and IOSAuthMessage classes as they are not needed.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Biometric Authentication Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              bool isAuthenticated = await LocalAuth.authenticate();
              if (isAuthenticated) {
                // Authentication was successful, handle accordingly
              } else {
                // Authentication failed or was canceled
              }
            },
            child: Text('Authenticate'),
          ),
        ),
      ),
    );
  }
}
