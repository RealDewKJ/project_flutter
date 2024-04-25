import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_flutter_dew/components/input_form.dart';
import 'package:project_flutter_dew/shared/constant/routes.dart';
import 'package:project_flutter_dew/shared/services/auth/auth_service.dart';
import 'package:project_flutter_dew/shared/utils/validation_error.dart';
import 'dart:developer' as devtools show log;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _password;
  String? _emailError;
  String? _passwordError;
  String? _firstNameError;
  String? _lastNameError;
  @override
  void initState() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
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

  _validateFirstname(String? firstname) {
    final res = validateName(firstname, 'First');
    setState(() {
      _firstNameError = res['message'];
    });
  }

  _validateLastname(String? lastname) {
    final res = validateName(lastname, 'Last');
    setState(() {
      _lastNameError = res['message'];
    });
  }

  register(firstName, lastName, email, password) async {
    _validateEmail(email);
    _validatePassword(password);
    _validateFirstname(firstName);
    _validateLastname(lastName);
    if (_emailError == null &&
        _passwordError == null &&
        _firstNameError == null &&
        _lastNameError == null) {
      await AuthService().signUp(firstName, lastName, email, password, context);
    } else {
      EasyLoading.showError(
        "Please enter all field",
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
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
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    //?
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushNamedAndRemoveUntil(
                                    loginRoutes, (route) => false),
                            child: const Image(
                              image: Svg("assets/images/IconArrowleft.svg"),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 60.0),
                              child: Center(
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: HexColor("#473B1E")),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      Text(
                        'Please enter the information\nbelow to access.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: HexColor("#473B1E")),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      const Image(image: Svg("assets/images/iconSignup.svg")),
                      const SizedBox(
                        height: 38,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          children: [
                            InputForm(
                              title: "First name",
                              value: _firstName,
                              obscureText: false,
                              maxLines: 1,
                              colorInput: HexColor("#F3F3F3"),
                              onValueChanged: _validateFirstname,
                              keyboardType: TextInputType.text,
                              inputAction: TextInputAction.next,
                            ),
                            if (_firstNameError != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(_firstNameError!,
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 17,
                            ),
                            InputForm(
                              title: "Last name",
                              value: _lastName,
                              obscureText: false,
                              maxLines: 1,
                              colorInput: HexColor("#F3F3F3"),
                              onValueChanged: _validateLastname,
                              keyboardType: TextInputType.text,
                              inputAction: TextInputAction.next,
                            ),
                            if (_lastNameError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(_lastNameError!,
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 19,
                            ),
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
                                    Text(_emailError!,
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 17,
                            ),
                            InputForm(
                              title: "Password",
                              value: _password,
                              obscureText: true,
                              maxLines: 1,
                              colorInput: HexColor("#F3F3F3"),
                              onValueChanged: _validatePassword,
                              keyboardType: TextInputType.visiblePassword,
                              inputAction: TextInputAction.done,
                            ),
                            if (_passwordError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(_passwordError!,
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 76,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 70,
                                child: GradientElevatedButton(
                                  onPressed: () {
                                    register(
                                        _firstName.text.toString(),
                                        _lastName.text.toString(),
                                        _email.text.toString(),
                                        _password.text.toString());
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
                                    "SIGN UP",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
