import 'package:SmartTrainer/components/botao.dart';
import 'package:SmartTrainer/components/stack_bar/snack_bar.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/pages/controller/redefinir_senha_controller.dart';
import 'package:SmartTrainer/utils/error_message.dart';
import 'package:SmartTrainer/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RedefinirSenhaPage extends StatefulWidget {
  final bool inTest;
  const RedefinirSenhaPage({Key? key, this.inTest = false}) : super(key: key);

  @override
  _RedefinirSenhaPageState createState() => _RedefinirSenhaPageState();
}

class _RedefinirSenhaPageState extends State<RedefinirSenhaPage> {
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();
  bool senhaShowErrors = false;
  final senhaErrors = <String, ErrorMessage>{
    'geral': ErrorMessage(message: 'Sua senha deve conter:', error: true),
    'oitoCaracteres':
        ErrorMessage(message: '- Pelo menos 8 caracteres', error: true),
    'maiuscula': ErrorMessage(message: '- Uma letra maiúscula', error: true),
    'minuscula': ErrorMessage(message: '- Uma letra minúscula', error: true),
    'numero': ErrorMessage(message: '- Um número', error: true),
    'caractereEspecial':
        ErrorMessage(message: '- Um caractere especial', error: true),
  };

  bool confirmaSenhaShowErrors = false;
  final confirmaSenhaErrors = <String, ErrorMessage>{
    'geral': ErrorMessage(message: 'As senhas não coincidem', error: true),
  };

  void listeners() {
    _senhaController.addListener(() {
      final senha = _senhaController.text;
      final errors = Validations.validateSenha(senha);
      setState(() {
        senhaErrors['oitoCaracteres']!.error = !errors['oitoCaracteres']!;
        senhaErrors['maiuscula']!.error = !errors['maiuscula']!;
        senhaErrors['minuscula']!.error = !errors['minuscula']!;
        senhaErrors['numero']!.error = !errors['numero']!;
        senhaErrors['caractereEspecial']!.error = !errors['caractereEspecial']!;
        senhaErrors['geral']!.error = !errors['oitoCaracteres']! ||
            !errors['maiuscula']! ||
            !errors['minuscula']! ||
            !errors['numero']! ||
            !errors['caractereEspecial']!;
        senhaShowErrors = senhaErrors['geral']!.error;
      });
    });
    _confirmaSenhaController.addListener(() {
      setState(() {
        confirmaSenhaErrors['geral']!.error = !Validations.validadeSenhasIguais(
          _senhaController.text,
          _confirmaSenhaController.text,
        );
        confirmaSenhaShowErrors = confirmaSenhaErrors['geral']!.error;
      });
    });
  }

  Future<void> redefinirSenha() async {
    final senha = _senhaController.text;
    final confirmaSenha = _confirmaSenhaController.text;

    if (senha.isEmpty || confirmaSenha.isEmpty) {
      return;
    }
    if (!Validations.validadeSenhasIguais(senha, confirmaSenha)) {
      return;
    }

    final redefinirSenhaController = RedefinirSenhaController();
    final redefinido = await redefinirSenhaController.redefinirSenha(senha);
    if (redefinido) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesNames.home.route,
        (route) => false,
      );
    } else {
      showSnackBar(
        context: context,
        message: 'Ocorreu um erro ao redefinir sua senha, tente mais tarde',
        error: true,
      );
    }
  }

  @override
  void initState() {
    listeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorTheme.indigo_primary_1000,
              colorTheme.indigo_primary_500
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            margin: EdgeInsets.only(top: screenHeight * 0.3),
            decoration: BoxDecoration(
              color: colorTheme.indigo_primary_400,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Para prosseguir, redefina sua senha',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: colorTheme.white_onPrimary_100,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: colorTheme.white_onPrimary_100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ObscuredTextField(
                        colorTheme: colorTheme,
                        label: 'Senha',
                        controller: _senhaController,
                        errors: senhaErrors.values.toList(),
                        showErrors: senhaShowErrors,
                      ),
                      const SizedBox(height: 20),
                      ObscuredTextField(
                        colorTheme: colorTheme,
                        label: 'Confirma sua senha',
                        controller: _confirmaSenhaController,
                        errors: confirmaSenhaErrors.values.toList(),
                        showErrors: confirmaSenhaShowErrors,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: Botao(
                          texto: 'Confirmar',
                          onPressed: redefinirSenha,
                          tipo: TipoBotao.secondary,
                          colorTheme: colorTheme,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
