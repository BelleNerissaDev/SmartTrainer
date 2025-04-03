import 'package:SmartTrainer/components/feedback/card_analise_grupo_muscular.dart';
import 'package:SmartTrainer/components/header/header.dart';
import 'package:SmartTrainer/components/treinos/card_historico_treino.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/connections/repository/realizacao_treino_repository.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/realizacao_treino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoricoTreinosPage extends StatefulWidget {
  final List<RealizacaoTreino> realizacoesOnTest;
  const HistoricoTreinosPage({
    Key? key,
    this.realizacoesOnTest = const [],
  }) : super(key: key);

  @override
  _HistoricoTreinosPageState createState() => _HistoricoTreinosPageState();
}

class _HistoricoTreinosPageState extends State<HistoricoTreinosPage> {
  Future<List<RealizacaoTreino>>? futureRealizacaoTreino;
  late Aluno aluno;

  Future<void> _loadTreino() async {
    try {
      final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);
      aluno = alunoProvider.aluno!;

      final realizacaoTreinoRepository = RealizacaoTreinoRepository();

      setState(() {
        futureRealizacaoTreino = realizacaoTreinoRepository.readAllByAlunoByMes(
            aluno, DateTime.now());
      });
    } on FirebaseException {
      setState(() {
        futureRealizacaoTreino = Future.value(widget.realizacoesOnTest);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTreino();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    return Scaffold(
        appBar: Header(
          colorTheme: colorTheme,
        ),
        body: Column(
          children: [
            const Center(
              child: Text(
                'Histórico de Treinos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: futureRealizacaoTreino,
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

                    final realizacoes = snapshot.data!;
                    realizacoes.sort((a, b) => a.data.compareTo(b.data));

                    return Column(
                      children: [
                        for (final realizacao in realizacoes)
                          CardHistoricoTreino(
                            colorTheme: colorTheme,
                            titulo: realizacao.treino.nome,
                            tempo: realizacao.tempo,
                            data: realizacao.data,
                            nivelEsforco: realizacao.feedback!.nivelEsforco,
                            observacao: realizacao.feedback!.observacao,
                          ),
                        CardAnaliseGrupoMuscular(
                          totalTreinos:
                              int.tryParse(aluno.pacote.numeroAcessos) ?? 0,
                          treinos: realizacoes.map((e) => e.treino).toList(),
                        )
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}
