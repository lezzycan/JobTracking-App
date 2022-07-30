import 'package:flutter/material.dart';
import 'package:time_tracker/custom_button_row/sign_in_buttons.dart';

class SocialSignInButton extends SignInButton {
  SocialSignInButton({
    Key? key,
    required String? text,
    required Color? color,
    Color? textColor,
    required VoidCallback? onPressed,
    required String? image,
  }) : assert(text != null),
       assert(image != null),
        super(
          key: key,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                image!,

              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                text!,
                style: TextStyle(color: textColor, fontSize: 20.0),
              ),
              const SizedBox(
                width: 15,
              ),
              Opacity(
                  opacity: 0, child: Image.asset('images/facebook-logo.png')),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
