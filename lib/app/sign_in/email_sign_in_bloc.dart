import 'dart:async';
import 'package:time_tracker/services/auth.dart';
import 'email_sign_in_model.dart';
class EmailSignInBloc {
  EmailSignInBloc({required this.authBase});
  final AuthBase authBase;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();
  void dispose() {
    _modelController.close();
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? submitted,
    bool? isLoading,
  }) {
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        submitted: submitted,
        isLoading: isLoading);
    _modelController.add(_model);
  }
  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await authBase.signInWithEmailAndPassword(
            _model.email, _model.password);
      } else {
        await authBase.createEmailAndPassword(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
  void toggleFormType(){
    updateWith(
        email: '',
        password: '',
        submitted: false,
        isLoading: false,
        formType: _model.formType == EmailSignInFormType.signIn
            ? EmailSignInFormType.register
            : EmailSignInFormType.signIn
    );
  }
}
