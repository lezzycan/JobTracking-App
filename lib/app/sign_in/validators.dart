
abstract class StringValidator{
  bool isValid(String value);
}

class NotEmptyString implements StringValidator{
  @override
  bool isValid(String value){
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidator {
  final StringValidator emailValidators = NotEmptyString();
  final StringValidator passwordValidators = NotEmptyString();
  final String inValidEmail = "Email can't be empty";
  final String inValidPassword = "Password can't be empty";
}