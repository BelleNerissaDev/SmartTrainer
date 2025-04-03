import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/utils/validations.dart';

void main() {
  group('Validations', () {
    test('validateSenha returns correct validation for a valid password', () {
      String senha = 'Aa1@3456';
      Map<String, bool> result = Validations.validateSenha(senha);

      expect(result['maiuscula'], true);
      expect(result['minuscula'], true);
      expect(result['numero'], true);
      expect(result['caractereEspecial'], true);
      expect(result['oitoCaracteres'], true);
    });

    test('validateSenha returns correct validation for an invalid password',
        () {
      String senha = 'abc';
      Map<String, bool> result = Validations.validateSenha(senha);

      expect(result['maiuscula'], false);
      expect(result['minuscula'], true);
      expect(result['numero'], false);
      expect(result['caractereEspecial'], false);
      expect(result['oitoCaracteres'], false);
    });

    test('validadeSenhasIguais returns true for matching passwords', () {
      String senha = 'password123';
      String confirmaSenha = 'password123';
      bool result = Validations.validadeSenhasIguais(senha, confirmaSenha);

      expect(result, true);
    });

    test('validadeSenhasIguais returns false for non-matching passwords', () {
      String senha = 'password123';
      String confirmaSenha = 'password321';
      bool result = Validations.validadeSenhasIguais(senha, confirmaSenha);

      expect(result, false);
    });
  });
}
