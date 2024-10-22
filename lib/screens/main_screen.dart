// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'checkin_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facial Recognition Attendance'),
        centerTitle: true, // Center the title for a balanced look
      ),
      body: SingleChildScrollView( // Make the body scrollable
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Adding padding around the content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen()),
                    );
                  },
                  icon: Icon(Icons.person_add), // Icon for registration
                  label: Text('Register New User'),
                ),
                SizedBox(height: 20), // Add space between buttons
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckInScreen()),
                    );
                  },
                  icon: Icon(Icons.login), // Icon for check-in
                  label: Text('Check In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
