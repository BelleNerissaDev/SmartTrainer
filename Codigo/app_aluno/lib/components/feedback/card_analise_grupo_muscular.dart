import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:SmartTrainer/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class CardAnaliseGrupoMuscular extends StatelessWidget {
  final List<Treino> treinos;
  final bool showTempo;
  final int? tempo;
  final DateTime? data;
  final int totalTreinos;

  const CardAnaliseGrupoMuscular({
    Key? key,
    this.showTempo = false,
    this.tempo,
    this.data,
    required this.totalTreinos,
    required this.treinos,
  }) : super(key: key);

  Map<GrupoMuscular, double> calcularPorcentagemPorGrupoMuscular() {
    final distinctTreinos = treinos.toSet();
    final int cemPorCentoTreinos =
        (totalTreinos / distinctTreinos.length).floor();

    final gruposPorTreino = _mapearGruposPorTreino(distinctTreinos);

    return _calcularPorcentagens(gruposPorTreino, cemPorCentoTreinos);
  }

  Map<Treino, List<GrupoMuscular>> _mapearGruposPorTreino(Set<Treino> treinos) {
    return {
      for (var treino in treinos)
        treino: treino.exercicios
            .expand((exercicio) => exercicio.gruposMusculares)
            .toSet()
            .toList()
    };
  }

  Map<GrupoMuscular, double> _calcularPorcentagens(
      Map<Treino, List<GrupoMuscular>> gruposPorTreino,
      int cemPorCentoTreinos) {
    final Map<GrupoMuscular, double> porcentagemPorGrupoMuscular = {};

    gruposPorTreino.forEach((treino, gruposMusculares) {
      final quantidadeTreinos = treinos.where((t) => t == treino).length;

      for (final grupo in gruposMusculares) {
        porcentagemPorGrupoMuscular[grupo] ??=
            (quantidadeTreinos / cemPorCentoTreinos * 100);
      }
    });

    return porcentagemPorGrupoMuscular;
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: treinos.isEmpty
            ? Center(
                child: Text(
                  'Nenhum treino realizado ainda',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: colorTheme.gray_700,
                  ),
                ),
              )
            : Column(
                children: [
                  if (showTempo) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tempo total: ${formatTime(tempo!)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: colorTheme.gray_700,
                          ),
                        ),
                        Text(
                          formatDate(data!, showHora: true),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: colorTheme.gray_700,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: colorTheme.gray_500,
                      height: 20,
                      thickness: 3,
                    ),
                  ],
                  for (var grupo
                      in calcularPorcentagemPorGrupoMuscular().entries)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3, // 30% of the available space
                            child: Text(
                              grupo.key.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7, // 70% of the available space
                            child: Row(
                              children: [
                                Expanded(
                                  child: LinearPercentIndicator(
                                    lineHeight: 10.0,
                                    percent: grupo.value / 100,
                                    progressColor:
                                        colorTheme.indigo_primary_400,
                                  ),
                                ),
                                Text(
                                  '${grupo.value.ceil()}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
