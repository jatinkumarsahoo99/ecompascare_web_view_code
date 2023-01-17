import 'package:ecompasscare/domain/core/value_object.dart';

class EmailAddress extends ValueObject<String> {
  EmailAddress(super.value);

  @override
  String? get validate {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return 'Please enter a valid email address';
    } else {
      return null;
    }
  }
}
