import 'package:SmartTrainer/app_theme.dart';
import 'package:flutter/material.dart';

enum TipoBotao {
  primary(5),
  secondary(5),
  disabled(0),
  error(5),
  ;

  final double elevation;

  const TipoBotao(
    this.elevation,
  );
}

class Botao extends StatelessWidget {
  final String texto;
  final Function()? onPressed;
  final TipoBotao tipo;
  final MyColorFamily colorTheme;

  const Botao({
    Key? key,
    required this.texto,
    required this.onPressed,
    required this.tipo,
    required this.colorTheme,
  }) : super(key: key);

  _getBtnCollor() {
    switch (tipo) {
      case TipoBotao.primary:
        return colorTheme.indigo_primary_700;
      case TipoBotao.secondary:
        return colorTheme.lemon_secondary_400;
      case TipoBotao.disabled:
        return colorTheme.gray_500;
      case TipoBotao.error:
        return colorTheme.red_error_500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: tipo == TipoBotao.disabled ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(_getBtnCollor()),
        elevation: WidgetStatePropertyAll(tipo.elevation),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: colorTheme.black_tertiary_800,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
