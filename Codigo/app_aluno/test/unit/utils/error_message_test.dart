import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/utils/error_message.dart';

void main() {
  group('ErrorMessage', () {
    test(
        '''should create an ErrorMessage with the given message and default error value''',
        () {
      final errorMessage = ErrorMessage(message: 'An error occurred');

      expect(errorMessage.message, 'An error occurred');
      expect(errorMessage.error, false);
    });

    test('should create an ErrorMessage with the given message and error value',
        () {
      final errorMessage =
          ErrorMessage(message: 'An error occurred', error: true);

      expect(errorMessage.message, 'An error occurred');
      expect(errorMessage.error, true);
    });
  });
}
