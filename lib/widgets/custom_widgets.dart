import 'package:flutter/material.dart';

class CustomWidgets {
  static CustomTextField(
    String text,
    TextEditingController controller,
    TextInputType? inputType,
    IconData prefixIcon,
    bool toHide,
    double width,
  ) {
    return SizedBox(
      width: width ?? 300,
      child: TextField(
        controller: controller,
        keyboardType: inputType ?? TextInputType.emailAddress,
        obscureText: toHide,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          labelText: text,
          labelStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  static CustomButton(String text, VoidCallback voidCallback) {
    return SizedBox(
      width: double.maxFinite,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: voidCallback,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static CustomAlertDialog(String message, BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
