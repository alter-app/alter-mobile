import 'package:intl/intl.dart';

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

  static String formatNumberWithComma(int number) {
    final formatter = NumberFormat("#,###", "en_US");
    return formatter.format(number);
  }

  static String formatPaymentType(String type) {
    switch (type) {
      case 'HOURLY':
        return '시급';
      case 'DAILY':
        return '일급';
      case 'MONTHLY':
        return '월급';
      default:
        return '기타';
    }
  }

  static String formatDay(String day) {
    switch (day) {
      case 'MONDAY':
        return '월';
      case 'TUESDAY':
        return '화';
      case 'WEDNESDAY':
        return '수';
      case 'THURSDAY':
        return '목';
      case 'FRIDAY':
        return '금';
      case 'SATURDAY':
        return '토';
      case 'SUNDAY':
        return '일';
      default:
        return day;
    }
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}일 전';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months개월 전';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years년 전';
    }
  }
}
