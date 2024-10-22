import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final String apiUrl = "http://192.168.120.234:3000/register"; // Your register API endpoint
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    // Set to high resolution
    _cameraController = CameraController(cameras.first, ResolutionPreset.high);
    await _cameraController?.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _captureAndRegisterUser() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile image = await _cameraController!.takePicture();

        // Save image to a temporary directory
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await File(image.path).copy(imagePath);

        // Send the captured image to the backend for registration
        await _registerUser(imagePath);
      } catch (e) {
        print('Error capturing image: $e');
      }
    }
  }

  Future<void> _registerUser(String imagePath) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..fields['name'] = _nameController.text
      ..fields['email'] = _emailController.text
      ..files.add(await http.MultipartFile.fromPath('image', imagePath));

    // Send the request
    var response = await request.send();
    final responseData = await http.Response.fromStream(response);
    final decodedResponse = json.decode(responseData.body);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(decodedResponse['message'])),
      );
      Navigator.pop(context); // Go back to the main screen after registration
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(decodedResponse['error'])),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register User')),
      body: SingleChildScrollView( // Make the body scrollable
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16),
              _isCameraInitialized
                  ? AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              )
                  : Center(child: CircularProgressIndicator()),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _captureAndRegisterUser,
                child: Text('Capture and Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
