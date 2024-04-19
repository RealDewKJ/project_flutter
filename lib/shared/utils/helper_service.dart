import 'package:flutter/material.dart';

void showSuccessMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    content: Text(
      message,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showDialogErrorMessage(BuildContext context,
    {required String message, required String subtitle}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(message),
      content: SizedBox(
        height: 30,
        child: Column(
          children: [
            Row(
              children: [
                Text(subtitle),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"))
      ],
    ),
  );
}

void showDialogSuccessMessage(BuildContext context,
    {required String message, required String subtitle}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(message),
      content: const SizedBox(
        height: 30,
        child: Column(
          children: [
            Row(
              children: [
                Text("Please fill in all fields."),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"))
      ],
    ),
  );
}
