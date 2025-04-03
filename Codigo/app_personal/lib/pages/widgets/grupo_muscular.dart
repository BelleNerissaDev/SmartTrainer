import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/inputs/search_bar.dart'
    as custom;
import 'package:SmartTrainer_Personal/components/sections/grupo_muscular_page/list_exercicios_tile.dart';
import 'package:SmartTrainer_Personal/components/sections/grupo_muscular_page/list_todos_exercicios_builder.dart';
import 'package:SmartTrainer_Personal/components/titles/headline_titles.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/pages/controller/exercicio/exercicio_generico_controller.dart';
import 'package:SmartTrainer_Personal/pages/controller/grupo_muscular/grupo_muscular_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';

class GrupoMuscularPage extends StatefulWidget {
  const GrupoMuscularPage(
      {Key? key,
      this.grupoMuscularOnTest,
      this.exerciciosOnTest,
      this.exerciciosAssOnTest})
      : super(key: key);
  final Future<List<Exercicio>>? exerciciosOnTest;
  final Future<List<Exercicio>>? exerciciosAssOnTest;
  final GrupoMuscular? grupoMuscularOnTest;

  @override
  _GrupoMuscularPageState createState() => _GrupoMuscularPageState();
}

class _GrupoMuscularPageState extends State<GrupoMuscularPage> {
  String _searchQuery = '';

  GrupoMuscular? grupoMuscular;
  String? grupoMuscularNome;

  late Future<List<Exercicio>> _futureExerciciosAssociados;
  late Future<List<Exercicio>> _futureTodosExercicios;

  bool _isGrupoDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _futureExerciciosAssociados = Future.value(<Exercicio>[]);
    _fetchTodosExercicios();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isGrupoDataLoaded) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      grupoMuscular = arguments?['grupoMuscular'] as GrupoMuscular? ??
          widget.grupoMuscularOnTest;

      grupoMuscularNome = grupoMuscular?.nome;

      if (grupoMuscular != null) {
        // Chama a função para carregar os exercícios passando o ID do grupo
        _fetchExerciciosAssociados(grupoMuscular!.id);
      }
      _isGrupoDataLoaded = true;
    }
  }

  void _fetchExerciciosAssociados(String grupoMuscularId) {
    try {
      Future<List<Exercicio>> exercicios = GrupoMuscularController()
          .visualizarExerciciosPorGrupoMuscular([grupoMuscularId]);
      setState(() {
        _futureExerciciosAssociados = exercicios;
      });
    } on FirebaseException catch (e) {
      if (widget.exerciciosOnTest != null) {
        setState(() {
          _futureExerciciosAssociados = widget.exerciciosAssOnTest!;
        });
      } else {
        throw Exception('Erro ao carregar exercícios: $e');
      }
    } catch (e) {
      throw Exception('Erro ao carregar exercícios: $e');
    }
  }

  void _fetchTodosExercicios() {
    try {
      Future<List<Exercicio>> todosExercicios =
          ExercicioGenericoController().visualizarExercicios();
      setState(() {
        _futureTodosExercicios = todosExercicios;
      });
    } on FirebaseException catch (e) {
      if (widget.exerciciosOnTest != null) {
        setState(() {
          _futureTodosExercicios = widget.exerciciosOnTest!;
        });
      } else {
        throw Exception('Erro ao carregar exercícios: $e');
      }
    } catch (e) {
      throw Exception('Erro ao carregar todos os exercícios: $e');
    }
  }

  Future<void> _adicionarGrupoMuscularAExercicio(
      bool isAdding, String exercicioId) async {
    if (grupoMuscular == null) return;

    try {
      await GrupoMuscularController().atualizarGrupoMuscularEmExercicio(
        grupoMuscular!.id,
        exercicioId,
        isAdding: isAdding,
      );
      _fetchExerciciosAssociados(grupoMuscular!.id);
    } catch (e) {
      throw Exception('Erro ao atualizar grupo muscular ao exercício: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    return Scaffold(
      appBar: CustomAppBar(
        colorTheme: colorTheme,
        title: 'LOGO',
      ),
      drawer: Menu(colorTheme: colorTheme),
      endDrawer: NotificationMenu(colorTheme: colorTheme),
      body: Column(
        children: [
          HeaderContainer(
            colorTheme: colorTheme,
            title: 'Grupo Muscular',
          ),
          Expanded(
            child: CardContainer(
              colorTheme: colorTheme,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeadlineTitles(
                      title: grupoMuscularNome ?? 'Grupo Muscular',
                      subtile: 'Associe exercícios ao grupo muscular',
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
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
                            custom.SearchBar(
                              onSearchChanged: (query) {
                                setState(() {
                                  _searchQuery = query;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: [
                                ListTodosExerciciosBuilder(
                                  colorTheme: colorTheme,
                                  searchQuery: _searchQuery,
                                  onItemTap: (exercicio) {
                                    return () {
                                      _adicionarGrupoMuscularAExercicio(
                                          true, exercicio.id!);
                                    };
                                  },
                                  futureExerciciosAssociados:
                                      _futureExerciciosAssociados,
                                  futureTodosExercicios: _futureTodosExercicios,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exercícios associados',
                            style: Theme.of(context)
                                .textTheme
                                .headline20px!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorTheme.grey_font_700,
                                ),
                          ),
                          ListExerciciosTile(
                            colorTheme: colorTheme,
                            trailing: Icon(Icons.remove,
                                color: colorTheme.red_error_500),
                            futureExercicios: _futureExerciciosAssociados,
                            onItemTap: (exercicio) {
                              return () {
                                _adicionarGrupoMuscularAExercicio(
                                    false, exercicio.id!);
                              };
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
