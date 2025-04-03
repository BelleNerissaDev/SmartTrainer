import 'package:SmartTrainer/components/botao.dart';
import 'package:SmartTrainer/components/stack_bar/snack_bar.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/pages/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final bool inTest;
  const LoginPage({Key? key, this.inTest = false}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  Future<void> esqueciSenha() async {
    final String email = _emailController.text;

    if (email.isEmpty) {
      showSnackBar(
          context: context, message: 'Preencha o campo de email', error: true);
      return;
    }

    final loginController = LoginController();

    setState(() {
      _isLoading = true;
    });

    final enviado = await loginController.esqueciSenha(email);
    if (enviado) {
      showSnackBar(
        context: context,
        message: 'Email enviado com sucesso',
        error: false,
      );
    } else {
      showSnackBar(
        context: context,
        message: 'Ocorreu um erro ao enviar o email',
        error: true,
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> login() async {
    final String email = _emailController.text;
    final String senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      showSnackBar(
        context: context,
        message: 'Preencha todos os campos',
        error: true,
      );
      return;
    }

    final loginController = LoginController();

    setState(() {
      _isLoading = true;
    });

    final logado = await loginController.login(email, senha);
    switch (logado) {
      case LoginStatus.logado:
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesNames.home.route, (route) => false);
        break;
      case LoginStatus.erroDesconhecido:
        showSnackBar(
          context: context,
          message: 'Ocorreu um erro ao fazer login, tente mais tarde',
          error: true,
        );
        break;
      case LoginStatus.emailNaoVerificado:
        showSnackBar(
          context: context,
          message: 'Verifique seu email para continuar',
          error: true,
        );
        break;
      case LoginStatus.logadoPrimeiraVez:
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesNames.redefinir_senha.route, (route) => false);
        break;
      case LoginStatus.senhaIncorreta:
        showSnackBar(
          context: context,
          message: 'Email e/ou senha incorretos',
          error: true,
        );
        break;
      case LoginStatus.limiteAcessosExcedido:
        showSnackBar(
          context: context,
          message: 'Limite de acessos semanais excedido',
          error: true,
        );
        break;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> verifyToken() async {
    final loginController = LoginController();
    setState(() {
      _isLoading = true;
    });
    final jaLogado = await loginController.loginFromToken();
    if (!mounted) return;
    if (jaLogado) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesNames.home.route, (route) => false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!widget.inTest) {
      verifyToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: screenWidth,
              height: screenHeight,
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
              child: Container(
                margin: EdgeInsets.only(top: screenHeight * 0.3),
                width: screenWidth,
                decoration: BoxDecoration(
                    color: colorTheme.indigo_primary_400,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(60),
                    )),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Bem-vindo',
                        style: TextStyle(
                          fontSize: 24,
                          color: colorTheme.white_onPrimary_100,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: screenWidth,
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorTheme.white_onPrimary_100,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(60),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text('Login'),
                              ),
                              ObscuredTextField(
                                colorTheme: colorTheme,
                                label: 'Email',
                                controller: _emailController,
                                obscureText: false,
                              ),
                              const SizedBox(height: 20),
                              ObscuredTextField(
                                colorTheme: colorTheme,
                                label: 'Senha',
                                controller: _senhaController,
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: screenWidth * 0.8,
                                child: Botao(
                                    texto: 'Entrar',
                                    onPressed: login,
                                    tipo: TipoBotao.secondary,
                                    colorTheme: colorTheme),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: TextButton(
                                  onPressed: esqueciSenha,
                                  child: Text(
                                    'Esqueci minha senha',
                                    style: TextStyle(
                                      color: colorTheme.indigo_primary_500,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
