import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_flutter_dew/components/input_form.dart';
import 'package:http/http.dart' as http;
import 'package:project_flutter_dew/components/todo_card.dart';
import 'package:project_flutter_dew/constant/routes.dart';
import 'dart:developer' as devtools show log;

import 'package:shared_preferences/shared_preferences.dart';

class NewTodoScreen extends StatefulWidget {
  final TodoCard? todo;

  const NewTodoScreen({super.key, this.todo});
  @override
  State<NewTodoScreen> createState() => _NewTodoScreenState();
}

class _NewTodoScreenState extends State<NewTodoScreen> {
  late final TextEditingController _title;
  late final TextEditingController _description;
  bool isCompleted = false;
  bool isEdit = false;

  @override
  void initState() {
    _title = TextEditingController();
    _description = TextEditingController();
    if (widget.todo != null) {
      isEdit = true;
      final title = widget.todo!.title;
      final description = widget.todo!.content;
      _title.text = title;
      _description.text = description;
      isCompleted = widget.todo!.isCompleted;
    }
    devtools.log(isEdit.toString());
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  void addTodo(String title, String description, isCompleted) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (title.isEmpty || description.isEmpty) {
      return showErrorMessage('Please enter title and description');
    }
    final url = Uri.parse('http://10.0.2.2:6004/api/create_todo');
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
      var response = await http.post(url, headers: header, body: body);
      if (response.body == 'OK') {
        showSuccessMessage('Create Successful');
        Navigator.of(context)
            .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
      } else {
        showErrorMessage("Failed to Creation");
      }
    } catch (e) {
      devtools.log(e.toString());
    }
  }

  void updateTodo(String title, description, isCompleted) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final todoId = widget.todo!.id;
    final url = Uri.parse('http://10.0.2.2:6004/api/update_todo');
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
      var response = await http.post(url, headers: header, body: body);
      if (response.body == 'OK') {
        showSuccessMessage('Updated Successful');
        Navigator.of(context)
            .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
      } else {
        showErrorMessage("Failed to Update");
      }
    } catch (e) {
      devtools.log(e.toString());
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Your Todo' : 'Add Your Todo',
          style: const TextStyle(
              fontFamily: 'outfit',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white),
        ),
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                HexColor("#4CC599"),
                HexColor("#0D7A5C"),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: HexColor("#D9D9D9").withOpacity(0.09),
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Form(
            child: Column(
              children: [
                InputForm(
                  title: "Title",
                  value: _title,
                  obscureText: false,
                  leftPadding: 21,
                  rightPadding: 18,
                  maxLines: 1,
                  colorInput: HexColor("#FFFFFF"),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputForm(
                  title: "Description",
                  value: _description,
                  obscureText: false,
                  leftPadding: 21,
                  rightPadding: 18,
                  maxLines: 6,
                  colorInput: HexColor("#FFFFFF"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 21, right: 18),
                  child: SizedBox(
                    height: 59,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            offset: Offset(0, 0),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 19),
                        child: Row(
                          children: [
                            Text(
                              "Success",
                              style: TextStyle(
                                  color: HexColor("#0D7A5C"),
                                  fontFamily: 'outfit',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 230.0),
                              child: Switch(
                                value: isCompleted,
                                activeColor: Colors.green,
                                onChanged: (bool value) {
                                  setState(() {
                                    isCompleted = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding bottom

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 19.0),
                        child: SizedBox(
                          height: 70,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    21), // Set padding for left and right
                            child: GradientElevatedButton(
                              onPressed: () {
                                isEdit
                                    ? updateTodo(
                                        _title.text.toString(),
                                        _description.text.toString(),
                                        isCompleted.toString(),
                                      )
                                    : addTodo(
                                        _title.text.toString(),
                                        _description.text.toString(),
                                        isCompleted.toString(),
                                      );
                              },
                              style: GradientElevatedButton.styleFrom(
                                gradient: LinearGradient(
                                  colors: [
                                    HexColor("#53CD9F"),
                                    HexColor("#0D7A5C"),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              child: const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
