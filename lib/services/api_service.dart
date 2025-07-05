import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String endpoint = 'https://httpbin.org/post';

  static Future<bool> submitForm(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Submission error: $e');
      return false;
    }
  }
}
