import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class StudentCard extends StatelessWidget {
  final ColorFamily colorTheme;
  final Aluno aluno;

  const StudentCard({
    Key? key,
    required this.colorTheme,
    required this.aluno,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesNames.alunoPerfil.route,
            arguments: aluno);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorTheme.light_container_500,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorTheme.grey_font_500,
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: aluno.imagem != null
                  ? NetworkImage(aluno.imagem!)
                  : null, // Se a imagem for nula, backgroundImage é null
              child: aluno.imagem == null
                  ? const Icon(Icons.person)
                  : null, // Exibe o ícone apenas se a imagem for nula
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: () {
                          switch (aluno.status) {
                            case StatusAlunoEnum.ATIVO:
                              return colorTheme.green_sucess_500;
                            case StatusAlunoEnum.BLOQUEADO:
                              return colorTheme.red_error_500;
                          }
                        }(),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        aluno.status.toString(),
                        style: TextStyle(
                          color: () {
                            switch (aluno.status) {
                              case StatusAlunoEnum.ATIVO:
                                return colorTheme.green_sucess_500;
                              case StatusAlunoEnum.BLOQUEADO:
                                return colorTheme.red_error_500;
                            }
                          }(),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    aluno.nome,
                    style: Theme.of(context).textTheme.headline24px!.copyWith(
                          color: colorTheme.black_onSecondary_100,
                          fontWeight: FontWeight.w700,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    aluno.pacote.nome,
                    style: Theme.of(context).textTheme.body14px!.copyWith(
                          color: colorTheme.grey_font_700,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined,
                  size: 30, color: colorTheme.indigo_primary_800),
              onPressed: () {
                // Action for edit button
              },
            ),
          ],
        ),
      ),
    );
  }
}
