import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardNomeAluno extends StatelessWidget {
  final MyColorFamily colorTheme;

  const CardNomeAluno({
    Key? key,
    required this.colorTheme,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final aluno = Provider.of<AlunoProvider>(context).aluno;
    return aluno == null
        ? Center(
            child: CircularProgressIndicator(
              color: colorTheme.indigo_primary_800,
            ),
          )
        : Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Olá,',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: colorTheme.gray_800,
                fontSize: 10,
              ),
            ),
            Text(
                    aluno.nome,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: colorTheme.indigo_primary_800,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
              CircleAvatar(
          radius: 20,
                child: aluno.imagem == null
                    ? const Icon(Icons.person)
                    : ClipOval(
                        child: Image.network(
                          aluno.imagem!,
                          fit:
                              BoxFit.cover, // Para ajustar a imagem ao contorno
                          width: 40, // Define a largura da imagem
                          height: 40, // Define a altura da imagem
                        ),
                      ),
        ),
      ],
    );
  }
}
