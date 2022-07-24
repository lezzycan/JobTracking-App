import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    this.title ='Nothing  here',
    this.message =' Add a new item to get started',
    Key? key}) : super(key: key);
  final String? message;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title!, style: const TextStyle(fontSize: 32, color: Colors.black54),),
          Text(message!, style: const TextStyle(fontSize: 16, color: Colors.black54),)
        ],
      ),
    );
  }
}
