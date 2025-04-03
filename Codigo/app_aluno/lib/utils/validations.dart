class Validations {
  static Map<String, bool> validateSenha(String senha) {
    bool hasUppercase = false;
    bool hasLowercase = false;
    bool hasNumber = false;
    bool hasSpecialChar = false;
    bool hasEightChars = false;

    hasEightChars = senha.length >= 8;

    for (int i = 0; i < senha.length; i++) {
      if (senha[i].toUpperCase() != senha[i].toLowerCase()) {
        if (senha[i].toUpperCase() == senha[i]) {
          hasUppercase = true;
        } else {
          hasLowercase = true;
        }
      } else if (int.tryParse(senha[i]) != null) {
        hasNumber = true;
      } else {
        hasSpecialChar = true;
      }
    }

    return {
      'maiuscula': hasUppercase,
      'minuscula': hasLowercase,
      'numero': hasNumber,
      'caractereEspecial': hasSpecialChar,
      'oitoCaracteres': hasEightChars,
    };
  }

  static bool validadeSenhasIguais(String senha, String confirmaSenha) {
    return senha == confirmaSenha;
  }

  static bool validateEmail(String email) {
    if (email.isEmpty) {
      return false;
    }
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool validateNome(String name) {
    if (name.isEmpty) {
      return false;
    }
    final RegExp nameRegex = RegExp(r'^[a-zA-Z ]+$');
    return nameRegex.hasMatch(name);
  }

  static bool validateData(String date) {
    if (date.isEmpty) {
      return false;
    }
    final RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    return dateRegex.hasMatch(date);
  }

  static bool validateTelefone(String phone) {
    if (phone.isEmpty) {
      return false;
    }
    final RegExp phoneRegex = RegExp(r'^\([0-9]+\)\s[0-9]+-[0-9]+');
    return phoneRegex.hasMatch(phone);
  }

  // Validação de valor monetário em reais
  static bool validateValorMonetario(String value) {
    if (value.isEmpty) {
      return false;
    }
    // Regex para validar valores no formato "1.234,56" ou "1234,56"
    final RegExp monetaryRegex = RegExp(r'^\d{1,3}(\.\d{3})*,\d{2}$');
    return monetaryRegex.hasMatch(value);
  }

  // Validação de número inteiro
  static bool validateNumeroInteiro(String value) {
    if (value.isEmpty) {
      return false;
    }
    // Regex para validar números inteiros
    final RegExp integerRegex = RegExp(r'^\d+$');
    return integerRegex.hasMatch(value);
  }
}
