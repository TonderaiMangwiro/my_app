import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  static String apiEndpoint = 'http://52.206.48.46/api';

  static Future login(String email, String password) async {
    try {
      var map = Map<String, dynamic>();

      map['email'] = email;
      map['password'] = password;
      var url = Uri.parse('$apiEndpoint/login');
      final response = await http.post(url, body: map);

      if (response.statusCode == 200) {
        return response.body;
      }
      //returns the successful user data json object
    } catch (e) {
      //returns the error object if any

      return e;
    }
  }

  static Future registerUser(requestBody) async {
    var url = Uri.parse('$apiEndpoint/add-user');
    try {
      print(requestBody);
      final response = await http.post(url, body: requestBody);

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      //returns the error object if any
      print(e);
      print('---------------\n\n\n');
      return e;
    }
  }

  static Future register(requestBody) async {
    var url = Uri.parse('$apiEndpoint/register');
    try {
      print(requestBody);
      final response = await http.post(url, body: requestBody);

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      //returns the error object if any
      print(e);
      print('---------------\n\n\n');
      return e;
    }
  }

  static Future getUsers() async {
    var url = Uri.parse('$apiEndpoint/show-users');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      return e;
    }
  }

  static parseResponse(responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed;
  }

  logout(String accesstoken) {}
}
