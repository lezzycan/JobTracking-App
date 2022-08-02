import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({ required this.label, this.colour,  this.onPressed,
    Key? key,
  }) : super(key: key);

  final Color? colour;
  final String label;
  final  VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
        onPressed: onPressed,
        minWidth: 200.0,
        height: 42.0,
        child:Text(
          label, style:const TextStyle( color:Colors.white,),
        ),
        ),
      ),
    );
  }
}
