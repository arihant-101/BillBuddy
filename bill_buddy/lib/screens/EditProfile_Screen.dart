import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String selectedCountry = 'United States'; // Set a default country
  File? _image; // Store the selected image file

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular profile picture area
            GestureDetector(
                onTap: _pickImage, // Call the _pickImage function when tapped
                child: CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/default_profile_image.png"),
                )),
            SizedBox(height: 20),
            Text('Name:'),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            SizedBox(height: 20),
            Text('Phone Number:'),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
              ),
            ),
            SizedBox(height: 20),
            Text('Email ID:'),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email ID',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the save button click here
                // You can access the entered values using TextEditingController
                // For example, nameController.text to get the name.
                // selectedCountry contains the selected country.
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
