import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class ExercicioCard extends StatelessWidget {
  final Exercicio exercicio;
  final ColorFamily colorTheme;

  const ExercicioCard(
      {Key? key, required this.exercicio, required this.colorTheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: colorTheme.grey_font_500,
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: exercicio.imagem != null
                  ? Image.network(
                      exercicio.imagem!,
                      width: 100,
                    )
                  : Image.asset(
                      'assets/images/avancoEx.jpeg',
                      width: 100,
                    ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercicio.nome,
                    style: Theme.of(context).textTheme.title16px!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorTheme.indigo_primary_700),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        for (final grupo in exercicio.gruposMusculares)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: colorTheme.lemon_secondary_500,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              grupo.nome,
                              style: Theme.of(context)
                                  .textTheme
                                  .label14px!
                                  .copyWith(
                                      color: colorTheme.black_onSecondary_100),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    exercicio.metodologia.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                      // ignore: lines_longer_than_80_chars
                      '${exercicio.series} X ${exercicio.repeticoes} repetições'),
                  const SizedBox(height: 5),
                  Text('${exercicio.tipoCarga ?? ''} ${exercicio.carga} kg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
