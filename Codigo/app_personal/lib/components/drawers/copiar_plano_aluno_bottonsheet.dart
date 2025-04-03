import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/components/inputs/search_bar.dart'
    as custom;
import 'package:flutter/material.dart';

class StudentListBottomSheet extends StatefulWidget {
  final List<Aluno>? alunosOnTest;
  final ColorFamily colorTheme;
  const StudentListBottomSheet(
      {Key? key, required this.colorTheme, this.alunosOnTest})
      : super(key: key);

  @override
  _StudentListBottomSheetState createState() => _StudentListBottomSheetState();
}

class _StudentListBottomSheetState extends State<StudentListBottomSheet> {
  late Future<List<Aluno>> _futureAlunos;
  List<Aluno> filteredAlunos = [];
  String _searchQuery = '';

  Future<void> getAlunos() async {
    try {
      final AlunoRepository alunoRepository = AlunoRepository();
      _futureAlunos = alunoRepository.readAllWithPlanos();
      _futureAlunos.then((value) {
        setState(() {
          filteredAlunos = value;
        });
      });
    } catch (e) {
      if (widget.alunosOnTest != null) {
        _futureAlunos = Future.value(widget.alunosOnTest);
        filteredAlunos = widget.alunosOnTest!;
      } else {
        _futureAlunos = Future.error(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAlunos();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = widget.colorTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorTheme.light_container_500,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            custom.SearchBar(onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            }),
            FutureBuilder<List<Aluno>>(
              future: _futureAlunos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao buscar alunos'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum aluno encontrado.'));
                }

                // Filtering students based on search query
                final filteredAlunos = snapshot.data!
                    .where((aluno) => aluno.nome
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();

                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredAlunos.length,
                    itemBuilder: (context, index) {
                      final aluno = filteredAlunos[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.colorTheme.white_onPrimary_100,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundImage: aluno.imagem != null
                                  ? NetworkImage(aluno.imagem!)
                                  : null,
                              child: aluno.imagem == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Text(
                              aluno.nome,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: widget.colorTheme.grey_font_700,
                              ),
                            ),
                            onTap: () {
                              // Ação ao selecionar um aluno
                              Navigator.pop(context, aluno);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<Aluno?> showStudentListBottomSheet(
    BuildContext context, ColorFamily colorTheme) {
  return showModalBottomSheet<Aluno>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return StudentListBottomSheet(colorTheme: colorTheme);
    },
  );
}
