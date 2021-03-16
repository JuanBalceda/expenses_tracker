import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DtTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function onSubmit;
  final String label;

  DtTextField(
      {required this.controller,
      required this.onSubmit,
      required this.label,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    var platForm = Theme.of(context).platform;
    var isIOS = platForm == TargetPlatform.iOS;

    return isIOS
        ? CupertinoTextField(
            placeholder: label,
            controller: controller,
            onSubmitted: (txt) => onSubmit(txt),
            keyboardType: keyboardType,
          )
        : TextField(
            decoration: InputDecoration(
              labelText: label,
            ),
            controller: controller,
            onSubmitted: (txt) => onSubmit(txt),
            keyboardType: keyboardType,
          );
  }
}
