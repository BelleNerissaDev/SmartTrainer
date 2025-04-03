import 'package:intl/intl.dart';

String formatDate(String date) {
  try {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  } catch (e) {
    return 'Data inválida';
  }
}

String formatDateTime(DateTime date) {
  try {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  } catch (e) {
    return 'Data inválida';
  }
}
