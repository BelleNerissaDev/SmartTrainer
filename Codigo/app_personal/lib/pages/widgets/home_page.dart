import 'package:SmartTrainer_Personal/components/cards/feedback_home_carrousel.dart';
import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/avaliacao_fisica_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/plano_treinos_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/realizacao_treino_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/realizacao_treino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:SmartTrainer_Personal/components/titles/home_section_title.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/sections/statistics_dot.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numPlanos = 0;
  int numAlunos = 0;
  int numAvaliacoes = 0;
  List<RealizacaoTreino> realizacoes = [];

  Future<void> _fetchData() async {
    try {
      final planoTreinoRepository = PlanoTreinoRepository();
      final alunosRepository = AlunoRepository();
      final avaliacaoFisicaRepository = AvaliacaoFisicaRepository();
      final realizacaoTreinoRepository = RealizacaoTreinoRepository();

      final numPlanos = planoTreinoRepository.countAllAtivos();
      final numAlunos = alunosRepository.countAll();
      final numAvaliacoes = avaliacaoFisicaRepository.countAllPendentes();
      final realizacoes =
          realizacaoTreinoRepository.findAllUltimaSemana(DateTime.now());

      numPlanos.then((value) => setState(() => this.numPlanos = value));
      numAlunos.then((value) => setState(() => this.numAlunos = value));
      numAvaliacoes.then((value) => setState(() => this.numAvaliacoes = value));
      realizacoes.then((value) => setState(() => this.realizacoes = value));
    } on FirebaseException {
      numPlanos = 0;
      numAlunos = 0;
      numAvaliacoes = 0;
      realizacoes = [];
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    return Scaffold(
      drawer: Menu(colorTheme: colorTheme),
      endDrawer: NotificationMenu(colorTheme: colorTheme),
      appBar: CustomAppBar(
        colorTheme: colorTheme,
        title: 'LOGO',
      ),
      body: Column(
        children: [
          HeaderContainer(
            colorTheme: colorTheme,
            title: 'Bem-vinda, Aline!',
          ),
          Expanded(
            child: CardContainer(
              colorTheme: colorTheme,
              child: Column(children: [
                Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatisticsDot(
                          colorTheme: colorTheme,
                          title: 'Alunos cadastrados',
                          count: numAlunos,
                          backgroundColor: colorTheme.indigo_primary_500,
                          textColor: Colors.white,
                        ),
                        StatisticsDot(
                          colorTheme: colorTheme,
                          title: 'Planos de treino',
                          count: numPlanos,
                          backgroundColor: colorTheme.indigo_primary_500,
                          textColor: Colors.white,
                        ),
                        StatisticsDot(
                          colorTheme: colorTheme,
                          title: 'Avaliações físicas pendentes',
                          count: numAvaliacoes,
                          backgroundColor: colorTheme.lemon_secondary_400,
                          textColor: Colors.black,
                        ),
                      ]),
                ),
                const SizedBox(height: 20),
                Center(
                  child: HomeSectionTitle(
                    titleBold: 'Feedbacks',
                    titleRegular: 'da semana',
                    onLinkTap: () {
                      // Ação ao clicar no link
                    },
                  ),
                ),
                const SizedBox(height: 5),
                if (realizacoes.isEmpty)
                  Center(
                    child: Text(
                      'Nenhum feedback recebido na última semana',
                      style: TextStyle(
                        color: colorTheme.grey_font_700,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                FeedbackCarousel(
                  colorTheme: colorTheme,
                  realizacoes: realizacoes,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
