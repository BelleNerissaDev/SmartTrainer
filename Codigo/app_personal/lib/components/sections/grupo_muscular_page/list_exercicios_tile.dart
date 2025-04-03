import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class ListExerciciosTile extends StatelessWidget {
  final ColorFamily colorTheme;
  late final Future<List<Exercicio>> futureExercicios;
  final Icon? trailing;

  final Function(Exercicio) onItemTap;

  ListExerciciosTile({
    Key? key,
    required this.colorTheme,
    required this.futureExercicios,
    required this.onItemTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercicio>>(
      future: futureExercicios,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar exercícios: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Nenhum exercício encontrado.'),
          );
        }

        final exercicios = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exercicios.length,
          itemBuilder: (context, index) {
            final exercicio = exercicios[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: onItemTap(exercicio),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorTheme.light_container_500,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 8.0),
                    trailing: trailing ?? null,
                    leading:
                        exercicio.imagem != null && exercicio.imagem!.isNotEmpty
                            ? Image.network(
                                exercicio.imagem!,
                                width: 70,
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              )
                            : Image.asset(
                                'assets/images/avancoEx.jpeg',
                                width: 70,
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                    title: Text(exercicio.nome,
                        style: Theme.of(context).textTheme.label14px!.copyWith(
                              color: colorTheme.grey_font_700,
                            )),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
