import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/container/plano_expansion_tile.dart';
import 'package:SmartTrainer_Personal/components/container/treino_expansion_tile.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/connections/repository/exercicio_generico_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/plano.dart';
import 'package:SmartTrainer_Personal/models/entity/treino.dart';
import 'package:SmartTrainer_Personal/pages/controller/plano_treino/plano_treino_controller.dart';
import 'package:SmartTrainer_Personal/utils/get_first_last_aluno_name.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class AlunoPlanosTreino extends StatefulWidget {
  const AlunoPlanosTreino(
      {Key? key, this.alunoOnTest, this.exerciciosOnTest, this.planosOnTest})
      : super(key: key);
  final Future<Aluno>? alunoOnTest;
  final Future<List<PlanoTreino>>? planosOnTest;
  final Future<List<Exercicio>>? exerciciosOnTest;
  @override
  _AnamnesesPageState createState() => _AnamnesesPageState();
}

class _AnamnesesPageState extends State<AlunoPlanosTreino> {
  Aluno? aluno;
  late Future<List<Exercicio>> _futureTodosExercicios;
  String? selectedGrupoMuscularInFilter;
  Future<List<PlanoTreino>> _futurePlanos = Future.value([]);

  bool _isPlanoFetched = false;

  void _fetchExercicios() {
    try {
      final ExercicioGenericoRepository exercicioRepository =
          ExercicioGenericoRepository();
      _futureTodosExercicios = exercicioRepository.readAll();
    } on FirebaseException {
      _futureTodosExercicios =
          widget.exerciciosOnTest ?? Future.value(<Exercicio>[]);
    } catch (e) {
      throw Exception('Erro ao carregar todos os exercícios: $e');
    }
  }

  Future<void> _deletarPlanoTreino(
      ColorFamily colorTheme, String planoId) async {
    final novoPlanoTreinoController = PlanoTreinoController();
    try {
      await novoPlanoTreinoController.deletarPlanoTreino(
        alunoId: aluno!.id!,
        planoId: planoId,
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Plano de treino deletado!'),
          backgroundColor: colorTheme.green_sucess_500,
        ),
      );
      Navigator.pushNamed(
        context,
        RoutesNames.alunoPlanosTreinos.route,
        arguments: {'aluno': aluno},
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deletar o plano de treino: $e'),
          backgroundColor: colorTheme.red_error_500,
        ),
      );
      Navigator.pushNamed(context, RoutesNames.alunoPlanosTreinos.route,
          arguments: {'aluno': aluno});
    }
  }

  Future<void> _ativarPlanoTreino(
      ColorFamily colorTheme, String planoId) async {
    final novoPlanoTreinoController = PlanoTreinoController();
    try {
      await novoPlanoTreinoController.ativarPlanoTreino(
        alunoId: aluno!.id!,
        planoId: planoId,
      );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Plano de treino desativado!'),
          backgroundColor: colorTheme.green_sucess_500,
        ),
      );
      Navigator.pushNamed(
        context,
        RoutesNames.alunoPlanosTreinos.route,
        arguments: {'aluno': aluno},
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao desativar o plano de treino: $e'),
          backgroundColor: colorTheme.red_error_500,
        ),
      );
      Navigator.pushNamed(context, RoutesNames.alunoPlanosTreinos.route,
          arguments: {'aluno': aluno});
    }
  }

  Future<List<PlanoTreino>> _fetchPlanosDoAluno(String alunoId, context) async {
    try {
      final PlanoTreinoController planoTreinoController =
          PlanoTreinoController();

      List<PlanoTreino> planos =
          await planoTreinoController.fetchTodosPlanosTreinoAluno(alunoId);

      if (planos.isNotEmpty) {
        return planos;
      } else {
        throw Exception('Nenhum plano encontrado para o aluno selecionado.');
      }
    } on FirebaseException {
      return widget.planosOnTest ?? Future.value(<PlanoTreino>[]);
    } catch (e) {
      throw Exception('Erro ao visualizar planos de treino: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments['aluno'] != null && !_isPlanoFetched) {
      aluno = arguments['aluno'] as Aluno;
      _futurePlanos = _fetchPlanosDoAluno(aluno!.id!, context);
      _isPlanoFetched = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExercicios();
    if (widget.planosOnTest != null &&
        widget.exerciciosOnTest != null &&
        !_isPlanoFetched) {
      _futurePlanos = widget.planosOnTest!;
      _futureTodosExercicios = widget.exerciciosOnTest!;
      _isPlanoFetched = true;
    }
  }

  Widget buildPlanosList(List<PlanoTreino> planos, ColorFamily colorTheme) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: planos.length,
      itemBuilder: (context, index) {
        PlanoTreino plano = planos[index];

        // Extrai os treinos do plano atual
        List<Treino> treinos = plano.treinos;

        return PlanoExpansionTile(
          colorTheme: colorTheme,
          title: plano.nome,
          status: plano.status,
          editFunction: () => {
            Navigator.pushNamed(
              context,
              RoutesNames.editarPlanoTreino.route,
              arguments: {
                'aluno': aluno,
                'plano': plano,
              },
            ),
          },
          deleteFunction: () => _deletarPlanoTreino(colorTheme, plano.id!),
          deactivateFunction: () => _ativarPlanoTreino(colorTheme, plano.id!),
          children: <Widget>[
            // Iterar sobre os treinos do plano e exibir cada um
            ...treinos.map((treino) {
              return TreinoExpansionTile(
                colorTheme: colorTheme,
                title: treino.nome,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      color: colorTheme.light_container_500,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: colorTheme.grey_font_500,
                          offset: const Offset(0, 4),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.65,
                          child: _buildExerciciosList(
                              colorTheme, treino.exercicios),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        );
      },
    );
  }

  FutureBuilder<List<Exercicio>> _buildExerciciosList(
      ColorFamily colorTheme, List<Exercicio> treino) {
    return FutureBuilder<List<Exercicio>>(
      future: _futureTodosExercicios,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar exercícios: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Nenhum exercício encontrado.'),
          );
        }

        // Filtra os exercícios para exibir apenas os que estão no plano
        List<Exercicio> exercicios = snapshot.data!
            .where((exercicio) => treino.any((ex) => ex.id == exercicio.id))
            .toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: exercicios.length,
          itemBuilder: (context, index) {
            var exercicio = exercicios[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: colorTheme.light_container_500,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 8.0),
                    leading:
                        exercicio.imagem != null && exercicio.imagem!.isNotEmpty
                            ? Image.network(
                                exercicio.imagem!,
                                width: 70,
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              )
                            : Image.asset(
                                'assets/images/avancoEx.jpeg',
                                width: 70,
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                              ),
                    title: Text(exercicio.nome,
                        style: Theme.of(context).textTheme.label14px!.copyWith(
                              color: colorTheme.grey_font_700,
                            )),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorTheme.white_onPrimary_100),
          onPressed: () {
            Navigator.pushNamed(context, RoutesNames.alunoPerfil.route,
                arguments: aluno);
          },
        ),
        colorTheme: colorTheme,
        title: 'LOGO',
      ),
      drawer: Menu(colorTheme: colorTheme),
      endDrawer: NotificationMenu(colorTheme: colorTheme),
      body: Column(
        children: [
          HeaderContainer(
            colorTheme: colorTheme,
            title: 'Planos de ' + getFirstAndLastName(aluno?.nome ?? ''),
          ),
          Expanded(
            child: CardContainer(
              colorTheme: colorTheme,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FutureBuilder<List<PlanoTreino>>(
                  future: _futurePlanos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Nenhum plano encontrado'));
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('Erro ao carregar planos'));
                    } else {
                      return buildPlanosList(snapshot.data!, colorTheme);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          RoutesNames.novoPlanoTreino.route,
          arguments: {
            'aluno': aluno,
          },
        ),
        backgroundColor: colorTheme.lemon_secondary_500,
        child: Icon(Icons.add, color: colorTheme.black_onSecondary_100),
      ),
    );
  }
}
