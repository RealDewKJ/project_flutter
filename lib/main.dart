import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:project_flutter_dew/constant/routes.dart';
import 'package:project_flutter_dew/screens/auth/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_flutter_dew/screens/auth/signup_screen.dart';
import 'package:project_flutter_dew/screens/todo/edit_todo_screen.dart';
import 'package:project_flutter_dew/screens/todo/new_todo_screen.dart';
import 'package:project_flutter_dew/screens/todo/todo_screen.dart';
import 'package:project_flutter_dew/shared/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('loggedIn') ?? false;
  devtools.log(isFirstLaunch.toString());
  runApp(MyApp(isFirstLaunch: isFirstLaunch));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MyApp({super.key, required this.isFirstLaunch});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          textTheme: GoogleFonts.outfitTextTheme(),
        ),
        home: isFirstLaunch ? const TodoScreen() : const LoginScreen(),
        routes: {
          loginRoutes: (context) => const LoginScreen(),
          registerRoutes: (context) => const SignupScreen(),
          todoRoutes: (context) => const TodoScreen(),
          newTodoRoutes: (context) => const NewTodoScreen(),
        });
  }
}
