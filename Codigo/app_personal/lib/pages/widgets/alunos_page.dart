import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/inputs/search_bar.dart'
    as custom;
import 'package:SmartTrainer_Personal/components/cards/student_card.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlunosPage extends StatefulWidget {
  final List<Aluno>? alunosOnTest;
  const AlunosPage({Key? key, this.alunosOnTest}) : super(key: key);
  @override
  _AlunosPageState createState() => _AlunosPageState();
}

class _AlunosPageState extends State<AlunosPage> {
  late Future<List<Aluno>> alunos;
  String _searchQuery = '';

  Future<void> getAlunos() async {
    try {
      final AlunoRepository alunoRepository = AlunoRepository();
      alunos = alunoRepository.readAll();
    } on FirebaseException {
      if (widget.alunosOnTest != null) {
        alunos = Future.value(widget.alunosOnTest);
      } else {
        alunos = Future.value(List<Aluno>.empty());
      }
    } catch (e) {
      alunos = Future.error(e);
    }
  }

  List<Aluno> _filterAlunos(List<Aluno> alunos) {
    if (_searchQuery.isEmpty) {
      return alunos;
    }
    return alunos
        .where((aluno) =>
            aluno.nome.toLowerCase().startsWith(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAlunos();
  }

  @override
  void initState() {
    super.initState();
    getAlunos();
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
            title: 'Seus Alunos',
          ),
          Expanded(
            child: CardContainer(
              colorTheme: colorTheme,
              child: Column(
                children: [
                  custom.SearchBar(
                    onSearchChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                  ),
                  FutureBuilder(
                    future: alunos,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        final allUsers = snapshot.data!;
                        final filteredUsers = _filterAlunos(allUsers);

                        if (filteredUsers.isEmpty) {
                          return const Expanded(
                            child: Center(
                              child: Text('Nenhum aluno encontrado'),
                            ),
                          );
                        }

                        return Expanded(
                          child: ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final aluno = filteredUsers[index];
                              return StudentCard(
                                aluno: aluno,
                                colorTheme: colorTheme,
                              );
                            },
                          ),
                        );
                      }
                      return const Center(
                        child: Text('Erro ao buscar os alunos'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          RoutesNames.novoAluno.route,
        ),
        backgroundColor: colorTheme.lemon_secondary_500,
        child: Icon(Icons.person_add, color: colorTheme.black_onSecondary_100),
      ),
    );
  }
}
