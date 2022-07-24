import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_value_notify.dart';
import 'package:time_tracker/app/sign_in/social_signin_button.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker/custom_button_row/sign_in_buttons.dart';
import 'package:time_tracker/constants.dart';
import '../../services/auth.dart';

class SignInValueNotifierPage extends StatelessWidget {
  static const id = 'sign_in';

  const SignInValueNotifierPage({ required this.notify,required this.isLoading, Key? key}) : super(key: key);
 final SignInValueNotify notify;
  final bool isLoading;
  // use a static create(context) method when creating widgets that requires bloc
  static Widget create(BuildContext context) {
    final authbase = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading,__) => Provider<SignInValueNotify>(
            create: (_) => SignInValueNotify(authBase: authbase, isLoading:isLoading),
            child: Consumer<SignInValueNotify>(
              builder: (_, notify, __) => SignInValueNotifierPage(isLoading: isLoading.value, notify: notify,),
            )),
      ),
    );
  }
  void _showErrorAlert(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        exception.code == "ERROR_ABORTED_BY_USER") {
      return;
    }
    showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: exception
    );
  }
  Future<void> _signInAnonymously(context) async {
    try {
      await notify.signInAnonymously();
    } on Exception catch (e) {
      _showErrorAlert(context, e);
    }
  }
  Future<void> _signInWithGoogle(context) async {
    try {
      await notify.signInWithGoogle();
    } on Exception catch (e) {
      _showErrorAlert(context, e);
    }
  }
  Future<void> _signInWithFacebook(context) async {
    try {
      await notify.signInWithFacebook();
    } on Exception catch (e) {
      _showErrorAlert(context, e);
    }
  }
  void _signInWithEmail(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) {
              return const EmailSignInPage() ;
            }));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Time Tracker'),
        centerTitle: true,
        elevation: 5.0,
      ),
      body:  _buildContent(context),
    );
  }
  Widget _buildContent(context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 10, height: 50.0, child: buildHeader()),
          const SizedBox(
            height: 45.0,
          ),
          SocialSignInButton(
            image: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          kSizedBox,
          SocialSignInButton(
            image: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: const Color(0xFF334D92),
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          kSizedBox,
          SocialSignInButton(
            image: 'images/gmail.png',
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          kSizedBox,
          const Text(
            'or',
            style: kTextORStyle,
            textAlign: TextAlign.center,
          ),
          kSizedBox,
          SignInButton(
            child: const Text(
              'Sign in Anonymously',
              style: kTextStyleButton,
            ),

            color: Colors.lime[300],
            //  text: 'Sign in Anonymously',
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }
  Widget buildHeader() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );
    } else {
      return const Text(
        'Sign In',
        style: kTextStyle,
        textAlign: TextAlign.center,
      );
    }
  }
}
