import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/models/entity/treino.dart';
import 'package:flutter/material.dart';

class AlertNovoPlanoTreino {
  static void show(BuildContext context, ColorFamily colorTheme,
      List<Treino> treinos, Function _criarPlanoTreino) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Criar Novo Plano de Treino',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Ajuste a largura
            child: SingleChildScrollView(
              // Garantindo que o conteúdo seja rolável
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimiza o tamanho da coluna
                children: <Widget>[
                  const Text(
                      'Você está prestes a criar um novo plano de treino.'),
                  const SizedBox(height: 10),
                  // Definindo altura máxima para o ListView.builder
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: treinos.length,
                    itemBuilder: (context, treinoIndex) {
                      var treino = treinos[treinoIndex];
                      var nomeTreino = treino.nome;
                      var exerciciosAssociados = treino.exercicios;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomeTreino,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: exerciciosAssociados.length,
                            itemBuilder: (context, exercicioIndex) {
                              var exercicio =
                                  exerciciosAssociados[exercicioIndex];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  '  ' + exercicio.nome,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar',
                  style: TextStyle(color: colorTheme.red_error_500)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _criarPlanoTreino(colorTheme);
              },
            )
          ],
        );
      },
    );
  }
}
