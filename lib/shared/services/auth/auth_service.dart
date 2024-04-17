import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_flutter_dew/constant/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

class AuthService {
  static Future<bool> login(
      String email, String password, BuildContext context) async {
    final url = Uri.parse('http://10.0.2.2:6004/api/login');
    final header = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
    };
    final body = jsonEncode({
      "user_email": email,
      "user_password": password,
    });
    try {
      var response = await http.post(url, headers: header, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setBool('loggedIn', true);
        await prefs.setInt('user_id', data['user_id']);
        await prefs.setString('user_email', data['user_email']);
        await prefs.setString('user_fname', data['user_fname']);
        await prefs.setString('user_lname', data['user_lname']);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
      } else {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text("Login Failed"),
                  content: const SizedBox(
                    height: 20,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Email or password is incorrect."),
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"))
                  ],
                ));
        return false; // Add this line
      }
    } catch (e) {
      devtools.log(e.toString());
      rethrow;
    }
    return false; // Add this line
  }

  static Future<void> logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(loginRoutes, (routes) => false);
    await prefs.setBool('loggedIn', false);
  }

  static Future<void> signUp(
      firstName, lastName, email, password, context) async {
    final url = Uri.parse('http://10.0.2.2:6004/api/create_user');
    final header = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
    };
    final body = jsonEncode({
      "user_email": email,
      "user_password": password,
      "user_fname": firstName,
      "user_lname": lastName,
    });
    try {
      var response = await http.post(url, headers: header, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pushNamed(loginRoutes);
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
