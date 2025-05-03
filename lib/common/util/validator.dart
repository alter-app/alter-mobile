class Validator {
  static bool validatePhoneNumber(String phoneNumber) {
    final phone = phoneNumber.trim();
    final phoneRegex = RegExp(r'^010-[0-9]{4}-[0-9]{4}$');

    return phoneRegex.hasMatch(phone);
  }

  static bool validateBirthDay(String birthday) {
    final birth = birthday.trim();
    final birthRegex = RegExp(
      r'^(19|20)\d{2}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$',
    );
    return birthRegex.hasMatch(birth);
  }
}
