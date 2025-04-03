import 'dart:async';
import 'package:SmartTrainer/components/botao.dart';
import 'package:SmartTrainer/components/exercicios/card_exercicio.dart';
import 'package:SmartTrainer/components/stack_bar/snack_bar.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/events/notificacao_events.dart.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/exercicio.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';
import 'package:SmartTrainer/models/entity/realizacao_exercicio.dart';
import 'package:SmartTrainer/models/entity/realizacao_treino.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:SmartTrainer/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:provider/provider.dart';

class RealizacaoTreinoPage extends StatefulWidget {
  const RealizacaoTreinoPage({Key? key}) : super(key: key);

  @override
  _RealizacaoTreinoPageState createState() => _RealizacaoTreinoPageState();
}

class _RealizacaoTreinoPageState extends State<RealizacaoTreinoPage> {
  bool canPop = false;
  bool _isInitiated = false;

  int _elapsedSeconds = 0;
  late Timer _timer;

  late Treino _treino;
  late int _treinoAtual;
  late int _totalTreinos;
  late Aluno aluno;

  late List<RealizacaoExercicio> _realizacaoExercicios;

  void _finalizarTreino() {
    if (_treino.exercicios
        .every((ex) => ex.status == StatusExercicio.CONCLUIDO)) {
      _timer.cancel();
      final RealizacaoTreino realizacaoTreino = RealizacaoTreino(
        treino: _treino,
        data: DateTime.now(),
        tempo: _elapsedSeconds,
        realizacaoExercicios: _realizacaoExercicios,
      );
      setState(() {
        canPop = true;
      });
      Navigator.popAndPushNamed(context, RoutesNames.finalizacao_treino.route,
          arguments: {'realizacaoTreino': realizacaoTreino});
    }
  }

  @override
  void initState() {
    super.initState();
    aluno = Provider.of<AlunoProvider>(context, listen: false).aluno!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;

      setState(() {
        _treino = args['treino'] as Treino;
        _treinoAtual = args['treinoAtual'] as int;
        _totalTreinos = args['totalTreinos'] as int;

        _realizacaoExercicios = _treino.exercicios
            .map((ex) => RealizacaoExercicio(
                  idExercicio: ex.id!,
                  novaCarga: ex.carga,
                  nivelEsforco: NivelEsforco.MUITO_BAIXO,
                ))
            .toList();

        _isInitiated = true;
      });
    });
    NotificacaoEvents.notificarInicioTreino(aluno.nome, aluno.imagem);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (pop, result) {
        if (!pop) {
          showSnackBar(
            context: context,
            message: 'Finalize o treino para voltar',
            error: true,
          );
        }
      },
      child: _isInitiated
          ? Scaffold(
              bottomSheet: Container(
                color: colorTheme.indigo_primary_800,
                height: 80,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Mdi.timerOutline,
                                color: Colors.white,
                                size: 25,
                              ),
                              Text(
                                formatTime(_elapsedSeconds),
                                style: TextStyle(
                                  color: colorTheme.white_onPrimary_100,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                          Botao(
                            texto: 'Finalizar',
                            onPressed: _finalizarTreino,
                            tipo: _treino.exercicios.every((ex) =>
                                    ex.status == StatusExercicio.CONCLUIDO)
                                ? TipoBotao.secondary
                                : TipoBotao.disabled,
                            colorTheme: colorTheme,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final ex in _treino.exercicios)
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 2.5),
                              width: (screenWidth * 0.9) /
                                  _treino.exercicios.length,
                              height: 10,
                              decoration: BoxDecoration(
                                color: ex.status == StatusExercicio.CONCLUIDO
                                    ? colorTheme.lemon_secondary_500
                                    : Colors.white,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _treino.nome,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorTheme.indigo_primary_400,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          if (_elapsedSeconds <= 60) ...[
                            IconButton(
                              icon: Icon(
                                Mdi.cancel,
                                color: colorTheme.red_error_500,
                              ),
                              onPressed: () {
                                setState(() {
                                  canPop = true;
                                });
                                Navigator.pop(context, true);
                                NotificacaoEvents.notificarCancelementoTreino(
                                  aluno.nome,
                                  aluno.imagem,
                                );
                              },
                            ),
                          ]
                        ],
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Lista de Exercícios',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Treino ${_treinoAtual} de ${_totalTreinos}',
                      ),
                    ),
                    const SizedBox(height: 40),
                    for (int i = 0; i < _treino.exercicios.length; i++)
                      CardExercicio(
                        exercicio: _treino.exercicios[i],
                        realizacaoExercicio: _realizacaoExercicios[i],
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
