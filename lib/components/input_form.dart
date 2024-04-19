import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class InputForm extends StatefulWidget {
  final String title;
  final TextEditingController value;
  final bool obscureText;
  final int maxLines;
  final HexColor colorInput;
  final ValueChanged<String> onValueChanged;
  final TextInputType keyboardType;
  final TextInputAction inputAction;

  const InputForm(
      {super.key,
      required this.title,
      required this.value,
      required this.obscureText,
      required this.maxLines,
      required this.colorInput,
      required this.onValueChanged,
      required this.keyboardType,
      required this.inputAction});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(15),
          child: TextFormField(
            maxLines: widget.maxLines,
            controller: widget.value,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            onChanged: widget.onValueChanged,
            textInputAction: widget.inputAction,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              fillColor: (widget.colorInput),
              filled: true,
              hintText: widget.title,
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
