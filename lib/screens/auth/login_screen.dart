import 'package:flutter/rendering.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_flutter_dew/components/input_form.dart';
import 'package:project_flutter_dew/constant/routes.dart';
import 'package:project_flutter_dew/shared/services/auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
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

  void login(String email, password, context) async {
    await AuthService().login(email, password, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/signup.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 59,
                  ),
                  Center(
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: HexColor("#473B1E")),
                    ),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Center(
                    child: Text(
                      'Please enter the information\nbelow to access.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: HexColor("#473B1E")),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  const Center(
                    child: Image(image: Svg("assets/images/iconSignin.svg")),
                  ),
                  const SizedBox(
                    height: 34,
                  ),
                  InputForm(
                    title: "Email",
                    value: _email,
                    obscureText: false,
                    leftPadding: 40,
                    rightPadding: 40,
                    maxLines: 1,
                    colorInput: HexColor("#F3F3F3"),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  InputForm(
                    title: "Password",
                    value: _password,
                    obscureText: true,
                    leftPadding: 40,
                    rightPadding: 40,
                    maxLines: 1,
                    colorInput: HexColor("#F3F3F3"),
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 46),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: HexColor("#2D2626")),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 76,
                  ),
                  SizedBox(
                    width: 339,
                    height: 70,
                    child: GradientElevatedButton(
                      onPressed: () {
                        login(_email.text.toString(), _password.text.toString(),
                            context);
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
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 339,
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
          ),
        );
      }),
    );
  }
}
