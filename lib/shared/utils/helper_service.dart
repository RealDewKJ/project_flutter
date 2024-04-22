import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project_flutter_dew/screens/todo/todo_screen.dart';
import 'package:project_flutter_dew/shared/constant/routes.dart';
import 'package:project_flutter_dew/shared/services/auth/auth_service.dart';

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

void showDialogWarningMessage(BuildContext context,
    {required String message,
    required String subtitle,
    required VoidCallback onYesPressed}) {
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
          child: const Text("No"),
        ),
        TextButton(
          onPressed: onYesPressed,
          child: const Text("Yes"),
        ),
      ],
    ),
  );
}

class HelperDialog {
  static showBackDialog(context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context);
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  static signOutDialog(context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to signout?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                signOut(context);
              },
            ),
          ],
        );
      },
    );
  }
}
