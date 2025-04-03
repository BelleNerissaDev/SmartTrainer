import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/utils/validations.dart';

void main() {
  group('Validations', () {
    test('validateEmail returns false for empty email', () {
      expect(Validations.validateEmail(''), false);
    });

    test('validateEmail returns false for invalid email', () {
      expect(Validations.validateEmail('invalid-email'), false);
    });

    test('validateEmail returns true for valid email', () {
      expect(Validations.validateEmail('test@example.com'), true);
    });

    test('validateNome returns false for empty name', () {
      expect(Validations.validateNome(''), false);
    });

    test('validateNome returns false for invalid name', () {
      expect(Validations.validateNome('John123'), false);
    });

    test('validateNome returns true for valid name', () {
      expect(Validations.validateNome('John Doe'), true);
    });

    test('validateData returns false for empty date', () {
      expect(Validations.validateData(''), false);
    });

    test('validateData returns false for invalid date', () {
      expect(Validations.validateData('31-12-2020'), false);
    });

    test('validateData returns true for valid date', () {
      expect(Validations.validateData('31/12/2020'), true);
    });

    test('validateTelefone returns false for empty phone', () {
      expect(Validations.validateTelefone(''), false);
    });

    test('validateTelefone returns false for invalid phone', () {
      expect(Validations.validateTelefone('1234567890'), false);
    });

    test('validateTelefone returns true for valid phone', () {
      expect(Validations.validateTelefone('(12) 9 3456-7890'), true);
    });
  });
}
