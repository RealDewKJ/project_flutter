import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TodoCard extends StatefulWidget {
  final String title;
  final String content;
  final String date;
  late bool isCompleted;
  final int id;
  TodoCard(
      {super.key,
      required this.title,
      required this.content,
      required this.date,
      required this.isCompleted,
      required this.id});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool isChecked = false;
  void updateItemStatus(TodoCard widget, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final url = Uri.parse('http://10.0.2.2:6004/api/update_todo');
    Map<String, String> header = {
      "Content-type": "application/json",
      'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
    };
    final body = jsonEncode({
      "user_todo_list_completed": value,
      "user_todo_list_id": widget.id,
      "user_todo_list_title": widget.title,
      "user_todo_list_desc": widget.content,
      "user_todo_type_id": 1,
      "user_id": userId
    });
    try {
      var response = await http.post(url, headers: header, body: body);
      if (response.statusCode == 200) {
        setState(() {
          widget.isCompleted = value;
        });
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 21, right: 17),
      child: SizedBox(
        height: 130,
        width: 390,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                offset: Offset(0, 0),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 23, left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    checkColor: HexColor("FFFFFF"),
                    shape: const CircleBorder(),
                    activeColor: HexColor("#1DC9A0"),
                    value: widget.isCompleted,
                    onChanged: (bool? value) {
                      updateItemStatus(widget, value!);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'outfit',
                            fontWeight: FontWeight.w500,
                            color: HexColor("#0D7A5C")),
                      ),
                      Text(
                        widget.date.toString(),
                        style: TextStyle(
                            fontFamily: 'outfit',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: HexColor("#D9D9D9")),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.content,
                        style: TextStyle(
                            fontFamily: 'outfit',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: HexColor("#666161").withOpacity(0.68)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
