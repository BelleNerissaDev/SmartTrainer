import 'package:SmartTrainer/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatDate', () {
    test('formats date without time', () {
      final date = DateTime(2023, 10, 5);
      final formattedDate = formatDate(date);
      expect(formattedDate, '05-10-2023');
    });

    test('formats date with time', () {
      final date = DateTime(2023, 10, 5, 14, 30, 45);
      final formattedDate = formatDate(date, showHora: true);
      expect(formattedDate, '14:30:45 - 05-10-2023');
    });
  });

  group('formatTime', () {
    test('formats time correctly', () {
      final formattedTime = formatTime(125);
      expect(formattedTime, '02:05');
    });

    test('formats time with zero seconds', () {
      final formattedTime = formatTime(0);
      expect(formattedTime, '00:00');
    });

    test('formats time with exact minutes', () {
      final formattedTime = formatTime(120);
      expect(formattedTime, '02:00');
    });
  });
}
