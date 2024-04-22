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
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(15),
          child: TextFormField(
            maxLines: widget.maxLines,
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            controller: widget.value,
            autocorrect: false,
            keyboardType: widget.keyboardType,
            obscureText: _obscured,
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
              suffixIcon: widget.obscureText
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _obscured
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
