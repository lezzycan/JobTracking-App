import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton(
      {Key? key,
      this.color,
     // this.text,
     // this.textColor = Colors.black,
      this.onPressed,
      this.height = 60,
      this.radius = 8.0,
      this.child})
      : assert(child != null),
        super(
          key: key,
        );
  final Color? color;
 // final Color? textColor;
  //final String? text;
  final VoidCallback? onPressed;
  final double? height;
  final double? radius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(

          style: ElevatedButton.styleFrom(
              primary: color,
             onSurface: color,
              //  onPrimary: color2,  color for text & icon
              elevation: 6.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius!))),
          onPressed: onPressed,
          child: child),
    );

  }

}

