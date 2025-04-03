import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/botao.dart';
import 'package:SmartTrainer/models/entity/grupo_muscular.dart';
import 'package:flutter/material.dart';

class CardTreinos extends StatelessWidget {
  final MyColorFamily colorTheme;
  final String titulo;
  final List<GrupoMuscular> gruposMusculares;
  final bool disponivel;
  final void Function()? iniciarTreino;

  const CardTreinos({
    super.key,
    required this.colorTheme,
    required this.titulo,
    required this.gruposMusculares,
    required this.iniciarTreino,
    this.disponivel = true,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    children: [
                      for (var grupo in gruposMusculares)
                        Card(
                          elevation: 1,
                          color: colorTheme.lilac_tertiary_200,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(grupo.nome),
                          ),
                        ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Botao(
                    texto: 'Iniciar treino',
                    onPressed: iniciarTreino,
                    tipo: disponivel ? TipoBotao.secondary : TipoBotao.disabled,
                    colorTheme: colorTheme,
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
