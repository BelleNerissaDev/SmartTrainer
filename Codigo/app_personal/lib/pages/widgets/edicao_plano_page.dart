import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/loading/loading.dart';
import 'package:SmartTrainer_Personal/components/container/treino_expansion_tile.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/components/snack_bar/messages_snack_bar.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/components/inputs/search_bar.dart'
    as custom;
import 'package:SmartTrainer_Personal/connections/repository/exercicio_generico_repository.dart';
import 'package:SmartTrainer_Personal/connections/repository/grupo_muscular_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/models/entity/plano.dart';
import 'package:SmartTrainer_Personal/models/entity/treino.dart';
import 'package:SmartTrainer_Personal/pages/controller/plano_treino/plano_treino_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class EdicaoPlanoPage extends StatefulWidget {
  const EdicaoPlanoPage({Key? key, this.alunoIdOnTest}) : super(key: key);
  final Future<Aluno>? alunoIdOnTest;

  @override
  _NovoPlanoTreinoState createState() => _NovoPlanoTreinoState();
}

class _NovoPlanoTreinoState extends State<EdicaoPlanoPage> {
  late Aluno aluno;
  final TextEditingController _nomeController = TextEditingController();
  String? selectedGrupoMuscularInFilter;
  late Future<List<Exercicio>> _futureTodosExercicios;
  late Future<List<GrupoMuscular>> _futureGruposMusculares;
  List<Treino> _treinos = [];
  PlanoTreino _plano = PlanoTreino(nome: '', treinos: [], status: 'Inativo');

  String? _searchQuery;
  bool showTreinos = false;
  bool isEditing = false;
  bool _isPlanoFetched = false;

  void _adicionarNovoTreino() {
    setState(() {
      int count = _treinos.length;

      // Gera a letra do próximo treino (A = 65, B = 66, etc.)
      String nomeNovoTreino = 'Treino ${String.fromCharCode(65 + count)}';

      _treinos.add(Treino(nome: nomeNovoTreino, exercicios: []));
    });
  }

  void _fetchExercicios() {
    try {
      final ExercicioGenericoRepository exercicioRepository =
          ExercicioGenericoRepository();
      _futureTodosExercicios = exercicioRepository.readAll();
    } catch (e) {
      throw Exception('Erro ao carregar todos os exercícios: $e');
    }
  }

  void _fetchGruposMusculares() {
    try {
      final GrupoMuscularRepository grupoMuscularRepository =
          GrupoMuscularRepository();
      _futureGruposMusculares = grupoMuscularRepository.readAll();
    } catch (e) {
      throw Exception('Erro ao carregar todos os exercícios: $e');
    }
  }

  Widget planoTile(Treino treino, ColorFamily colorTheme) {
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
              custom.SearchBar(
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
              _buildFilter(colorTheme),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.65,
                child: _buildList(colorTheme, treino),
              ),
            ],
          ),
        ),
      ],
    );
  }

  FutureBuilder<List<GrupoMuscular>> _buildFilter(ColorFamily colorTheme) {
    return FutureBuilder(
        future: _futureGruposMusculares,
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: gruposMusculares.length,
                      itemBuilder: (context, index) {
                        final grupo = gruposMusculares[index];
                        return Container(
                          height: 10,
                          margin: const EdgeInsets.all(5),
                          child: FilterChip(
                            backgroundColor: colorTheme.grey_font_500,
                            label: Text(
                              grupo.nome,
                              style: Theme.of(context)
                                  .textTheme
                                  .body12px!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorTheme.black_onSecondary_100,
                                  ),
                            ),
                            selected: selectedGrupoMuscularInFilter == grupo.id,
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  selectedGrupoMuscularInFilter = grupo.id;
                                } else {
                                  selectedGrupoMuscularInFilter = null;
                                }
                              });
                            },
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: selectedGrupoMuscularInFilter == grupo.id
                                    ? colorTheme.lemon_secondary_500
                                    : colorTheme.grey_font_500,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
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

  FutureBuilder<List<Exercicio>> _buildList(
      ColorFamily colorTheme, Treino treino) {
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

        // Filtra os exercícios
        List<Exercicio> exercicios = snapshot.data!;
        if (selectedGrupoMuscularInFilter != null) {
          exercicios = exercicios
              .where((exercicio) => exercicio.gruposMusculares
                  .map((grupo) => grupo.id)
                  .contains(selectedGrupoMuscularInFilter))
              .toList();
        }

        if (_searchQuery != null) {
          exercicios = exercicios
              .where((exercicio) => exercicio.nome
                  .toLowerCase()
                  .contains(_searchQuery!.toLowerCase()))
              .toList();
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: exercicios.length,
          itemBuilder: (context, index) {
            var exercicio = exercicios[index];

            bool isAdded = (treino.exercicios)
                .any((exAddedMap) => exAddedMap.id == exercicio.id);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  isAdded
                      ? setState(() {
                          (treino.exercicios).removeWhere(
                              (exAdded) => exAdded.id == exercicio.id);
                        })
                      : Navigator.pushNamed(
                          context,
                          RoutesNames.novoExercicioDoPlano.route,
                          arguments: {
                            'exercicio': exercicio,
                          },
                        ).then((exercicioAtualizado) {
                          if (exercicioAtualizado != null) {
                            setState(() {
                              (treino.exercicios).add(exercicio);
                            });
                          }
                        });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: isAdded
                        ? colorTheme.lemon_secondary_200
                        : colorTheme.light_container_500,
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

  Future<void> _editarPlanoTreino(ColorFamily colorTheme) async {
    final novoPlanoTreinoController = PlanoTreinoController();
    try {
      showLoading(context);
      // Passando o plano como um objeto `PlanoTreino`
      final planoAtualizado = PlanoTreino(
        nome: _nomeController.text,
        status: _plano
            .status, // Mantém o status original ou ajuste conforme necessário
        treinos: _treinos,
      );

      await novoPlanoTreinoController.editarPlanoTreino(
        alunoId: aluno.id!,
        planoId: _plano.id!,
        plano: planoAtualizado,
      );

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Plano de treino editado!'),
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
          content: Text('Erro ao editar o plano de treino: $e'),
          backgroundColor: colorTheme.red_error_500,
        ),
      );
      Navigator.pushNamed(
        context,
        RoutesNames.alunoPlanosTreinos.route,
        arguments: {'aluno': aluno},
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments =
        ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>?;

    if (arguments != null && !_isPlanoFetched) {
      setState(() {
        aluno = arguments['aluno'] as Aluno;
        _plano = arguments['plano'];
        _treinos = _plano.treinos;
        _nomeController.text = '${_plano.nome}';
      });
      _isPlanoFetched = true;
    }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorTheme.white_onPrimary_100),
          onPressed: () {
            Navigator.pop(context);
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
            title: 'Editar Plano de Treino',
          ),
          Expanded(
            child: CardContainer(
              colorTheme: colorTheme,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  ObscuredTextField(
                                    textCenter: true,
                                    obscureText: false,
                                    hintText: 'Digite o nome do treino',
                                    controller: _nomeController,
                                    colorTheme: colorTheme,
                                    hasBorder: false,
                                  ),
                                  Column(
                                    children: [
                                      Column(
                                        children: _treinos.map((treino) {
                                          return Column(
                                            children: [
                                              planoTile(treino, colorTheme),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 20),
                                        child: Column(
                                          children: [
                                            Divider(
                                              color: colorTheme.grey_font_500,
                                              thickness: 1,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  _adicionarNovoTreino();
                                                },
                                                icon: Icon(
                                                  Icons.add_circle,
                                                  color: colorTheme
                                                      .indigo_primary_500,
                                                  size: 30,
                                                )),
                                            Text('Adicionar novo treino',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body12px!
                                                    .copyWith(
                                                      color: colorTheme
                                                          // ignore: lines_longer_than_80_chars
                                                          .indigo_primary_700,
                                                    ))
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_nomeController.text.isEmpty) {
              showMessageSnackBar(colorTheme, context, 'Insira o nome do plano',
                  error: true);
            } else if (_treinos.any((treino) => (treino.exercicios).isEmpty)) {
              showMessageSnackBar(colorTheme, context,
                  'Todos os treinos devem ter pelo menos um exercício',
                  error: true);
            } else {
              _editarPlanoTreino(colorTheme);
            }
          },
          backgroundColor: colorTheme.lemon_secondary_500,
          child: Icon(
            Icons.check,
            size: 40,
            color: colorTheme.black_onSecondary_100,
          )),
    );
  }
}
