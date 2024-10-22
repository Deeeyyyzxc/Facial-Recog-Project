// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';

class ApiService {
  static Future<Map<String, dynamic>?> registerUser(String name, String email, XFile image) async {
    final uri = Uri.parse('$API_BASE_URL/register');
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    if (response.statusCode == 201) {
      return jsonDecode(await response.stream.bytesToString());
    }
    return null;
  }

  static Future<Map<String, dynamic>?> checkInUser(String email, XFile image) async {
    final uri = Uri.parse('$API_BASE_URL/checkin');
    var request = http.MultipartRequest('POST', uri);
    request.fields['email'] = email;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    if (response.statusCode == 201) {
      return jsonDecode(await response.stream.bytesToString());
    }
    return null;
  }
}
