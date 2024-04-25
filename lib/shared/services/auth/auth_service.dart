import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project_flutter_dew/shared/constant/routes.dart';
import 'package:project_flutter_dew/shared/constant/variables.dart';
import 'package:project_flutter_dew/shared/utils/helper_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

class AuthService {
  String url = api_url;
  final header = api_header;
  Future<http.Response> login(
      String email, String password, BuildContext context) async {
    final api = Uri.parse('$url/login');
    final body = jsonEncode({
      "user_email": email,
      "user_password": password,
    });
    try {
      var response = await http.post(api, headers: header, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setBool('loggedIn', true);
        await prefs.setInt('user_id', data['user_id']);
        await prefs.setString('user_email', data['user_email']);
        await prefs.setString('user_fname', data['user_fname']);
        await prefs.setString('user_lname', data['user_lname']);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
        EasyLoading.showSuccess("Login Successful.",
            duration: const Duration(seconds: 2));
        return response;
      } else if (response.statusCode == 400) {
        final responseError = jsonDecode(response.body);
        String errorMessage = responseError['message'];
        EasyLoading.showError(errorMessage,
            duration: const Duration(seconds: 2));
        return response;
      } else {
        EasyLoading.showError(jsonDecode(response.body),
            duration: const Duration(seconds: 2));
        return response;
      }
    } catch (e) {
      EasyLoading.showError("Network is unreachable",
          duration: const Duration(seconds: 3));
      return http.Response(e.toString(), 500);
    }
  }

  Future<void> logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe) {
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_fname');
      await prefs.remove('user_lname');
    } else {
      await prefs.clear();
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil(loginRoutes, (routes) => false);
    await prefs.setBool('loggedIn', false);
  }

  Future<http.Response> signUp(
      firstName, lastName, email, password, context) async {
    EasyLoading.show(status: "loading...");
    final api = Uri.parse('$url/create_user');
    final body = jsonEncode({
      "user_email": email,
      "user_password": password,
      "user_fname": firstName,
      "user_lname": lastName,
    });
    try {
      var response = await http.post(api, headers: header, body: body);
      if (response.body == 'OK') {
        EasyLoading.showSuccess("Signup Successful",
            duration: const Duration(seconds: 2));
        Navigator.of(context)
            .pushNamedAndRemoveUntil(loginRoutes, (route) => false);
        return response;
      } else {
        final responseError = jsonDecode(response.body);
        String errorMessage = responseError['message'];
        EasyLoading.showError(
          errorMessage,
          duration: const Duration(seconds: 2),
        );
        return response;
      }
    } catch (e) {
      EasyLoading.showError("Network is unreachable",
          duration: const Duration(seconds: 3));
      return http.Response(e.toString(), 500);
    }
  }
}
