import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:flutter/material.dart';

class ListTodosExerciciosBuilder extends StatelessWidget {
  final ColorFamily colorTheme;
  late final Future<List<Exercicio>> futureExerciciosAssociados;
  late final Future<List<Exercicio>> futureTodosExercicios;
  final String? searchQuery;

  final Function(Exercicio) onItemTap;

  ListTodosExerciciosBuilder({
    Key? key,
    required this.colorTheme,
    required this.futureTodosExercicios,
    required this.futureExerciciosAssociados,
    required this.onItemTap,
    this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercicio>>(
      future: futureTodosExercicios,
      builder: (context, todosExerciciosSnapshot) {
        if (todosExerciciosSnapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (todosExerciciosSnapshot.hasError) {
          return Center(
            child: Text(
              'Erro ao carregar exercícios: ${todosExerciciosSnapshot.error}',
            ),
          );
        } else if (!todosExerciciosSnapshot.hasData ||
            todosExerciciosSnapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum exercício encontrado.'));
        }

        final todosExercicios = todosExerciciosSnapshot.data!;

        return FutureBuilder<List<Exercicio>>(
          future: futureExerciciosAssociados,
          builder: (context, associadosSnapshot) {
            if (associadosSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (associadosSnapshot.hasError) {
              return Center(
                child: Text(
                  // ignore: lines_longer_than_80_chars
                  'Erro ao carregar exercícios associados:${associadosSnapshot.error}',
                ),
              );
            }

            final exerciciosAssociados = associadosSnapshot.data ?? [];

            final exerciciosNaoAssociados = todosExercicios
                .where((exercicio) => !exerciciosAssociados
                    .any((associado) => associado.id == exercicio.id))
                .toList();

            final exerciciosFiltrados = exerciciosNaoAssociados
                .where((exercicio) => exercicio.nome
                    .toLowerCase()
                    .contains(searchQuery!.toLowerCase()))
                .toList();

            return SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: exerciciosFiltrados.length,
                itemBuilder: (context, index) {
                  final exercicio = exerciciosFiltrados[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: GestureDetector(
                      onTap: onItemTap(exercicio),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorTheme.white_onPrimary_100,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ListTile(
                          leading: exercicio.imagem != null &&
                                  exercicio.imagem!.isNotEmpty
                              ? Image.network(
                                  exercicio.imagem!,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                )
                              : Image.asset(
                                  'assets/images/avancoEx.jpeg',
                                  width: 80,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                          trailing: Icon(
                            Icons.add,
                            color: colorTheme.grey_font_700,
                          ),
                          title: Text(exercicio.nome),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
