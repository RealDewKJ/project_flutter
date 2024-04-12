import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_flutter_dew/components/todo_card.dart';
import 'package:project_flutter_dew/constant/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class Article {
  final String title;
  final String content;
  final String date;
  final String isCompleted;
  final int id;

  Article(
      {required this.title,
      required this.content,
      required this.date,
      required this.isCompleted,
      required this.id});
}

class _TodoScreenState extends State<TodoScreen> {
  late Future<List<Article>> articles = Future.value([]);
  String? readFirstname;
  String? firstCharFirstName;
  String? readLastname;
  String? fullName;
  String? isCompleted;
  int? readUserId;

  @override
  void initState() {
    super.initState();
    _readUserData();
  }

  Future<List<Article>> _getArticles(int userId) async {
    final headers = {
      'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
        Uri.parse('http://10.0.2.2:6004/api/todo_list/${userId}'),
        headers: headers);
    if (response.statusCode == 200) {
      final articleData = jsonDecode(response.body) as List<dynamic>;
      devtools.log(articleData.toString());
      return articleData.map((item) {
        DateTime dateTime = DateTime.parse(item['user_todo_list_last_update']);
        String formattedDate =
            DateFormat('hh:mm a - dd/MM/yy').format(dateTime);
        return Article(
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

  Future<void> _readUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      readFirstname = prefs.getString('user_fname');
      firstCharFirstName = readFirstname?.substring(0, 1);
      readLastname = prefs.getString('user_lname');
      readUserId = prefs.getInt('user_id');
      fullName =
          '${readFirstname?[0].toUpperCase()}${readFirstname?.substring(1)} $readLastname';
    });

    if (readUserId != null) {
      setState(() {
        articles = _getArticles(readUserId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  firstCharFirstName.toString().toUpperCase(),
                  style: TextStyle(
                      fontFamily: 'outfit',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: HexColor("#53CD9F")),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello!',
                  style: TextStyle(
                      fontFamily: 'outfit',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Text(
                  fullName ?? '',
                  style: const TextStyle(
                      fontFamily: 'outfit',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
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
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(217, 217, 217, 0.09),
          ),
          child: FutureBuilder<List<Article>>(
            future: articles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<Article>? articles = snapshot.data;
                if (articles != null) {
                  // You can loop through articles and display them
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      Article article = articles[index];
                      return TodoCard(
                        title: article.title,
                        content: article.content,
                        date: article.date,
                        isCompleted:
                            article.isCompleted == "true" ? true : false,
                        id: article.id,
                      );
                    },
                  );
                }
                ;
                // const SingleChildScrollView(
                //   child: Column(
                //     children: <Widget>[TodoCard()],
                //   ),
                // );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#0D7A5C"),
        onPressed: () async {
          Navigator.of(context).pushNamed(newTodoRoutes);
        },
        shape: const CircleBorder(),
        tooltip: 'Increment',
        child: const ImageIcon(AssetImage("assets/images/calendar.png")),
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
                  height: 18,
                ),
                const ImageIcon(
                  AssetImage("assets/images/signoutIcon.png"),
                ),
                const SizedBox(
                  height: 23,
                ),
                Text(
                  "SIGN OUT",
                  style: TextStyle(
                      fontFamily: 'outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: HexColor("#473B1E")),
                ),
                const SizedBox(
                  height: 19,
                ),
                Text(
                  "Do you want to log out?",
                  style: TextStyle(
                      fontFamily: 'outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HexColor("#473B1E")),
                ),
                const SizedBox(
                  height: 59,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      signOut(context);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: HexColor("#3CB189").withOpacity(0.4),
                            ),
                            child: Icon(
                              Icons.arrow_back_sharp,
                              color: HexColor("#3CB189"),
                              size: 15,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            'Signout',
                            style: TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: HexColor("#0D7A5C")),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.only(left: 236),
                            child: const Icon(Icons.chevron_right)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
}

signOut(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.of(context).pushNamedAndRemoveUntil(loginRoutes, (routes) => false);
  await prefs.setBool('loggedIn', false);
}

//TODO Logout Code
// child: Center(
//             child: TextButton(
//               onPressed: () async {
//                 final prefs = await SharedPreferences.getInstance();
//                 await prefs.clear();
//                 Navigator.of(context).pushNamed(loginRoutes);
//               },
//               child:
//                   const Text('Logout', style: TextStyle(color: Colors.black)),
//             ),
//           ),
