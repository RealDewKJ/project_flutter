import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class InputForm extends StatelessWidget {
  final String title;
  final TextEditingController value;
  final bool ebscuerText;
  final double leftPadding;
  final double rightPadding;
  final int maxLines;
  final HexColor colorInput;

  const InputForm(
      {super.key,
      required this.title,
      required this.value,
      required this.ebscuerText,
      required this.leftPadding,
      required this.rightPadding,
      required this.maxLines,
      required this.colorInput});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(15),
          child: TextFormField(
            maxLines: maxLines,
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
              fillColor: (colorInput),
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
