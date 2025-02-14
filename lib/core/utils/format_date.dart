import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String formatDateBydMMMMYYYY(DateTime dateTime) {
  initializeDateFormatting('id_ID', null);
  return DateFormat("EEEE, d MMMM yyyy", "id_ID").format(dateTime);
}
