import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_flutter_dew/components/input_form.dart';
import 'package:http/http.dart' as http;
import 'package:project_flutter_dew/components/todo_card.dart';
import 'package:project_flutter_dew/shared/constant/routes.dart';
import 'package:project_flutter_dew/shared/services/todos/todo_service.dart';
import 'package:project_flutter_dew/shared/utils/helper_service.dart';
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
  String? _titleError;
  String? _descriptionError;

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

  bool _validateTitle(String? title) {
    if (title == null || title.isEmpty) {
      setState(() {
        _titleError = 'Please Enter Title';
      });
      return false;
    }
    setState(() {
      _titleError = null;
    });
    return true;
  }

  bool _validateDescription(String? description) {
    if (description == null || description.isEmpty) {
      setState(() {
        _descriptionError = 'Please Enter Description';
      });
      return false;
    }
    setState(() {
      _descriptionError = null;
    });
    return true;
  }

  void addTodo(String title, String description, isCompleted) async {
    _validateTitle(title);
    _validateDescription(description);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (title.trim() == '' || description.trim() == '') {
      return showErrorMessage(context,
          message: 'Please enter title and description');
    }

    var res =
        await TodoService().createTodo(title, description, isCompleted, userId);
    if (res == 200) {
      showSuccessMessage(context, message: 'Create Successful');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
    } else {
      showErrorMessage(context, message: 'Failed to Creation');
    }
  }

  void updateTodo(String title, String description, isCompleted) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final todoId = widget.todo!.id;
    if (title.trim() == '' || description.trim() == '') {
      return showErrorMessage(context,
          message: 'Please enter title and description');
    }

    var res = await TodoService()
        .updateTodo(todoId, title, description, isCompleted, userId);
    if (res == 200) {
      showSuccessMessage(context, message: 'Updated Successful');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(todoRoutes, (routes) => false);
    } else {
      showErrorMessage(context, message: 'Failed to Update');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 21.0),
            child: Image(
              image: Svg("assets/images/IconArrowleft.svg"),
              color: Colors.white,
            ),
          ),
        ),
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
                HexColor('#4CC599'),
                HexColor('#0D7A5C'),
              ],
            ),
          ),
        ),
      ),
      body:
          // Expanded(
          //   child: ListView(
          //     children: [
          Container(
        decoration: BoxDecoration(
          color: HexColor('#D9D9D9').withOpacity(0.09),
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 10, left: 21, right: 17),
          child: Form(
            child: ListView(
              children: [
                InputForm(
                  title: 'Title',
                  value: _title,
                  obscureText: false,
                  maxLines: 1,
                  colorInput: HexColor('#FFFFFF'),
                  onValueChanged: _validateTitle,
                  keyboardType: TextInputType.name,
                  inputAction: TextInputAction.next,
                ),
                if (_titleError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(_titleError!,
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                InputForm(
                  title: 'Description',
                  value: _description,
                  obscureText: false,
                  maxLines: 6,
                  colorInput: HexColor('#FFFFFF'),
                  onValueChanged: _validateDescription,
                  keyboardType: TextInputType.name,
                  inputAction: TextInputAction.done,
                ),
                if (_descriptionError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(_descriptionError!,
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
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
                        padding: const EdgeInsets.only(left: 19.0, right: 21.0),
                        child: Row(
                          children: [
                            Text(
                              'Success',
                              style: TextStyle(
                                  color: HexColor('#0D7A5C'),
                                  fontFamily: 'outfit',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            const Spacer(),
                            CupertinoSwitch(
                              value: isCompleted,
                              activeColor: Colors.green,
                              onChanged: (bool value) {
                                setState(() {
                                  isCompleted = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //       ),
        //     ],
        //   ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 19.0, left: 18, right: 21),
        child: SizedBox(
          height: 70,
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
                  HexColor('#53CD9F'),
                  HexColor('#0D7A5C'),
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
                'Save',
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
    );
  }
}
