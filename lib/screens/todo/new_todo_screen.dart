import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NewTodoScreen extends StatefulWidget {
  const NewTodoScreen({super.key});

  @override
  State<NewTodoScreen> createState() => _NewTodoScreenState();
}

class _NewTodoScreenState extends State<NewTodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Your Todo",
          style: TextStyle(
              fontFamily: 'outfit',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white),
        ),
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                HexColor("#4CC599"),
                HexColor("#0D7A5C"),
              ],
            ),
          ),
        ),
      ),
      body: Container(decoration: BoxDecoration(color: HexColor("#D9D9D9"))),
    );
  }
}
