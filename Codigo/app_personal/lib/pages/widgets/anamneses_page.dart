import 'package:SmartTrainer_Personal/components/cards/history_anamneses_card.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/snack_bar/messages_snack_bar.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/pages/controller/anamnese/anamnese_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnamnesesPage extends StatefulWidget {
  const AnamnesesPage({Key? key, this.alunoOnTest}) : super(key: key);
  final Future<List<Aluno>>? alunoOnTest;
  @override
  _AnamnesesPageState createState() => _AnamnesesPageState();
}

class _AnamnesesPageState extends State<AnamnesesPage> {
  late Future<List<Aluno>> _anamnesesFuture;

  @override
  void initState() {
    super.initState();
    try {
      _anamnesesFuture = AnamneseController().getAllAlunos();
    } catch (e) {
      _anamnesesFuture = widget.alunoOnTest ?? Future.value(<Aluno>[]);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      _anamnesesFuture = AnamneseController().getAllAlunos();
    } catch (e) {
      _anamnesesFuture = widget.alunoOnTest ?? Future.value(<Aluno>[]);
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
            title: 'Anamneses',
          ),
          Expanded(
            child: CardContainer(
              colorTheme: colorTheme,
              child: FutureBuilder<List<Aluno>>(
                future: _anamnesesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final alunosData = snapshot.data!;
                    return ListView(
                      children: () {
                        List<Widget> cards = [];
                        for (final aluno in alunosData) {
                          for (final anamnese in aluno.anamneses)
                            cards.add(HistoryAnamensesCard(
                              anamnese: anamnese,
                              aluno: aluno,
                              name: aluno.nome,
                              status: anamnese.status.toString(),
                              date: anamnese.data.toString(),
                              profileImage: aluno.imagem,
                            ));
                          if (aluno.anamneses.isEmpty) {
                            cards.add(HistoryAnamensesCard(
                              aluno: aluno,
                              name: aluno.nome,
                              status: 'Não solicitado',
                              date: '',
                              profileImage: aluno.imagem,
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
                                  // Recarregue os dados chamando setState
                                  setState(() {
                                    _anamnesesFuture =
                                        AnamneseController().getAllAlunos();
                                  });
                                } else {
                                  showMessageSnackBar(
                                    colorTheme,
                                    context,
                                    'Erro ao solicitar anamnese',
                                    error: true,
                                  );
                                }
                              },
                            ));
                          }
                        }
                        return cards;
                      }(),
                    );
                  } else {
                    return const Center(
                        child: Text('Nenhuma anamnese encontrada.'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
