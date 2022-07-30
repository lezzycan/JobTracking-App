import 'package:flutter/material.dart';
import 'package:time_tracker/custom_button_row/sign_in_buttons.dart';

class FormSubmitButton extends SignInButton{
  FormSubmitButton({Key? key,
    required String? text,
    Color? color,
    Color? textColor,
    VoidCallback? onPressed,
    double? height = 65,
}) : super(key: key,
    child: Text(text!,
    style:  const TextStyle(
      fontSize: 25,
      color: Colors.white,
    ),

    ),
    onPressed: onPressed,
    color: color,
    height: height,
  );
}
