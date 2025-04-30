class Formatter {
  // static String formatDateTime(DateTime dateTime) {
  //   return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  // }

  static String formatPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return "";
    String formatted = '';
    if (phoneNumber.length <= 3) {
      formatted = phoneNumber;
    } else if (phoneNumber.length <= 7) {
      formatted = '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3)}';
    } else {
      formatted =
          '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7, phoneNumber.length.clamp(7, 11))}';
    }
    return formatted;
  }
}
