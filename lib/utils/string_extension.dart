import 'package:email_validator/email_validator.dart';

extension StringExtension on String {
  bool get isEmailValid => EmailValidator.validate(this);
}
