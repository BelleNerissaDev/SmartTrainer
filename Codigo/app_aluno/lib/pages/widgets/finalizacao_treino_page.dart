import 'package:SmartTrainer/components/botao.dart';
import 'package:SmartTrainer/components/feedback/card_analise_grupo_muscular.dart';
import 'package:SmartTrainer/components/feedback/card_feedback.dart';
import 'package:SmartTrainer/components/header/header.dart';
import 'package:SmartTrainer/components/loading/loading.dart';
import 'package:SmartTrainer/components/stack_bar/snack_bar.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/connections/repository/realizacao_treino_repository.dart';
import 'package:SmartTrainer/events/notificacao_events.dart.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';
import 'package:SmartTrainer/models/entity/realizacao_treino.dart';
import 'package:SmartTrainer/pages/controller/realizacao_treino_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinalizacaoTreinoPage extends StatefulWidget {
  const FinalizacaoTreinoPage({Key? key}) : super(key: key);

  @override
  _FinalizacaoTreinoPageState createState() => _FinalizacaoTreinoPageState();
}

class _FinalizacaoTreinoPageState extends State<FinalizacaoTreinoPage> {
  bool canPop = false;
  bool _isInitiated = false;

  late RealizacaoTreino _realizacaoTreino;
  final _controller = TextEditingController();
  NivelEsforco nivelEsforco = NivelEsforco.MUITO_BAIXO;

  List<RealizacaoTreino> realizacoesTreino = [];
  late Aluno aluno;

  Future<List<RealizacaoTreino>> _loadTreino() async {
    try {
      final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);
      aluno = alunoProvider.aluno!;

      final realizacaoTreinoRepository = RealizacaoTreinoRepository();

      return realizacaoTreinoRepository.readAllByAlunoByMes(
          aluno, DateTime.now());
    } on FirebaseException {
      return [];
    }
  }

  bool feedbackEnviado = false;

  Future<void> _finalizarTreino() async {
    if (_controller.text.isEmpty) {
      showSnackBar(
        context: context,
        message: 'Informe o feedback',
        error: true,
      );
      return;
    }
    showLoading(context);
    final aluno = Provider.of<AlunoProvider>(context, listen: false).aluno!;
    final controller = RealizacaoTreinoController();

    final result = await controller.criarRealizacaoTreino(
      aluno: aluno,
      realizacaoTreino: _realizacaoTreino,
      nivelEsforco: nivelEsforco,
      observacao: _controller.text,
    );

    if (result) {
      showSnackBar(
        context: context,
        message: 'Feedback enviado com sucesso',
        error: false,
      );
      setState(() {
        canPop = true;
        feedbackEnviado = true;
      });
      NotificacaoEvents.notificarFimTreino(aluno.nome, aluno.imagem);
    } else {
      showSnackBar(
        context: context,
        message: 'Erro ao enviar feedback',
        error: true,
      );
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args =
          ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
      final treinos = await _loadTreino();

      setState(() {
        _realizacaoTreino = args['realizacaoTreino'] as RealizacaoTreino;
        _isInitiated = true;
        treinos.add(_realizacaoTreino);
        realizacoesTreino = treinos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (pop, result) {
        if (!pop) {
          showSnackBar(
            context: context,
            message: 'Finalize o feedback para sair',
            error: true,
          );
        }
      },
      child: _isInitiated
          ? Scaffold(
              appBar: Header(
                colorTheme: colorTheme,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      CardFeedback(
                        colorTheme: colorTheme,
                        nivelEsforco: nivelEsforco,
                        onNivelEsforcoChanged: (int index) {
                          setState(() {
                            nivelEsforco = NivelEsforco.values.firstWhere(
                                (element) => element.value == index);
                          });
                        },
                        controller: _controller,
                        editavel: !feedbackEnviado,
                      ),
                      const SizedBox(height: 20),
                      if (!feedbackEnviado) ...[
                        Botao(
                          texto: 'Enviar Feedback',
                          onPressed: _finalizarTreino,
                          tipo: TipoBotao.primary,
                          colorTheme: colorTheme,
                        ),
                      ],
                      const SizedBox(height: 20),
                      const Text(
                        'Análise de grupo muscular',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      CardAnaliseGrupoMuscular(
                        showTempo: true,
                        data: _realizacaoTreino.data,
                        tempo: _realizacaoTreino.tempo,
                        totalTreinos:
                            int.tryParse(aluno.pacote.numeroAcessos) ?? 0,
                        treinos:
                            realizacoesTreino.map((e) => e.treino).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
