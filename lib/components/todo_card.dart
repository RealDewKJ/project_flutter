import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:project_flutter_dew/constant/routes.dart';
import 'package:project_flutter_dew/screens/todo/new_todo_screen.dart';
import 'package:project_flutter_dew/shared/models/todo_model.dart';
import 'package:project_flutter_dew/shared/services/todos/todo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools show log;

class TodoCard extends StatefulWidget {
  final String title;
  final String content;
  final String date;
  late bool isCompleted;
  final int id;
  final Function(int) deleteCallback;
  TodoCard({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    required this.isCompleted,
    required this.id,
    required this.deleteCallback,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  void updateItemStatus(TodoCard widget, bool value) async {
    final res = await TodoService().updateTodo(widget, value);
    if (res.statusCode == 200) {
      setState(() {
        widget.isCompleted = value;
      });
    } else {
      devtools.log('failed');
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
          child: Stack(
            children: [
              Container(
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
                    Expanded(
                      child: Padding(
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
                                color: HexColor("#0D7A5C"),
                              ),
                            ),
                            Text(
                              widget.date.toString(),
                              style: TextStyle(
                                fontFamily: 'outfit',
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: HexColor("#D9D9D9"),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 11.0),
                                child: Text(
                                  widget.content,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontFamily: 'outfit',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color:
                                        HexColor("#666161").withOpacity(0.68),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 13.0, right: 13.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      _displayBottomSheet(context, widget);
                    },
                    child: const Icon(Icons.more_horiz),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future _displayBottomSheet(BuildContext context, widget) {
  return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) => SizedBox(
            height: 250,
            width: 428,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                const ImageIcon(
                  AssetImage("assets/images/signoutIcon.png"),
                ),
                const SizedBox(
                  height: 56,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      // Navigator.of(context)
                      //     .pushNamed(editTodoRoutes, arguments: widget);
                      navigateToEditPage(context, widget);
                    },
                    child: Container(
                      color: HexColor("#D9D9D9").withOpacity(0.00),
                      child: Row(
                        children: [
                          const Image(
                            image: Svg("assets/images/IconEdit.svg"),
                            height: 24,
                            width: 24,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 7),
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: HexColor("#0D7A5C")),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.only(left: 261),
                              child: const Image(
                                image: Svg("assets/images/Arrow.svg"),
                                height: 24,
                                width: 24,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      widget.deleteCallback(widget.id);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      color: HexColor("#D9D9D9").withOpacity(0.00),
                      child: Row(
                        children: [
                          const Image(
                            image: Svg("assets/images/IconTrash.svg"),
                            height: 24,
                            width: 24,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 7),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: HexColor("#0D7A5C")),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.only(left: 243),
                              child: const Image(
                                image: Svg("assets/images/Arrow.svg"),
                                height: 24,
                                width: 24,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
}

void navigateToEditPage(context, widget) {
  final route = MaterialPageRoute(
    builder: (context) => NewTodoScreen(todo: widget),
  );
  Navigator.push(context, route);
}
