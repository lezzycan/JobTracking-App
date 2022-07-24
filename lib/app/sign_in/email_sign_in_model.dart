import 'package:time_tracker/app/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidator {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.submitted = false,
      this.isLoading = false});

  final String email;
  final String password;
  EmailSignInFormType formType;
  final bool submitted;
  final bool isLoading;


  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? submitted,
    bool? isLoading,
  }) {
    return EmailSignInModel(
        email: email ?? this.email,
        password: password ?? this.password,
        formType: formType ?? this.formType,
        submitted: submitted ?? this.submitted,
        isLoading: isLoading ?? this.isLoading);
  }

  String get formButtonText => formType == EmailSignInFormType.signIn ? 'Sign in' : 'Create an account';
  String get textButtonText => formType == EmailSignInFormType.signIn
      ? 'Need an account ?Register'
      : 'Have an account? Sign In';

  bool get canSubmit =>
      emailValidators.isValid(email) &&
      passwordValidators.isValid(password) &&
      !isLoading;
  String? get errorTextPassword {
     bool showErrorText =  submitted && !emailValidators.isValid(password);
  return showErrorText ? inValidPassword : null;
  }
  String? get errorTextEmail {
   bool showErrorText =  submitted && !emailValidators.isValid(email);
  return showErrorText ? inValidEmail : null;
  }
}
