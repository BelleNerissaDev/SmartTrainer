import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class InfoAlunoPacoteComEdicao extends StatelessWidget {
  final GestureTapCallback onEditTap;
  final ColorFamily colorTheme;
  final Aluno aluno;

  const InfoAlunoPacoteComEdicao({
    Key? key,
    required this.onEditTap,
    required this.colorTheme,
    required this.aluno,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Pacote Atual
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/package.svg',
                  color: colorTheme.indigo_primary_800,
                  width: 24.0,
                  height: 24.0,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pacote atual',
                  style: Theme.of(context).textTheme.title18px!.copyWith(
                        color: colorTheme.black_onSecondary_100,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
            // Botão de Ação
            GestureDetector(
              onTap: onEditTap,
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: colorTheme.indigo_primary_800,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Trocar Pacote',
                    style: Theme.of(context).textTheme.body14px!.copyWith(
                          color: colorTheme.indigo_primary_800,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Informações sobre o Pacote
        Row(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Valor (mês): ',
                    style: Theme.of(context).textTheme.label14px!.copyWith(
                          color: colorTheme.black_onSecondary_100,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: 'R\$ ${aluno.pacote.valorMensal}',
                    style: Theme.of(context).textTheme.label14px!.copyWith(
                          color: colorTheme.grey_font_700,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Número de acessos (mês): ',
                    style: Theme.of(context).textTheme.label14px!.copyWith(
                          color: colorTheme.black_onSecondary_100,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(
                    text: aluno.pacote.numeroAcessos,
                    style: Theme.of(context).textTheme.label14px!.copyWith(
                          color: colorTheme.grey_font_700,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
