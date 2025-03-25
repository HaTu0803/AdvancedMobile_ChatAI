import 'package:intl/intl.dart';

class ParseDate {
  static String getDMY(String datetime) {
    return datetime.split('T')[0];
  }

  static String parseDateStandard(String date) {
    DateTime parsedDateTime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(date);
    String formattedDateTime =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(parsedDateTime);
    return formattedDateTime;
  }
}
