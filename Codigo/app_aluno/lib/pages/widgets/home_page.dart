import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/card_calendario_treinos.dart';
import 'package:SmartTrainer/components/card_login_semanal.dart';
import 'package:SmartTrainer/components/card_progresso.dart';
import 'package:SmartTrainer/components/card_proximo_treino.dart';
import 'package:SmartTrainer/components/feedback/card_analise_grupo_muscular.dart';
import 'package:SmartTrainer/components/header/header.dart';
import 'package:SmartTrainer/components/menu.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer/connections/repository/plano_treinos_repository.dart';
import 'package:SmartTrainer/connections/repository/realizacao_treino_repository.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/realizacao_treino.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:SmartTrainer/utils/calendario_utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = ScrollController();
  late Aluno? aluno;
  Treino? proximoTreino;
  Future<int>? sessoesRealizadas;
  Future<List<RealizacaoTreino>>? realizacoesTreino;
  Future<List<DateTime>>? diasTreinados;
  bool disponivel = false;
  final DateTime hoje = DateTime.now();

  Future<void> fetchData({bool refreshData = false}) async {
    try {
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }
      final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);
      final alunoRepository = AlunoRepository();
      final prefs = await SharedPreferences.getInstance();

      final idAluno = prefs.getString('userId');

      final aluno = await alunoRepository.readById(idAluno!);

      final realizacaoTreinoRepository = RealizacaoTreinoRepository();

      final realizacoesTreino =
          realizacaoTreinoRepository.readAllByAlunoByMes(aluno, hoje);

      final diasTreinados = realizacaoTreinoRepository
          .findDiasTreinadosUltimosTresMesesByAluno(aluno, hoje);

      final sessoesRealizadas =
          realizacaoTreinoRepository.countByAlunoByMes(aluno, hoje);

      final planoTreinoRepository = PlanoTreinoRepository();

      final planoTreino = planoTreinoRepository.readAtivoByAluno(aluno);

      final hasRealizacaoTreino = realizacaoTreinoRepository
          .hasRealizacaoTreinoByAlunoByData(aluno, hoje);

      setState(() {
        this.realizacoesTreino = realizacoesTreino;
        this.sessoesRealizadas = sessoesRealizadas;
        this.diasTreinados = diasTreinados;
      });

      planoTreino.then((value) {
        setState(() {
          this.proximoTreino = value.treinos.first;
        });
      });

      hasRealizacaoTreino.then((value) {
        setState(() {
          disponivel = !value;
        });
      });

      if (!refreshData) {
        alunoProvider.setAluno(aluno);
      }
    } on Exception {
      setState(() {
        this.realizacoesTreino = null;
        this.sessoesRealizadas = null;
        this.proximoTreino = null;
        this.disponivel = false;
        this.diasTreinados = null;
      });
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      fetchData(refreshData: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    setState(() {
      aluno = Provider.of<AlunoProvider>(context).aluno;
    });

    var colorTheme = brightness == Brightness.light
        ? CustomTheme.colorFamilyLight
        : CustomTheme.colorFamilyDark;

    return Scaffold(
      drawer: Menu(colorTheme: colorTheme),
      appBar: Header(
        colorTheme: colorTheme,
      ),
      body: aluno == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView(
                controller: _controller,
                children: [
                  CardLoginSemanal(
                    colorTheme: colorTheme,
                    diaSemana: aluno!.acessosUsadosSemana,
                    acessos: int.parse(aluno!.pacote.numeroAcessos) ~/ 4,
                  ),
                  () {
                    if (proximoTreino != null)
                      return CardProximoTreino(
                        disponivel: disponivel,
                        treino: proximoTreino!,
                        colorTheme: colorTheme,
                      );
                    else
                      return const Center();
                  }(),
                  if (sessoesRealizadas != null)
                    FutureBuilder(
                        future: sessoesRealizadas,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CardProgresso(
                              sessoesRealizadas: snapshot.data!,
                              sessoesTotais:
                                  int.parse(aluno!.pacote.numeroAcessos),
                              colorTheme: colorTheme,
                            );
                          } else {
                            return const Center();
                          }
                        }),
                  if (diasTreinados != null)
                    FutureBuilder(
                        future: diasTreinados,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CardCalendarioTreinos(
                              hoje: hoje,
                              diasNaoTreinados: generateDateList(
                                DateTime(hoje.year, hoje.month - 2, 1),
                                snapshot.data!,
                              ),
                              diasTreinados: snapshot.data!,
                              colorTheme: colorTheme,
                            );
                          } else {
                            return const Center();
                          }
                        }),
                  if (realizacoesTreino != null) ...[
                    const Center(
                      child: Text(
                        'Análise de grupo muscular total',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: realizacoesTreino,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CardAnaliseGrupoMuscular(
                                totalTreinos:
                                    int.parse(aluno!.pacote.numeroAcessos),
                                treinos: snapshot.data!
                                    .map((e) => e.treino)
                                    .toList(),
                              ),
                            );
                          } else {
                            return const Center();
                          }
                        }),
                  ]
                ],
              ),
            ),
    );
  }
}
