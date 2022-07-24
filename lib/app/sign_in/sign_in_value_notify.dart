import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker/services/auth.dart';

class SignInValueNotify {
  SignInValueNotify({required this.authBase, required this.isLoading});
  final AuthBase authBase;
  final ValueNotifier<bool> isLoading;
  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async =>
      await _signIn((authBase.signInAnonymously));
  Future<User?> signInWithGoogle() async =>
      await _signIn((authBase.signInWithGoogle));
  Future<User?> signInWithFacebook() async =>
      await _signIn((authBase.signInWithFacebook));
}

// when using value notifier, ChangeNotifyProvider is compulsory.
//valueNotifier is use when we need to hold a value and need to inform listeners about the changes.
// Consumer is use to register our widget as a listener so that it can rebuild itself
// ChangeNotifier is useful when we have modal class and we want to modify some listeners when that modal class changes.