import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class CheckInScreen extends StatefulWidget {
  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final String apiUrl = "http://192.168.120.234:3000/check-in";
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

  Future<void> _captureAndSendImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile image = await _cameraController!.takePicture();

        // Save image to a temporary directory
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await File(image.path).copy(imagePath); // Ensure the image is copied correctly

        // Send the captured image to the backend for processing
        await _sendImageToBackend(imagePath);
      } catch (e) {
        print('Error capturing image: $e');
      }
    }
  }

  Future<void> _sendImageToBackend(String imagePath) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..fields['email'] = _emailController.text
      ..files.add(await http.MultipartFile.fromPath('image', imagePath));

    // Send the request
    var response = await request.send();
    final responseData = await http.Response.fromStream(response);
    final decodedResponse = json.decode(responseData.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(decodedResponse['message'])),
      );
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
      appBar: AppBar(title: Text('Check-In')),
      body: SingleChildScrollView( // Make the body scrollable
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                onPressed: _captureAndSendImage,
                child: Text('Capture and Check In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
