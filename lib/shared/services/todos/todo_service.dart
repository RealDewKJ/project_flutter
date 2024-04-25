import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;
import 'package:intl/intl.dart';
import 'package:project_flutter_dew/shared/constant/routes.dart';
import 'package:project_flutter_dew/shared/constant/variables.dart';
import 'package:project_flutter_dew/shared/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoService {
  String url = api_url;
  final header = api_header;
  Future<List<Todo>> fetchTodos(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$url/todo_list/$userId'), headers: header);
      if (response.statusCode == 200) {
        final todoData = jsonDecode(response.body) as List<dynamic>;
        return todoData
            .map((item) => Todo(
                  title: item['user_todo_list_title'],
                  content: item['user_todo_list_desc'],
                  date: DateFormat('hh:mm a - dd/MM/yy').format(
                      DateTime.parse(item['user_todo_list_last_update'])
                          .toLocal()),
                  id: item['user_todo_list_id'],
                  isCompleted: item['user_todo_list_completed'],
                ))
            .toList();
      } else {
        EasyLoading.showError("Failed to fetch todos",
            duration: const Duration(seconds: 5));
        return [];
      }
    } catch (e) {
      EasyLoading.showError("Network is unreachable",
          duration: const Duration(seconds: 5));
      return [];
    }
  }

  Future<http.Response> updateTodoStatus(dynamic todo, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      final api = Uri.parse('$url/update_todo');

      final body = jsonEncode({
        "user_todo_list_completed": value,
        "user_todo_list_id": todo.id,
        "user_todo_list_title": todo.title,
        "user_todo_list_desc": todo.content,
        "user_todo_type_id": 1,
        "user_id": userId
      });
      var response = await http.post(api, headers: header, body: body);
      return response;
    } catch (e) {
      EasyLoading.showError("Network is unreachable",
          duration: const Duration(seconds: 3));
      return http.Response('Error', 500);
    }
  }

  Future<http.Response> deleteTodo(int id) async {
    final api = Uri.parse('$url/delete_todo/$id');
    try {
      var response = await http.delete(api, headers: header);
      EasyLoading.showSuccess("Deleted Successful",
          duration: const Duration(seconds: 2));
      return response;
    } catch (e) {
      EasyLoading.showError("Network is unreachable",
          duration: const Duration(seconds: 3));
      return http.Response('Error', 500);
    }
  }

  Future<http.Response> createTodo(
      title, description, isCompleted, userId, context) async {
    final api = Uri.parse('$url/create_todo');
    final header = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
    };
    final body = jsonEncode({
      "user_todo_list_title": title,
      "user_todo_list_desc": description,
      "user_todo_list_completed": isCompleted,
      "user_todo_type_id": 1,
      "user_id": userId
    });
    try {
      var response = await http.post(api, headers: header, body: body);
      if (response.body == 'OK') {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
        EasyLoading.showSuccess("Created Successful",
            duration: const Duration(seconds: 2));
        return response;
      } else {
        final res = jsonDecode(response.body);
        if (res['code'] == 'ER_DATA_TOO_LONG') {
          EasyLoading.showError("Data too long",
              duration: const Duration(seconds: 2));
          return response;
        } else {
          EasyLoading.showError(response.body.toString(),
              duration: const Duration(seconds: 2));
          return response;
        }
      }
    } catch (e) {
      EasyLoading.showError("Network is unreachable",
          duration: const Duration(seconds: 3));
      return http.Response(e.toString(), 500);
    }
  }

  Future<http.Response> updateTodo(
      todoId, title, description, isCompleted, userId, context) async {
    final api = Uri.parse('$url/update_todo');
    final header = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
    };
    final body = jsonEncode({
      "user_todo_list_id": todoId,
      "user_todo_list_title": title,
      "user_todo_list_desc": description,
      "user_todo_list_completed": isCompleted,
      "user_todo_type_id": 1,
      "user_id": userId
    });
    try {
      var response = await http.post(api, headers: header, body: body);
      if (response.body.toString() == 'OK') {
        EasyLoading.showSuccess("Updated Successful",
            duration: const Duration(seconds: 2));
        Navigator.of(context)
            .pushNamedAndRemoveUntil(todoRoutes, (route) => false);
        return response;
      } else {
        final res = jsonDecode(response.body);
        if (res['code'] == 'ER_DATA_TOO_LONG') {
          EasyLoading.showError("Data too long",
              duration: const Duration(seconds: 2));
          return response;
        } else {
          EasyLoading.showError(response.body.toString(),
              duration: const Duration(seconds: 2));
          return response;
        }
      }
    } catch (e) {
      EasyLoading.showError("Network is unreachable",
          duration: const Duration(seconds: 3));
      return http.Response(e.toString(), 500);
    }
  }
}
