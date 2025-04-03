String formatDate(DateTime date, {bool showHora = false}) {
  String dataFormatada = '';
  if (showHora) {
    dataFormatada +=
        '''${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')} - ''';
  }
  dataFormatada +=
      '''${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}''';
  return dataFormatada;
}

String formatTime(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$remainingSeconds';
}
