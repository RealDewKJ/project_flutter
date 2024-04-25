import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_flutter_dew/components/input_form.dart';
import 'package:project_flutter_dew/shared/constant/routes.dart';
import 'package:project_flutter_dew/shared/services/auth/auth_service.dart';
import 'package:project_flutter_dew/shared/utils/validation_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as devtools show log;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String? _emailError;
  String? _passwordError;
  bool _rememberMe = false;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _getRememberMe();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  _setRememberMe(email, password, rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('rememberMe', rememberMe);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', rememberMe);
    }
  }

  _getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('rememberMe') ?? false;
    if (_rememberMe) {
      setState(() {
        _email.text = prefs.getString('email').toString();
        _password.text = prefs.getString('password').toString();
      });
    }
  }

  _validateEmail(String? email) {
    final res = validateEmail(email);
    setState(() {
      _emailError = res['message'];
    });
  }

  _validatePassword(String? password) {
    final res = validatePassword(password);
    setState(() {
      _passwordError = res['message'];
    });
  }

  login(String email, password, BuildContext context, rememberMe) async {
    _validateEmail(email);
    _validatePassword(password);
    EasyLoading.show(status: "loading...");
    if (_emailError == null && _passwordError == null) {
      final res = await AuthService().login(email, password, context);
      if (res.statusCode == 200) {
        _setRememberMe(email, password, rememberMe);
      }
    } else {
      EasyLoading.showError("Plese enter valid email and password",
          duration: const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/signup.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    //?
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'SIGN IN',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: HexColor("#473B1E"),
                        ),
                      ),
                      const SizedBox(height: 19),
                      Text(
                        'Please enter the information\nbelow to access.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: HexColor("#473B1E"),
                        ),
                      ),
                      const SizedBox(height: 35),
                      const Image(image: Svg("assets/images/iconSignin.svg")),
                      const SizedBox(height: 34),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          children: [
                            InputForm(
                              title: "Email",
                              value: _email,
                              obscureText: false,
                              maxLines: 1,
                              colorInput: HexColor("#F3F3F3"),
                              onValueChanged: _validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              inputAction: TextInputAction.next,
                            ),
                            if (_emailError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      _emailError!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 19.0),
                              child: InputForm(
                                title: "Password",
                                value: _password,
                                obscureText: true,
                                maxLines: 1,
                                onValueChanged: _validatePassword,
                                colorInput: HexColor("#F3F3F3"),
                                keyboardType: TextInputType.visiblePassword,
                                inputAction: TextInputAction.done,
                              ),
                            ),
                            if (_passwordError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      _passwordError!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 19),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value!;
                                      });
                                    }),
                                Text(
                                  "Remember Me",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: HexColor("#2D2626"),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 70,
                              child: GradientElevatedButton(
                                onPressed: () {
                                  login(
                                      _email.text.toString(),
                                      _password.text.toString(),
                                      context,
                                      _rememberMe);
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
                                child: const Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 70,
                              child: GradientElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(registerRoutes);
                                },
                                style: GradientElevatedButton.styleFrom(
                                  gradient: LinearGradient(
                                    colors: [
                                      HexColor("#0D7A5C"),
                                      HexColor("#00503E"),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: const Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
