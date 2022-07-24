import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

abstract class AuthBase {
  User? get user;
  Future<User?> signInAnonymously();
  Future<void> signOut();
  Stream<User?> authStateChanges();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithFacebook();
  Future<User?> signInWithEmailAndPassword(
      String email, String password);
  Future<User?> createEmailAndPassword(String email, String password);
}

class Auth implements AuthBase {
  final _auth = FirebaseAuth.instance;
  @override
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  @override
  User? get user => _auth.currentUser;
  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _auth.signInAnonymously();
    return userCredentials.user;
  }
@override
  Future<User?> createEmailAndPassword(String email, String password) async {
    final userCredentials = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredentials.user;
  }
@override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredentials = await _auth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
    return userCredentials.user;
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser =
        await googleSignIn.signIn(); // signIn with google account
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      final userCredentials = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken));
      return userCredentials.user;
    } else {
      throw FirebaseAuthException(
          code: 'ERROR ABORTED BY USER', message: 'SIGN IN ABORTED BY USER');
    }
  }

  @override
  Future<User?> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredentials = await _auth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken!.token));
        return userCredentials.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
            code: 'ERROR_ABORTED_BY_USER', message: 'SIGN_ABORTED_BY_USER');
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
            code: 'ERROR_LOGIN_FAILED',
            message: response.error!.developerMessage);
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final fb = FacebookLogin();
    await fb.logOut();
    await _auth.signOut();
  }
}
