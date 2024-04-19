import 'package:flutter/rendering.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_flutter_dew/components/input_form.dart';
import 'package:project_flutter_dew/shared/constant/routes.dart';
import 'package:project_flutter_dew/shared/services/auth/auth_service.dart';
import 'package:project_flutter_dew/shared/utils/helper_service.dart';

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

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      setState(() {
        _emailError = 'Please enter Email';
      });
      return false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _emailError = 'Invalid email address';
      });
      return false;
    }
    setState(() {
      _emailError = null;
    });
    return true;
  }

  bool _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      setState(() {
        _passwordError = 'Please enter Password';
      });
      return false;
    } else if (password.trim().length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      return false;
    }
    setState(() {
      _passwordError = null;
    });
    return true;
  }

  void login(String email, password, context) async {
    _validateEmail(email);
    _validatePassword(password);
    if (_emailError == null && _passwordError == null) {
      await AuthService().login(email, password, context);
    } else {
      showErrorMessage(context,
          message: "Plese enter valid email and password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/signup.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Center(
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: HexColor("#473B1E"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 19),
                    Center(
                      child: Text(
                        'Please enter the information\nbelow to access.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: HexColor("#473B1E"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    const Center(
                      child: Image(image: Svg("assets/images/iconSignin.svg")),
                    ),
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
                                  Text(_emailError!,
                                      style:
                                          const TextStyle(color: Colors.red)),
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
                                  Text(_passwordError!,
                                      style:
                                          const TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          const SizedBox(height: 19),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontFamily: 'Outfit',
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
                                login(_email.text.toString(),
                                    _password.text.toString(), context);
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
                                  fontFamily: 'Outfit',
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
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    registerRoutes, (route) => false);
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
                                  fontFamily: 'Outfit',
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
            ],
          ),
        ),
      ),
    );
  }
}
