import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;
import 'package:intl/intl.dart';
import 'package:project_flutter_dew/shared/models/todo_model.dart';

class TodoService {
  static Future<List<Todo>> getArticles(int userId) async {
    final headers = {
      'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
        Uri.parse('http://10.0.2.2:6004/api/todo_list/$userId'),
        headers: headers);
    if (response.statusCode == 200) {
      final articleData = jsonDecode(response.body) as List<dynamic>;
      devtools.log(articleData.toString());
      return articleData.map((item) {
        DateTime dateTime = DateTime.parse(item['user_todo_list_last_update']);
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
}
