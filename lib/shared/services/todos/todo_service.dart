import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;
import 'package:intl/intl.dart';
import 'package:project_flutter_dew/shared/constant/variables.dart';
import 'package:project_flutter_dew/shared/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoService {
  String url = api_url;
  final header = {
    "Content-type": "application/json",
    'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
  };
  Future<List<Todo>> fetchTodos(int userId) async {
    final response =
        await http.get(Uri.parse('$url/todo_list/$userId'), headers: header);
    if (response.statusCode == 200) {
      final todoData = jsonDecode(response.body) as List<dynamic>;
      return todoData.map((item) {
        DateTime dateTime =
            DateTime.parse(item['user_todo_list_last_update']).toLocal();
        String formattedDate =
            DateFormat('hh:mm a - dd/MM/yy').format(dateTime);
        return Todo(
          title: item['user_todo_list_title'],
          content: item['user_todo_list_desc'],
          date: formattedDate,
          id: item['user_todo_list_id'],
          isCompleted: item['user_todo_list_completed'],
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch articles');
    }
  }

  Future<http.Response> updateTodoStatus(dynamic todo, bool value) async {
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
    try {
      var response = await http.post(api, headers: header, body: body);
      return response;
    } catch (e) {
      devtools.log(e.toString());
      throw Exception('Error updating todo');
    }
  }

  Future<http.Response> deleteTodo(int id) async {
    final api = Uri.parse('$url/delete_todo/$id');
    try {
      var response = await http.delete(api, headers: header);
      return response;
    } catch (e) {
      devtools.log(e.toString());
      throw Exception('Error deleting todo');
    }
  }

  Future<int> createTodo(title, description, isCompleted, userId) async {
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
        return response.statusCode;
      } else {
        return 404;
      }
    } catch (e) {
      devtools.log(e.toString());
      return throw Exception('Error creating todo');
    }
  }

  Future<int> updateTodo(
      todoId, title, description, isCompleted, userId) async {
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
      devtools.log(response.body.toString());
      if (response.body.toString() == 'OK') {
        return response.statusCode;
      } else {
        return 404;
      }
    } catch (e) {
      devtools.log(e.toString());
      return throw Exception('Error updated todo');
    }
  }
}
