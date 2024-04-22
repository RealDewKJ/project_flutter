import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project_flutter_dew/shared/constant/routes.dart';
import 'package:project_flutter_dew/screens/auth/login_screen.dart';
import 'package:project_flutter_dew/screens/auth/signup_screen.dart';
import 'package:project_flutter_dew/screens/todo/new_todo_screen.dart';
import 'package:project_flutter_dew/screens/todo/todo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('loggedIn') ?? false;
  devtools.log(isLoggedIn.toString());
  runApp(MyApp(isLoggedIn: isLoggedIn));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'outfit',
      ),
      home: isLoggedIn ? const TodoScreen() : const LoginScreen(),
      routes: {
        loginRoutes: (context) => const LoginScreen(),
        registerRoutes: (context) => const SignupScreen(),
        todoRoutes: (context) => const TodoScreen(),
        newTodoRoutes: (context) => const NewTodoScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
