import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker/constants.dart';
import '../../custom_button_row/form_submit_button.dart';
import '../../services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  const EmailSignInFormBlocBased({required this.bloc, Key? key})
      : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final authBase = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(authBase: authBase),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
          builder: (_, bloc, __) => EmailSignInFormBlocBased(
                bloc: bloc,
              )),
    );
  }
  @override
  State<EmailSignInFormBlocBased> createState() =>
      _EmailSignInFormBlocBasedState();
}
class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
    try {
      await widget.bloc.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context, title: 'Sign in Failed', exception: e);
    }
  }

  void _toggleForm() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _editingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidators.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren(BuildContext context, EmailSignInModel model) {
    return [
      emailBuildTextField(model),
      kSizedBox,
      passwordBuildTextField(model),
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
    return StreamBuilder<EmailSignInModel>(
        initialData: EmailSignInModel(),
        stream: widget.bloc.modelStream,
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data as EmailSignInModel;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize:
                  MainAxisSize.min, // our form doesn't exceed the content
              children: _buildChildren(context, model),
            ),
          );
        });
  }

  TextField passwordBuildTextField(EmailSignInModel model) {
    return TextField(
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: widget.bloc
          .updatePassword, //(password)  => widget.bloc.updateWith(password: password),
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.errorTextPassword,
        enabled: !model.isLoading,
        // hintText: 'Password',
      ),
      obscureText: true,
    );
  }

  TextField emailBuildTextField(EmailSignInModel model) {
    return TextField(
      autocorrect: false,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      onEditingComplete: () => _editingComplete(model),
      onChanged: widget
          .bloc.updateEmail, //(email) => widget.bloc.updateWith(email: email),
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: model.errorTextEmail,
        enabled: !model.isLoading,
        // hintText: 'Email',
      ),
    );
  }
}
