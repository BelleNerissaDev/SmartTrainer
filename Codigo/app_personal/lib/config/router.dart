import 'package:SmartTrainer_Personal/pages/widgets/aluno_perfil_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/aluno_planos_treino.dart';
import 'package:SmartTrainer_Personal/pages/widgets/alunos_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/anamnese_form_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/anamneses_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/edicao_perfil_aluno_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/edicao_plano_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/exercicios_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/pages/widgets/grupos_musculares_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/home_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/loading_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_aluno_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_exercicio_do_plano.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_exercicio_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_pacote_page.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_plano_treino.dart';
import 'package:SmartTrainer_Personal/pages/widgets/pacotes_page.dart';
import 'package:flutter/material.dart';

enum RoutesNames {
  home('/home', const HomePage(), 'Home'),
  pacotes('/pacotes', const PacotesPage(), 'Pacotes'),
  novoPacote('/novoPacote', const NovoPacotePage(), 'Novo Pacote'),
  exercicios('/exercicios', const ExerciciosPage(), 'Exercícios'),
  alunos('/alunos', const AlunosPage(), 'Alunos'),
  novoAluno('/novoAluno', const NovoAlunoPage(), 'Novo Aluno'),
  edicaoAluno('/edicaoAluno', const EdicaoPerfilAluno(), 'Edição Perfil Aluno'),
  alunoPerfil('/alunoPerfil', const AlunoPerfil(), 'Aluno Perfil'),
  gruposMusculares(
      '/grupos', const GruposMuscularesPage(), 'Grupos Musculares'),
  grupoMuscular('/grupoMuscular', const GrupoMuscularPage(), 'Grupo Muscular'),
  anamnese('/anamnese', const AnamnesesPage(), 'Anamnese'),
  anamneseForm('/anamneseForm', const AnamneseFormPage(), 'Aluno Form'),
  loading('/loading', const LoadingPage(), 'Loading'),
  novoExercicio('/novoExercicio', const NovoExercicioPage(), 'Novo Exercício'),
  alunoPlanosTreinos('/alunoPlanosTreino', const AlunoPlanosTreino(),
      'Planos de Treino do aluno'),
  novoPlanoTreino('/novoPlanoTreino', const NovoPlanoTreino(),
      'Novo Planos de Treino do aluno'),
  novoExercicioDoPlano('/novoExercicioDoPlano', const NovoExercicioDoPlano(),
      'Novo Exercicio do plano de treino'),
  editarPlanoTreino('/editarPlanoTreino', const EdicaoPlanoPage(),
      'Edição do plano de treino'),
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
        RoutesNames.pacotes,
        RoutesNames.exercicios,
        RoutesNames.alunos,
        RoutesNames.gruposMusculares,
        RoutesNames.anamnese,
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
