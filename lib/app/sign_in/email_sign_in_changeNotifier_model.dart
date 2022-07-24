import 'package:flutter/cupertino.dart';
import 'package:time_tracker/app/sign_in/validators.dart';

import '../../services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInModelChangeNotifier
    with EmailAndPasswordValidator, ChangeNotifier {
  EmailSignInModelChangeNotifier(
      {required this.authBase,
      this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.submitted = false,
      this.isLoading = false});

  final AuthBase authBase;
  String email;
  String password;
  EmailSignInFormType formType;
  bool submitted;
  bool isLoading;

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? submitted,
    bool? isLoading,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.submitted = submitted ?? this.submitted;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await authBase.signInWithEmailAndPassword(email, password);
      } else {
        await authBase.createEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
        email: '',
        password: '',
        submitted: false,
        isLoading: false,
        formType: formType);
  }

  String get formButtonText =>
      formType == EmailSignInFormType.signIn
          ? 'Sign in'
          : 'Create an account';
  String get textButtonText =>
      formType == EmailSignInFormType.signIn
      ? 'Need an account ?Register'
      : 'Have an account? Sign In';

  bool get canSubmit =>
      emailValidators.isValid(email) &&
      passwordValidators.isValid(password) &&
      !isLoading;
  String? get errorTextPassword {
    bool showErrorText = submitted && !emailValidators.isValid(password);
    return showErrorText ? inValidPassword : null;
  }

  String? get errorTextEmail {
    bool showErrorText = submitted && !emailValidators.isValid(email);
    return showErrorText ? inValidEmail : null;
  }
}
