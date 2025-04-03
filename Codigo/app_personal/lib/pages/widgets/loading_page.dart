import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/pages/controller/auth/authentication_controller.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool authError = false;

  Future<void> _autenticar() async {
    try {
      final auth = AuthenticationController();
      if (await auth.login()) {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesNames.home.route, (route) => false);
      } else {
        setState(() {
          authError = true;
        });
      }
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _autenticar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: authError
          ? const Center(
              child: Text('Erro ao autenticar, entre em contato com o suporte',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  )),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
