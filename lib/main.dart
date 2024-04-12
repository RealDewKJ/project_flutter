import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:project_flutter_dew/constant/routes.dart';
import 'package:project_flutter_dew/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_flutter_dew/screens/signup_screen.dart';
import 'package:project_flutter_dew/screens/todo/new_todo_screen.dart';
import 'package:project_flutter_dew/screens/todo/todo_screen.dart';
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
          // colorScheme: const ColorScheme.light(
          //     background: Colors.white,
          //     onBackground: Colors.black,
          //     primary: Color.fromRGBO(255, 255, 255, 1),
          //     onPrimary: Color.fromARGB(255, 82, 223, 139),
          //     secondary: Color.fromRGBO(139, 220, 200, 1),
          //     onSecondary: Colors.white,
          //     tertiary: Color.fromRGBO(139, 228, 200, 1),
          //     error: Colors.red,
          //     outline: Color(0xFF424242)),
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
