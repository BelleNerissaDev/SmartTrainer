import 'package:SmartTrainer/pages/widgets/anamnese_page.dart';
import 'package:SmartTrainer/pages/widgets/avaliacoes_page.dart';
import 'package:SmartTrainer/pages/widgets/contato_page.dart';
import 'package:SmartTrainer/pages/widgets/finalizacao_treino_page.dart';
import 'package:SmartTrainer/pages/widgets/historico_treinos_page.dart';
import 'package:SmartTrainer/pages/widgets/home_page.dart';
import 'package:SmartTrainer/pages/widgets/login_page.dart';
import 'package:SmartTrainer/pages/widgets/perfil_aluno_page.dart';
import 'package:SmartTrainer/pages/widgets/questionario_avaliacao_page.dart';
import 'package:SmartTrainer/pages/widgets/realizacao_treino_page.dart';
import 'package:SmartTrainer/pages/widgets/redefinir_senha_page.dart';
import 'package:SmartTrainer/pages/widgets/treinos_page.dart';
import 'package:flutter/material.dart';

enum RoutesNames {
  home('/home', const HomePage(), 'Home'),
  treinos('/treinos', const TreinosPage(), 'Treinos'),
  anamnese('/anamnese', const AnamnesePage(), 'Anamnese'),
  avaliacoes('/avaliacoes', const AvaliacoesPage(), 'Avaliações'),
  contato('/contato', const ContatoPage(), 'Contato'),
  login('/login', const LoginPage(), 'Login'),
  redefinir_senha(
      '/redefinir_senha', const RedefinirSenhaPage(), 'Redefinir Senha'),
  perfil('/perfil', const PerfilAlunoPage(), 'Perfil do Aluno'),
  questionario_avaliacao('/questionario_avaliacao',
      const QuestionarioAvaliacaoPage(), 'Questionário de Avaliação'),
  realizacao_treino(
      '/realizacao_treino', const RealizacaoTreinoPage(),
      'Realização do Treino'),
  finalizacao_treino('/finalizacao_treino', const FinalizacaoTreinoPage(),
      'Finalização do Treino'),
  historico_treinos('/historico_treinos', const HistoricoTreinosPage(),
      'Histórico de Treinos'),
  ;

  final String _pageName;
  final String _route;
  final Widget _page;
  const RoutesNames(this._route, this._page, this._pageName);

  Widget get page => _page;
  String get route => _route;
  String get pageName => _pageName;

  static List<RoutesNames> get menuRoutes => [
        RoutesNames.home,
        RoutesNames.treinos,
        RoutesNames.anamnese,
        RoutesNames.avaliacoes,
        RoutesNames.contato,
      ];
}

class Routes {
  static Map<String, Widget Function(BuildContext)> route(
      BuildContext context) {
    return {
      for (RoutesNames route in RoutesNames.values)
        route.route: (context) => route.page,
    };
  }
}
