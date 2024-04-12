import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class InputForm extends StatelessWidget {
  final String title;
  final TextEditingController value;
  final bool ebscuerText;

  const InputForm(
      {super.key,
      required this.title,
      required this.value,
      required this.ebscuerText});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 40.0, right: 40),
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(15),
          child: TextField(
            controller: value,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            obscureText: ebscuerText,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              fillColor: HexColor("#F3F3F3"),
              filled: true,
              hintText: title,
              hintStyle: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w500,
                color: HexColor("#666161"),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
