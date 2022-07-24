import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker/constants.dart';
import '../../custom_button_row/form_submit_button.dart';
import '../../services/auth.dart';
import 'email_sign_in_changeNotifier_model.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier({required this.model, Key? key})
      : super(key: key);
  final EmailSignInModelChangeNotifier model;

  static Widget create(BuildContext context) {
    final authBase = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInModelChangeNotifier>(
      create: (BuildContext context) =>
          EmailSignInModelChangeNotifier(authBase: authBase),
      child: Consumer<EmailSignInModelChangeNotifier>(
        builder: (context, model, __) => EmailSignInFormChangeNotifier(
          model: model,
        ),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInModelChangeNotifier get model => widget.model;

  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in Failed', exception: e);
    }
  }

  void _toggleForm() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _editingComplete() {
    final newFocus = model.emailValidators.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      emailBuildTextField(),
      kSizedBox,
      passwordBuildTextField(),
      kSizedBox,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FormSubmitButton(
          text: model.formButtonText,
          onPressed: model.canSubmit ? _submit : null,
          color: Colors.blue,
        ),
      ),
      kSizedBox,
      TextButton(
        onPressed: !model.isLoading ? _toggleForm : null,
        child: Text(
          model.textButtonText,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min, // our form doesn't exceed the content
        children: _buildChildren(context),
      ),
    );
  }

  TextField passwordBuildTextField() {
    return TextField(
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: model
          .updatePassword, //(password)  => widget.bloc.updateWith(password: password),
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.errorTextPassword,
        enabled: model.isLoading == false,
        // hintText: 'Password',
      ),
      obscureText: true,
    );
  }

  TextField emailBuildTextField() {
    return TextField(
      autocorrect: false,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      onEditingComplete: _editingComplete,
      onChanged:
          model.updateEmail, //(email) => widget.bloc.updateWith(email: email),
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: model.errorTextEmail,
        enabled: model.isLoading == false,
        // hintText: 'Email',
      ),
    );
  }
}
