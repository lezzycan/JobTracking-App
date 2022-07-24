import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker/constants.dart';
import 'package:time_tracker/services/auth.dart';
import '../../custom_button_row/form_submit_button.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidator {
  EmailSignInFormStateful({Key? key}) : super(key: key);

  @override
  State<EmailSignInFormStateful> createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool isLoading = false;
// @override
// void initState(){
//   super.initState();
//   _emailController = TextEditingController()..addListener(() {
//     setState(() {
//
//     });
//     _passwordController = TextEditingController()..addListener(() {
//       setState(() {
//
//       });
//     });
//   });
// }  function to listen to controllers
// @override
//   void dispose(){
//   super.dispose();
//   _emailController.dispose();
//   _passwordController.dispose();
// }

  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      isLoading = true;
    });
    try {
      final authBase = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await authBase.signInWithEmailAndPassword(_email, _password);
      } else {
        await authBase.createEmailAndPassword(_email, _password);
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in Failed', exception: e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleForm() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _editingComplete() {
    final newFocus = widget.emailValidators.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool submitEnabled = widget.emailValidators.isValid(_email) &&
        widget.passwordValidators.isValid(_password) &&
        !isLoading;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min, // our form doesn't exceed the content
        children: [
          emailBuildTextField(),
          kSizedBox,
          passwordBuildTextField(),
          kSizedBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FormSubmitButton(
              text: _formType == EmailSignInFormType.signIn
                  ? 'Sign in'
                  : 'Create an account',
              onPressed: submitEnabled ? _submit : null,
              color: Colors.blue,
            ),
          ),
          kSizedBox,
          TextButton(
            onPressed: isLoading == false ? _toggleForm : null,
            child: Text(
              _formType == EmailSignInFormType.signIn
                  ? 'Need an account? Register'
                  : 'Have an account? Sign In',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
  TextField passwordBuildTextField() {
    bool showErrorText =
        _submitted && !widget.emailValidators.isValid(_password);
    return TextField(
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: (_password) {
        updateState();
      },
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.inValidPassword : null,
        enabled: !isLoading,
        // hintText: 'Password',
      ),
      obscureText: true,
    );
  }
  TextField emailBuildTextField() {
    bool showErrorText = _submitted && !widget.emailValidators.isValid(_email);
    return TextField(
      autocorrect: false,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      onEditingComplete: _editingComplete,
      onChanged: (_email) {
        updateState();
      },
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: showErrorText ? widget.inValidEmail : null,
        enabled: !isLoading,
        // hintText: 'Email',
      ),
    );
  }
}
