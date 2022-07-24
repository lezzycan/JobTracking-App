//INHERITED WIDGET


// import 'package:flutter/material.dart';
// import 'package:time_tracker/services/auth.dart';
//
// class AuthProvider extends InheritedWidget{
//   const AuthProvider({required Widget child, required this.authbase}) : super(child: child);
//
//   final AuthBase authbase;
//  // final Widget child;
//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
//
//   static AuthBase? of (BuildContext context){
//     AuthProvider? authProvider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
//     return authProvider?.authbase;
//   }
//
// }