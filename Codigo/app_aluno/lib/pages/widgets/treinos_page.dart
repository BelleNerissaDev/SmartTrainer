import 'dart:async';

import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/botao.dart';
import 'package:SmartTrainer/components/header/header.dart';
import 'package:SmartTrainer/components/menu.dart';
import 'package:SmartTrainer/components/treinos/card_treinos.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:SmartTrainer/connections/repository/plano_treinos_repository.dart';
import 'package:SmartTrainer/connections/repository/realizacao_treino_repository.dart';
import 'package:SmartTrainer/models/entity/plano_treino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TreinosPage extends StatefulWidget {
  const TreinosPage({Key? key}) : super(key: key);
  @override
  _TreinosPageState createState() => _TreinosPageState();
}

class _TreinosPageState extends State<TreinosPage> {
  Future<PlanoTreino>? futureTreino;
  bool _jaTreinou = false;

  Future<void> _loadTreino({bool isReload = false}) async {
    try {
      final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);
      final aluno = alunoProvider.aluno!;

      final planoTreinoRepository = PlanoTreinoRepository();
      final realizacaoTreinoRepository = RealizacaoTreinoRepository();

      final jaTreinou = await realizacaoTreinoRepository
          .hasRealizacaoTreinoByAlunoByData(aluno, DateTime.now());

      final planoTreino = planoTreinoRepository.readAtivoByAluno(aluno);

      if (isReload) {
        await planoTreino;
      }

      setState(() {
        _jaTreinou = jaTreinou;
        futureTreino = planoTreino;
      });
    } on FirebaseException {
      setState(() {
        futureTreino = Future.value(PlanoTreino(nome: '', status: ''));
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      _loadTreino(isReload: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTreino();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final colorTheme = brightness == Brightness.light
        ? CustomTheme.colorFamilyLight
        : CustomTheme.colorFamilyDark;

    return Scaffold(
        drawer: Menu(colorTheme: colorTheme),
        appBar: Header(
          colorTheme: colorTheme,
        ),
        body: Column(
          children: [
            const Center(
              child: Text(
                'Plano de treinamento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Botao(
              texto: 'Histórico',
              onPressed: () {
                Navigator.pushNamed(
                    context, RoutesNames.historico_treinos.route);
              },
              tipo: TipoBotao.primary,
              colorTheme: colorTheme,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<PlanoTreino>(
                  future: futureTreino,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.none) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Erro ao carregar os dados'),
                      );
                    }

                    if (snapshot.hasData) {
                      final treinos = snapshot.data!.treinos;
                      treinos.sort((a, b) => a.nome.compareTo(b.nome));

                      return Column(
                        children: [
                          for (final treino in treinos)
                            CardTreinos(
                              disponivel: !_jaTreinou,
                              colorTheme: colorTheme,
                              titulo: treino.nome,
                              gruposMusculares: treino.exercicios
                                  .expand((e) => e.gruposMusculares)
                                  .toSet()
                                  .toList(),
                              iniciarTreino: () {
                                Navigator.pushNamed(
                                  context,
                                  RoutesNames.realizacao_treino.route,
                                  arguments: {
                                    'treino': treino,
                                    'treinoAtual': treinos.indexOf(treino) + 1,
                                    'totalTreinos': treinos.length,
                                  },
                                );
                              },
                            ),
                        ],
                      );
                    }

                    return const Center(
                      child: Text('Nenhum treino disponível'),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}
