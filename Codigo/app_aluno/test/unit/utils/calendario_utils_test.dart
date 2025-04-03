import 'package:SmartTrainer/utils/calendario_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('generateDateList', () {
    test('should generate date list excluding specified dates', () {
      DateTime startDate = DateTime(2023, 1, 1);
      List<DateTime> excludeDates = [
        DateTime(2023, 1, 3),
        DateTime(2023, 1, 5)
      ];
      List<DateTime> result = generateDateList(startDate, excludeDates);

      expect(result.contains(DateTime(2023, 1, 3)), false);
      expect(result.contains(DateTime(2023, 1, 5)), false);
    });

    test('should generate date list up to current date', () {
      DateTime hoje = DateTime.now();
      DateTime startDate = hoje.subtract(const Duration(days: 5));
      List<DateTime> excludeDates = [];
      List<DateTime> result = generateDateList(startDate, excludeDates);

      expect(result.length, 6);
      expect(result.first, startDate);
      expect(result.last, hoje);
    });

    test('should return empty list if start date is after current date', () {
      DateTime startDate = DateTime.now().add(const Duration(days: 1));
      List<DateTime> excludeDates = [];
      List<DateTime> result = generateDateList(startDate, excludeDates);

      expect(result.isEmpty, true);
    });
  });
}
