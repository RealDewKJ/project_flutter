import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_flutter_dew/components/todo_card.dart';
import 'package:project_flutter_dew/shared/constant/routes.dart';
import 'package:project_flutter_dew/shared/models/todo_model.dart';
import 'package:project_flutter_dew/shared/services/auth/auth_service.dart';
import 'package:project_flutter_dew/shared/services/todos/todo_service.dart';
import 'package:project_flutter_dew/shared/utils/helper_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools show log;

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late final TextEditingController _search;
  late Future<List<Todo>> todos = Future.value([]);
  late Future<List<Todo>> searchTodos = Future.value([]);
  String? readFirstname;
  String? readLastname;
  String? fullName;
  int? readUserId;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
    _readUserData();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<List<Todo>> _getTodos(int userId) async {
    return await TodoService().fetchTodos(userId);
  }

  Future<void> deleteById(id) async {
    EasyLoading.show(status: "loading...");
    final res = await TodoService().deleteTodo(id);
    if (res.statusCode == 200) {
      final updatedTodos =
          (await todos).where((todo) => todo.id != id).toList();
      setState(() {
        todos = Future.value(updatedTodos);
        searchTodos = todos;
      });
    } else {
      EasyLoading.showSuccess("Failed to delete",
          duration: const Duration(seconds: 2));
    }
    _search.clear();
  }

  Future<void> updateStatusById(int id, bool value) async {
    try {
      List<Todo> todoList = await todos;
      Todo todoToUpdate = todoList.firstWhere((todo) => todo.id == id);
      todoToUpdate.isCompleted = value.toString();
    } catch (e) {
      EasyLoading.showError("Network is unreachable",
          duration: const Duration(seconds: 5));
    }
  }

  Future<void> _readUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      readFirstname = prefs.getString('user_fname');
      readLastname = prefs.getString('user_lname');
      readUserId = prefs.getInt('user_id');
      fullName =
          '${readFirstname?[0].toUpperCase()}${readFirstname?.substring(1)} ${readLastname?[0].toUpperCase()}${readLastname?.substring(1)}';
    });
    if (readUserId != null) {
      setState(() {
        todos = _getTodos(readUserId!);
        searchTodos = todos;
      });
    }
  }

  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      searchTodos = todos;
    }
    final filteredRes = (await todos)
        .where(
            (todo) => todo.title.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    setState(() {
      searchTodos = Future.value(filteredRes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        HelperDialog.showBackDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _displayBottomSheet(context);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    readFirstname.toString().substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: HexColor('#53CD9F'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello!',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Text(
                      fullName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          toolbarHeight: 100,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromRGBO(76, 197, 153, 1),
                  Color.fromRGBO(13, 122, 92, 1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            //* Search bar
            Container(
              color: HexColor('#D9D9D9').withOpacity(0.09),
              child: Padding(
                padding: const EdgeInsets.only(top: 29.0, bottom: 20.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 18),
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextFormField(
                          onChanged: search,
                          controller: _search,
                          keyboardType: TextInputType.name,
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            icon: const Icon(Icons.search),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.transparent),
                            ),
                            fillColor: (HexColor('#FFFFFF').withOpacity(0.6)),
                            filled: true,
                            hintText: 'Search.......',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: HexColor('#AEAEB2'),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: HexColor('#D9D9D9').withOpacity(0.09),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    onRefresh: () async {
                      List<Todo> updatedTodos = await _getTodos(readUserId!);
                      _search.clear();
                      setState(() {
                        todos = Future.value(updatedTodos);
                        searchTodos = Future.value(updatedTodos);
                      });
                    },
                    child: FutureBuilder<List<Todo>>(
                      future: searchTodos,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          List<Todo>? searchTodos = snapshot.data;
                          if (searchTodos!.isNotEmpty) {
                            return ListView.builder(
                              itemCount: searchTodos.length,
                              itemBuilder: (context, index) {
                                Todo todo = searchTodos[index];
                                return TodoCard(
                                  title: todo.title,
                                  content: todo.content,
                                  date: todo.date,
                                  isCompleted:
                                      todo.isCompleted == 'true' ? true : false,
                                  id: todo.id,
                                  deleteCallback: deleteById,
                                  updateStatusCallback: updateStatusById,
                                );
                              },
                            );
                          } else if (searchTodos.isEmpty &&
                              _search.text.isNotEmpty) {
                            return ListView(
                              children: const [
                                Center(
                                  child: Text(
                                    'Data Not Found.',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return ListView(
                              children: const [
                                Center(
                                  child: Text(
                                    'Empty Data.',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                              ],
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: HexColor('#0D7A5C'),
          onPressed: () {
            Navigator.of(context).pushNamed(newTodoRoutes);
          },
          shape: const CircleBorder(),
          tooltip: 'Increment',
          child: const ImageIcon(
            AssetImage(
              'assets/images/calendar.png',
            ),
            size: 35,
          ),
        ),
      ),
    );
  }
}

Future _displayBottomSheet(BuildContext context) {
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
            height: 10,
          ),
          const ImageIcon(
            AssetImage('assets/images/signoutIcon.png'),
            size: 40,
            color: Colors.grey,
          ),
          Text(
            'SIGN OUT',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: HexColor('#473B1E')),
          ),
          const SizedBox(
            height: 19,
          ),
          Text(
            'Do you want to log out?',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: HexColor('#473B1E')),
          ),
          const SizedBox(
            height: 59,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: GestureDetector(
              onTap: () {
                HelperDialog.signOutDialog(context);
              },
              child: Container(
                color: HexColor('#D9D9D9').withOpacity(0.00),
                child: Center(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        children: [
                          const Image(
                            image: Svg('assets/images/IconLogout.svg'),
                            height: 24,
                            width: 24,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 7),
                            child: Text(
                              'Signout',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: HexColor('#0D7A5C')),
                            ),
                          ),
                          const Spacer(),
                          const Image(
                            image: Svg('assets/images/Arrow.svg'),
                            height: 24,
                            width: 24,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 21,
            indent: 40,
            thickness: 2,
            endIndent: 35,
            color: HexColor('#D9D9D9').withOpacity(0.30),
          ),
        ],
      ),
    ),
  );
}

void signOut(context) async {
  EasyLoading.show(status: "loading...");
  await AuthService().logout(context);
  EasyLoading.showSuccess("Logout Successful",
      duration: const Duration(seconds: 2));
}
