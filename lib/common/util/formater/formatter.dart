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

  static String calculateWorkHours(String startTimeStr, String endTimeStr) {
    int parseTimeToMinutes(String timeStr) {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return hour * 60 + minute;
    }

    final int startMinutes = parseTimeToMinutes(startTimeStr);
    final int endMinutes = parseTimeToMinutes(endTimeStr);

    int durationMinutes;

    // 종료 시간이 시작 시간보다 작은 경우 (자정을 넘어가는 경우)
    if (endMinutes < startMinutes) {
      // 다음 날로 넘어간 것으로 간주하여 24시간(1440분)을 더해줍니다.
      durationMinutes = (24 * 60 - startMinutes) + endMinutes;
    } else {
      // 일반적인 경우, 단순한 시간 차이를 계산합니다.
      durationMinutes = endMinutes - startMinutes;
    }

    String minutesToString(int totalMinutes) {
      final hour = totalMinutes ~/ 60;
      final minute = totalMinutes % 60;

      if (hour > 0 && minute > 0) {
        return "$hour시간 $minute분";
      } else if (hour > 0) {
        return "$hour시간";
      } else if (minute > 0) {
        return "$minute분";
      } else {
        return "0시간";
      }
    }

    return minutesToString(durationMinutes);
  }
}
