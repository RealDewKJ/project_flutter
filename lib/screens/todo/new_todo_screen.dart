import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_flutter_dew/components/input_form.dart';
import 'package:project_flutter_dew/components/todo_card.dart';
import 'package:project_flutter_dew/shared/constant/routes.dart';
import 'package:project_flutter_dew/shared/services/todos/todo_service.dart';
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
    if (title.length >= 3) {
      if (title.substring(0, 3).trim().isEmpty) {
        setState(() {
          _titleError = 'Title cannot start with spaces';
        });
        return false;
      }
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
    if (description.length >= 3) {
      if (description.substring(0, 3).trim().isEmpty) {
        setState(() {
          _descriptionError = 'Description cannot start with spaces';
        });
        return false;
      }
    }

    setState(() {
      _descriptionError = null;
    });
    return true;
  }

  addTodo(String title, String description, isCompleted, context) async {
    _validateTitle(title);
    _validateDescription(description);
    EasyLoading.show(status: "loading...");
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (title.trim() == '' || description.trim() == '') {
      return EasyLoading.showError("Please enter title and description",
          duration: const Duration(seconds: 2));
    }

    await TodoService()
        .createTodo(title, description, isCompleted, userId, context);
  }

  updateTodo(String title, String description, isCompleted, context) async {
    EasyLoading.show(status: "loading...");
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final todoId = widget.todo!.id;
    if (title.trim() == '' || description.trim() == '') {
      return EasyLoading.showError("Please enter title and description",
          duration: const Duration(seconds: 2));
    }
    await TodoService()
        .updateTodo(todoId, title, description, isCompleted, userId, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(todoRoutes, (route) => false);
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
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
      body: LayoutBuilder(builder: (context, contraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: contraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
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
                          child: InputForm(
                            title: 'Title',
                            value: _title,
                            obscureText: false,
                            maxLines: 1,
                            colorInput: HexColor('#FFFFFF'),
                            onValueChanged: _validateTitle,
                            keyboardType: TextInputType.name,
                            inputAction: TextInputAction.next,
                          ),
                        ),
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
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
                        child: InputForm(
                          title: 'Description',
                          value: _description,
                          obscureText: false,
                          maxLines: 6,
                          colorInput: HexColor('#FFFFFF'),
                          onValueChanged: _validateDescription,
                          keyboardType: TextInputType.name,
                          inputAction: TextInputAction.newline,
                        ),
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
                              padding: const EdgeInsets.only(
                                  left: 19.0, right: 21.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Success',
                                    style: TextStyle(
                                        color: HexColor('#0D7A5C'),
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
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: SizedBox(
                          height: 70,
                          child: GradientElevatedButton(
                            onPressed: () {
                              isEdit
                                  ? updateTodo(
                                      _title.text.toString(),
                                      _description.text.toString(),
                                      isCompleted.toString(),
                                      context)
                                  : addTodo(
                                      _title.text.toString(),
                                      _description.text.toString(),
                                      isCompleted.toString(),
                                      context);
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
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
