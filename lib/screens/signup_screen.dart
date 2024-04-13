import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_flutter_dew/components/input_form.dart';
import 'package:project_flutter_dew/constant/routes.dart';

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

  void register(firstName, lastName, email, password) async {
    final url = Uri.parse('http://10.0.2.2:6004/api/create_user');
    final header = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer 950b88051dc87fe3fcb0b4df25eee676',
    };
    final body = jsonEncode({
      "user_email": email,
      "user_password": password,
      "user_fname": firstName,
      "user_lname": lastName,
    });
    try {
      var response = await http.post(url, headers: header, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pushNamed(loginRoutes);
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/signup.png"),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 59,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamedAndRemoveUntil(
                              loginRoutes, (route) => false),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor("#3CB189").withOpacity(0.4),
                        ),
                        child: Icon(
                          Icons.arrow_back_sharp,
                          color: HexColor("#3CB189"),
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 105),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: HexColor("#473B1E")),
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                height: 17,
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
                child: Image(image: Svg("assets/images/iconSignup.svg")),
              ),
              const SizedBox(
                height: 38,
              ),
              InputForm(
                title: "First name",
                value: _firstName,
                ebscuerText: false,
                leftPadding: 40,
                rightPadding: 40,
                maxLines: 1,
                colorInput: HexColor("#F3F3F3"),
              ),
              const SizedBox(
                height: 17,
              ),
              InputForm(
                title: "Last name",
                value: _lastName,
                ebscuerText: false,
                leftPadding: 40,
                rightPadding: 40,
                maxLines: 1,
                colorInput: HexColor("#F3F3F3"),
              ),
              const SizedBox(
                height: 19,
              ),
              InputForm(
                title: "Email",
                value: _email,
                ebscuerText: false,
                leftPadding: 40,
                rightPadding: 40,
                maxLines: 1,
                colorInput: HexColor("#F3F3F3"),
              ),
              const SizedBox(
                height: 17,
              ),
              InputForm(
                title: "Password",
                value: _password,
                ebscuerText: true,
                leftPadding: 40,
                rightPadding: 40,
                maxLines: 1,
                colorInput: HexColor("#F3F3F3"),
              ),
              const SizedBox(
                height: 76,
              ),
              SizedBox(
                width: 339,
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
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
