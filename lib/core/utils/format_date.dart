import 'package:intl/intl.dart';

String formatDateBydMMMMYYYY(DateTime dateTime) {
  return DateFormat("EEEE, d MMMM yyyy").format(dateTime);
}
