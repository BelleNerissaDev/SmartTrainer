import 'dart:async';
import 'dart:io';

import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/buttons/action_button.dart';
import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/sections/card_calendario_treinos.dart';
import 'package:SmartTrainer_Personal/components/drawers/editar_pacote_bottonsheet.dart';
import 'package:SmartTrainer_Personal/components/sections/info_aluno_pacote.dart';
import 'package:SmartTrainer_Personal/components/cards/feedback_home_carrousel.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/sections/info_aluno_avaliacoes.dart';
import 'package:SmartTrainer_Personal/components/sections/portrait_positioned_user.dart';
import 'package:SmartTrainer_Personal/components/snack_bar/messages_snack_bar.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/components/sections/icons_feedback.dart';
import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/realizacao_treino_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/realizacao_treino.dart';
import 'package:SmartTrainer_Personal/pages/controller/anamnese/anamnese_controller.dart';
import 'package:SmartTrainer_Personal/pages/controller/avaliacao_fisica/avaliacao_fisica_controller.dart';
import 'package:SmartTrainer_Personal/pages/controller/pacote/pacote_controller.dart';
import 'package:SmartTrainer_Personal/pages/controller/realizacao_treino/realizacao_treino_controller.dart';
import 'package:SmartTrainer_Personal/utils/calendario_utils.dart';
import 'package:SmartTrainer_Personal/utils/get_first_last_aluno_name.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class AlunoPerfil extends StatefulWidget {
  final Aluno? alunoOnTest;
  const AlunoPerfil({Key? key, this.alunoOnTest}) : super(key: key);
  @override
  _AlunoPerfilPageState createState() => _AlunoPerfilPageState();
}

class _AlunoPerfilPageState extends State<AlunoPerfil> {
  late Aluno aluno;
  Future<List<AvaliacaoFisica>>? avaliacoes;
  bool _isLoading = false;
  Future<List<AvaliacaoFisica>>? avaliacoesFuture;
  Future<List<RealizacaoTreino>>? realizacoesFuture;
  late Future<List<Pacote>> AllPacotes;
  int? mediaAvaliacoes = 0;
  Future<List<DateTime>> diasTreinados = Future.value([]);

  Future<FilePickerResult> _escolherArquivo() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);
    if (result == null) {
      return const FilePickerResult([]);
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAvaliacoes();
      _fetchFeedbacks();
      _fetchPacotes();
      _fetchDatasDeRealizacaoTreino();
    });
  }

  Future<void> _deleteAluno(colorTheme) async {
    final alunoRepository = AlunoRepository();
    try {
      await alunoRepository.delete(aluno.id!);
      if (mounted) {
        Navigator.of(context)..pop();

        showMessageSnackBar(
          colorTheme,
          context,
          'Aluno excluído com sucesso',
        );
      }
    } catch (e) {
      if (mounted) {
        showMessageSnackBar(
          colorTheme,
          context,
          'Erro ao excluir aluno',
          error: true,
        );
      }
    }
  }

  Future<void> _fetchAvaliacoes() async {
    try {
      final controller = AvaliacaoController();
      setState(() {
        avaliacoesFuture = controller.getAvaliacoes(aluno);
      });
    } catch (e) {
      setState(() {
        avaliacoesFuture = Future.value([]);
      });
    }
  }

    Future<void> _fetchPacotes() async {
    try {
      final controller = PacoteController();
      setState(() {
        AllPacotes = controller.visualizarPacotes();
      });
    } catch (e) {
      setState(() {
        AllPacotes = Future.value([]);
      });
    }
  }

  Future<void> _fetchFeedbacks() async {
    try {
      final realizacaoTreinoRepository = RealizacaoTreinoRepository();

      final realizacoes =
          realizacaoTreinoRepository.readAllByAlunoByMes(aluno, DateTime.now());

      setState(() {
        realizacoesFuture = realizacoes;
        realizacoes.then((value) {
          setState(() {
            mediaAvaliacoes = calcularMediaAvaliacaoFeedbacks(value);
          });
        });
      });
    } catch (e) {
      setState(() {
        realizacoesFuture = Future.value([]);
      });
    }
  }

  Future<void> _fetchDatasDeRealizacaoTreino() async {
    try {
      final controller = RealizacaoTreinoController();
      final diasTreinadosFetched =
          await controller.fetchDatasDeRealizacaoTreino(aluno);

      setState(() {
        diasTreinados = Future.value(diasTreinadosFetched);
      });
    } on Exception {
      setState(() {
        diasTreinados = Future.value([]);
      });
    }
  }

  int calcularMediaAvaliacaoFeedbacks(List<RealizacaoTreino> realizacoes) {
    double somaAvaliacoes = 0;
    int totalFeedbacks = 0;

    for (var realizacao in realizacoes) {
      if (realizacao.feedback != null) {
        somaAvaliacoes += realizacao.feedback!.nivelEsforco.value;
        totalFeedbacks++;
      }
    }

    if (totalFeedbacks > 0) {
      return (somaAvaliacoes / totalFeedbacks).floor();
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    aluno = (ModalRoute.of(context)!.settings.arguments ?? widget.alunoOnTest!)
        as Aluno;

    return Scaffold(
        appBar: CustomAppBar(
          colorTheme: colorTheme,
          title: 'LOGO',
        ),
        drawer: Menu(colorTheme: colorTheme),
        endDrawer: NotificationMenu(colorTheme: colorTheme),
        body: _Body(
          aluno: aluno,
          children: [
            Expanded(
              child: CardContainer(
                colorTheme: colorTheme,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ActionButton(
                              key: const ValueKey('planosalunobtn'),
                              onTap: () => {
                                Navigator.pushNamed(
                                  context,
                                  RoutesNames.alunoPlanosTreinos.route,
                                  arguments: {
                                    'aluno': aluno,
                                  },
                                )
                              },
                              icon: Icons.fitness_center,
                              iconColor: colorTheme.black_onSecondary_100,
                              backgroundColor: colorTheme.lemon_secondary_400,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 40, 8, 4),
                              child: Text(
                                getFirstAndLastName(aluno.nome),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline34px!
                                    .copyWith(
                                      color: colorTheme.black_onSecondary_100,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            ActionButton(
                              key: const ValueKey('editaralunobtn'),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RoutesNames.edicaoAluno.route,
                                  arguments: {
                                    'aluno': aluno,
                                  },
                                );
                              },
                              icon: Icons.edit_outlined,
                              iconColor: colorTheme.black_onSecondary_100,
                              backgroundColor: colorTheme.lemon_secondary_400,
                            ),
                          ],
                        ),
                        Text(
                          aluno.status.toString(),
                          style: Theme.of(context).textTheme.body16px!.copyWith(
                                color: aluno.status.toString().toLowerCase() ==
                                        'bloqueado'
                                    ? colorTheme.red_error_500
                                    : colorTheme.green_sucess_500,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        _AreaContato(colorTheme: colorTheme, aluno: aluno),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Divider(
                            color: colorTheme.grey_font_500.withOpacity(0.8),
                            thickness: 2,
                            height: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Informações do pacote do Aluno
                              InfoAlunoPacoteComEdicao(
                                onEditTap: () => showEditPackageBottomSheet(
                                    context, colorTheme, AllPacotes),
                                colorTheme: colorTheme,
                                aluno: aluno,
                              ),
                              FutureBuilder(
                                future: realizacoesFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  return _AreaMediaAvaliacao(
                                      colorTheme: colorTheme,
                                      mediaFeedbacks: mediaAvaliacoes);
                                },
                              ),

                              if (avaliacoesFuture != null)
                                FutureBuilder(
                                  future: avaliacoesFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return _AreaAvaliacoesFisicas(
                                      colorTheme: colorTheme,
                                      avaliacoes: snapshot.data!,
                                      enviarAction: () async {
                                        final result = await _escolherArquivo();
                                        if (result.files.isNotEmpty) {
                                          final controller =
                                              AvaliacaoController();
                                          final file =
                                              File(result.files.first.path!);
                                          final success = await controller
                                              .enviarPdfAvaliacao(aluno, file);
                                          if (success) {
                                            showMessageSnackBar(
                                              colorTheme,
                                              context,
                                              'Avaliação enviada com sucesso',
                                            );
                                            _fetchAvaliacoes();
                                          } else {
                                            showMessageSnackBar(
                                              colorTheme,
                                              context,
                                              'Erro ao enviar avaliação',
                                              error: true,
                                            );
                                          }
                                        }
                                      },
                                      solicitarAction: () async {
                                        final controller =
                                            AvaliacaoController();
                                        final success = await controller
                                            .solicitarAvaliacaoOnline(aluno);
                                        if (success) {
                                          showMessageSnackBar(
                                            colorTheme,
                                            context,
                                            'Avaliação solicitada com sucesso',
                                          );
                                          _fetchAvaliacoes();
                                        } else {
                                          showMessageSnackBar(
                                            colorTheme,
                                            context,
                                            'Erro ao solicitar avaliação',
                                            error: true,
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              _AreaAnamneses(
                                key: const ValueKey('anamnesetitle'),
                                colorTheme: colorTheme,
                                isLoading: _isLoading,
                                solicitarAction: () async {
                                  final controller = AnamneseController();
                                  final success =
                                      await controller.solicitarAnamnese(aluno);
                                  if (success) {
                                    showMessageSnackBar(
                                      colorTheme,
                                      context,
                                      'Anamnese solicitada com sucesso',
                                    );
                                  } else {
                                    showMessageSnackBar(
                                      colorTheme,
                                      context,
                                      'Erro ao solicitar anamnese',
                                      error: true,
                                    );
                                  }
                                },
                                visualizarAction: () async {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    // Aguarda o carregamento da anamnese
                                    final anamnese = await AnamneseController()
                                        .carregarAnamnese(aluno.id!);

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    // Verifica se a anamnese não é nula
                                    if (anamnese != null) {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesNames.anamneseForm.route,
                                        arguments: {
                                          'aluno': aluno,
                                          'anamnese': anamnese,
                                          'profileImage': aluno.imagem ?? '',
                                        },
                                      );
                                    } else {
                                      showMessageSnackBar(
                                        colorTheme,
                                        context,
                                        // ignore: lines_longer_than_80_chars
                                        'Nenhuma anamnese disponível para visualização.',
                                        error: true,
                                      );
                                    }
                                  } catch (e) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    showMessageSnackBar(
                                      colorTheme,
                                      context,
                                      'Erro ao visualizar anamnese',
                                      error: true,
                                    );
                                  }
                                },
                              ),
                              if (realizacoesFuture != null)
                                FutureBuilder(
                                    future: realizacoesFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 16.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      return _AreaFeedbacks(
                                        colorTheme: colorTheme,
                                        realizacoes: snapshot.data!,
                                        aluno: aluno,
                                      );
                                    }),
                              if (diasTreinados != [])
                                FutureBuilder(
                                  future: diasTreinados,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return _AreaCalendario(
                                        colorTheme: colorTheme,
                                        diasTreinados: snapshot.data!,
                                      );
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                              const SizedBox(height: 8),
                              Center(
                                child: PrimaryButton(
                                  label: 'Excluir Aluno',
                                  onPressed: () =>
                                      _showDeleteConfirmationDialog(
                                    context,
                                    colorTheme,
                                    () => _deleteAluno(colorTheme),
                                  ),
                                  verticalPadding: 12,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .body16px!
                                      .copyWith(
                                        color: colorTheme.white_onPrimary_100,
                                        fontWeight: FontWeight.w900,
                                      ),
                                  backgroundColor: colorTheme.red_error_500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class _AreaMediaAvaliacao extends StatelessWidget {
  const _AreaMediaAvaliacao({
    Key? key,
    required this.colorTheme,
    required this.mediaFeedbacks,
  }) : super(key: key);

  final ColorFamily colorTheme;
  final int? mediaFeedbacks;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Média de avaliação',
            style: Theme.of(context).textTheme.title18px!.copyWith(
                  color: colorTheme.black_onSecondary_100,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          IconsFeedback(colorTheme: colorTheme, selectedIndex: mediaFeedbacks!),
        ]));
  }
}

class _AreaAvaliacoesFisicas extends StatelessWidget {
  const _AreaAvaliacoesFisicas({
    Key? key,
    required this.avaliacoes,
    required this.colorTheme,
    required this.solicitarAction,
    required this.enviarAction,
  }) : super(key: key);

  final List<AvaliacaoFisica> avaliacoes;
  final ColorFamily colorTheme;
  final void Function() solicitarAction;
  final void Function() enviarAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InfoAlunoAvaliacoes(
        avaliacoes: avaliacoes,
        colorTheme: colorTheme,
        solicitarAction: solicitarAction,
        enviarAction: enviarAction,
      ),
    );
  }
}

class _AreaAnamneses extends StatelessWidget {
  const _AreaAnamneses({
    Key? key,
    required this.colorTheme,
    required this.solicitarAction,
    required this.visualizarAction,
    required this.isLoading,
  }) : super(key: key);

  final ColorFamily colorTheme;
  final void Function() solicitarAction;
  final void Function() visualizarAction;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Anamnese',
            style: Theme.of(context).textTheme.title18px!.copyWith(
                  color: colorTheme.black_onSecondary_100,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: PrimaryButton(
                  label: 'Solicitar',
                  onPressed: solicitarAction,
                  verticalPadding: 8,
                  horizontalPadding: 12,
                  textStyle: Theme.of(context).textTheme.body16px!.copyWith(
                        color: colorTheme.black_onSecondary_100,
                        fontWeight: FontWeight.w900,
                      ),
                  backgroundColor: colorTheme.lemon_secondary_400,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: isLoading
                    ? const Column(
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      )
                    : PrimaryButton(
                        label: 'Visualizar',
                        onPressed: visualizarAction,
                        verticalPadding: 8,
                        horizontalPadding: 12,
                        textStyle:
                            Theme.of(context).textTheme.body16px!.copyWith(
                                  color: colorTheme.white_onPrimary_100,
                                  fontWeight: FontWeight.w900,
                                ),
                        backgroundColor: colorTheme.indigo_primary_500,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AreaFeedbacks extends StatelessWidget {
  const _AreaFeedbacks({
    Key? key,
    required this.colorTheme,
    required this.realizacoes,
    required this.aluno,
  }) : super(key: key);

  final ColorFamily colorTheme;
  final List<RealizacaoTreino> realizacoes;
  final Aluno aluno;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Feedbacks',
          style: Theme.of(context).textTheme.title18px!.copyWith(
                color: colorTheme.black_onSecondary_100,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 8),
        if (realizacoes.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Sem treinos realizados',
                style: Theme.of(context).textTheme.body16px!.copyWith(
                      color: colorTheme.grey_font_500,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          )
        else
          FeedbackCarousel(
            colorTheme: colorTheme,
            realizacoes: realizacoes,
            aluno: aluno,
          ),
      ]),
    );
  }
}

class _AreaCalendario extends StatelessWidget {
  _AreaCalendario({
    Key? key,
    required this.colorTheme,
    required this.diasTreinados,
  }) : super(key: key);

  final ColorFamily colorTheme;
  final List<DateTime> diasTreinados;
  final DateTime hoje = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Calendário de Treinos',
          style: Theme.of(context).textTheme.title18px!.copyWith(
                color: colorTheme.black_onSecondary_100,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 8),
        CardCalendarioTreinos(
          hoje: hoje,
          diasNaoTreinados: generateDateList(
            DateTime(hoje.year, hoje.month - 2, 1),
            diasTreinados,
          ),
          diasTreinados: diasTreinados,
        ),
      ]),
    );
  }
}

class _AreaContato extends StatelessWidget {
  const _AreaContato({
    Key? key,
    required this.colorTheme,
    required this.aluno,
  }) : super(key: key);

  final ColorFamily colorTheme;
  final Aluno aluno;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícone e Telefone
          SvgPicture.asset(
            'assets/icons/whatsapp.svg',
            color: colorTheme.indigo_primary_800,
            width: 24.0,
            height: 24.0,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onTap: () {
                // Copia o email para a área de transferência
                Clipboard.setData(ClipboardData(text: aluno.telefone))
                    .then((_) {
                  showMessageSnackBar(
                    colorTheme,
                    context,
                    'Telefone copiado para a área de transferência',
                    error: false,
                  );
                });
              },
              child: Text(
                aluno.telefone,
                style: Theme.of(context).textTheme.body12px!.copyWith(
                      color: colorTheme.black_onSecondary_100,
                      fontWeight: FontWeight.w700,
                    ),
                overflow:
                    TextOverflow.ellipsis, // Adiciona truncamento se necessário
              ),
            ),
          ),
          const SizedBox(width: 20),
          Icon(Icons.email_outlined, color: colorTheme.indigo_primary_800),
          const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onTap: () {
                // Copia o email para a área de transferência
                Clipboard.setData(ClipboardData(text: aluno.email)).then((_) {
                  showMessageSnackBar(
                    colorTheme,
                    context,
                    'Email copiado para a área de transferência',
                    error: false,
                  );
                });
              },
              child: Text(
                aluno.email,
                style: Theme.of(context).textTheme.body12px!.copyWith(
                      color: colorTheme.black_onSecondary_100,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _Body extends StatelessWidget {
  final children;
  Aluno aluno;
  _Body({Key? key, this.children, required this.aluno}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.110), // Espaço para o círculo
            Expanded(
              child: Column(children: children),
            ),
          ],
        ),
        PortraitPositionedUser(
            topPadding: 0.01,
            backgroundColor: colorTheme.grey_font_500,
            imagePath: aluno.imagem),
      ],
    );
  }
}

Future<void> _showDeleteConfirmationDialog(BuildContext context,
    ColorFamily colorTheme, Future<void> Function() deleteAlunoCallback) async {
  showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Excluir Aluno',
          style: Theme.of(context).textTheme.title18px!.copyWith(
                color: colorTheme.black_onSecondary_100,
                fontWeight: FontWeight.w900,
              ),
        ),
        content: Text(
          'Tem certeza que deseja excluir este aluno?' +
              ' Esta ação não pode ser desfeita.',
          style: Theme.of(context).textTheme.body16px!.copyWith(
                color: colorTheme.black_onSecondary_100,
              ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancelar',
              style: Theme.of(context).textTheme.body16px!.copyWith(
                    color: colorTheme.black_onSecondary_100,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text(
              'Excluir',
              style: Theme.of(context).textTheme.body16px!.copyWith(
                    color: colorTheme.red_error_500,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            onPressed: () async {
              await deleteAlunoCallback();
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
