import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/cards/exercicio_card.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/inputs/search_bar.dart'
    as custom;
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/connections/repository/exercicio_generico_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/grupo_muscular_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciciosPage extends StatefulWidget {
  const ExerciciosPage({Key? key, this.exerciciosOnTest, this.gruposOnTest})
      : super(key: key);
  final Future<List<GrupoMuscular>>? gruposOnTest;
  final Future<List<Exercicio>>? exerciciosOnTest;
  @override
  _ExerciciosPageState createState() => _ExerciciosPageState();
}

class _ExerciciosPageState extends State<ExerciciosPage> {
  Future<List<Exercicio>>? exercicios;
  Future<List<GrupoMuscular>>? gruposMusculares;
  String? selectedGrupoMuscular;
  String? searchValue;

  void _fetchExercicios() {
    try {
      final ExercicioGenericoRepository exercicioRepository =
          ExercicioGenericoRepository();
      exercicios = exercicioRepository.readAll();
    } on FirebaseException {
      exercicios = widget.exerciciosOnTest ?? Future.value(<Exercicio>[]);
    } catch (e) {
      exercicios = Future.error(e);
    }
  }

  void _fetchGruposMusculares() {
    try {
      final GrupoMuscularRepository grupoMuscularRepository =
          GrupoMuscularRepository();
      gruposMusculares = grupoMuscularRepository.readAll();
    } on FirebaseException {
      gruposMusculares = widget.gruposOnTest ?? Future.value(<GrupoMuscular>[]);
    } catch (e) {
      gruposMusculares = Future.error(e);
    }
  }

  FutureBuilder<List<Exercicio>> _buildList(ColorFamily colorTheme) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    return FutureBuilder(
        future: exercicios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os exercícios'),
            );
          } else {
            List<Exercicio>? exercicios;
            if (selectedGrupoMuscular != null) {
              exercicios = snapshot.data!
                  .where((exercicio) => exercicio.gruposMusculares
                      .map((grupo) => grupo.id)
                      .contains(selectedGrupoMuscular))
                  .toList();
            } else {
              exercicios = snapshot.data!;
            }
            if (searchValue != null) {
              exercicios = exercicios
                  .where((exercicio) => exercicio.nome
                      .toLowerCase()
                      .contains(searchValue!.toLowerCase()))
                  .toList();
            }
            return Expanded(
              child: ListView.builder(
                itemCount: exercicios.length,
                itemBuilder: (context, index) {
                  final exercicio = exercicios![index];
                  return ExercicioCard(
                    exercicio: exercicio,
                    colorTheme: colorTheme,
                  );
                },
              ),
            );
          }
        });
  }

  FutureBuilder<List<GrupoMuscular>> _buildFilter(ColorFamily colorTheme) {
    return FutureBuilder(
        future: gruposMusculares,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os grupos musculares'),
            );
          } else {
            final List<GrupoMuscular> gruposMusculares = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                color: colorTheme.light_container_500,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_alt, color: colorTheme.grey_font_700),
                      const Text(
                        'Filtrar por grupo muscular',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: gruposMusculares.length,
                      itemBuilder: (context, index) {
                        final grupo = gruposMusculares[index];
                        return Container(
                          height: 20,
                          margin: const EdgeInsets.all(5),
                          child: FilterChip(
                            backgroundColor: colorTheme.grey_font_500,
                            label: Text(grupo.nome),
                            selected: selectedGrupoMuscular == grupo.id,
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  selectedGrupoMuscular = grupo.id;
                                } else {
                                  selectedGrupoMuscular = null;
                                }
                              });
                            },
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: selectedGrupoMuscular == grupo.id
                                    ? colorTheme.lemon_secondary_500
                                    : colorTheme.grey_font_500,
                                width: 1,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
    _fetchExercicios();
    _fetchGruposMusculares();
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
            title: 'Exercícios',
          ),
          Expanded(
            child: CardContainer(
              colorTheme: colorTheme,
              child: Column(
                children: [
                  custom.SearchBar(
                    onSearchChanged: (value) {
                      setState(() {
                        searchValue = value;
                      });
                    },
                  ),
                  _buildFilter(colorTheme),
                  _buildList(colorTheme),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          RoutesNames.novoExercicio.route,
        ),
        backgroundColor: colorTheme.lemon_secondary_500,
        child: Icon(Icons.fitness_center_rounded,
            color: colorTheme.black_onSecondary_100),
      ),
    );
  }
}
