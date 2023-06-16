import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ttt/const/const.dart';

class AuthService {
  final storage = const FlutterSecureStorage();
  final String apiUrl = Constants.url;

  Future<bool> register(
      String email, String username, String password, int avatar) async {
    String registerUrl = '$apiUrl/api/register';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, String> body = {
      'email': email,
      'username': username,
      'password': password,
      'avatar': jsonEncode(avatar),
    };
    try {
      http.Response response = await http.post(
        Uri.parse(registerUrl),
        headers: headers,
        body: json.encode(body),
      );
      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String token = responseData['access_token'];

        await storage.write(key: 'access_token', value: token);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    String loginUrl =
        '$apiUrl/api/login'; // Replace with your login API endpoint

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, String> body = {
      'email': email,
      'password': password,
    };

    http.Response response = await http.post(
      Uri.parse(loginUrl),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String token = responseData['access_token'];

      // Save the access token securely
      await storage.write(key: 'access_token', value: token);

      return true;
    } else {
      return false;
    }
  }

  Future<String?> getToken() async {
    final token = await storage.read(key: 'access_token');
    return token;
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'access_token') != null;
    return token;
  }

  Future<void> logout() async {
    await storage.delete(key: 'access_token');
  }

  Future<Map<dynamic, dynamic>> getProfileData() async {
    final token = await AuthService().getToken();
    final response = await http.get(Uri.parse('$apiUrl/api/myprofile'),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load school data');
    }
  }
}
