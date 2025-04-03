import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/botao.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';

class CardProximoTreino extends StatelessWidget {
  final MyColorFamily colorTheme;
  final Treino treino;
  final bool disponivel;

  const CardProximoTreino({
    Key? key,
    required this.colorTheme,
    required this.treino,
    required this.disponivel,
  }) : super(key: key);
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
                Center(
                  child: Text(
                    treino.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                _CardInfos(
                  icon: Mdi.armFlexOutline,
                  titulo: 'Grupos Musculares: ',
                  valor: treino.exercicios
                      .expand((exercicio) => exercicio.gruposMusculares)
                      .map((grupo) => grupo.nome)
                      .join(', '),
                  colorTheme: colorTheme,
                ),
                Center(
                  child: Botao(
                      texto: 'Iniciar treino',
                      onPressed: () => {
                            Navigator.pushNamed(
                              context,
                              RoutesNames.realizacao_treino.route,
                              arguments: {
                                'treino': treino,
                                'treinoAtual': 1,
                                'totalTreinos': 1,
                              },
                            )
                          },
                      tipo:disponivel? TipoBotao.primary : TipoBotao.disabled,
                      colorTheme: colorTheme),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardInfos extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icon;
  final MyColorFamily colorTheme;
  const _CardInfos(
      {Key? key,
      required this.titulo,
      required this.valor,
      required this.icon,
      required this.colorTheme})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinha o texto na parte superior
        children: [
          Container(
            color: colorTheme.lemon_secondary_400,
            padding: const EdgeInsets.all(8.0), // Adiciona um padding ao ícone
            child: Icon(icon),
          ),
          const SizedBox(width: 8), // Espaçamento entre o ícone e o texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  valor,
                  maxLines: 6,
                  overflow: TextOverflow
                      .ellipsis, // Indica que texto maior será truncado
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
