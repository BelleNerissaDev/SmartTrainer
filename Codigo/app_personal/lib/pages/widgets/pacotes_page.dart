import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/cards/package_card.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/pages/controller/pacote/pacote_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';

class PacotesPage extends StatefulWidget {
  const PacotesPage({Key? key, this.pacotesOnTest}) : super(key: key);

  final Future<List<Pacote>>? pacotesOnTest;

  @override
  _PacotesPageState createState() => _PacotesPageState();
}

class _PacotesPageState extends State<PacotesPage> {
  late PacoteController _controller;
  Future<List<Pacote>>? _futurePacotes;

  @override
  void initState() {
    super.initState();
    _fetchPacotes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchPacotes();
  }

  void _fetchPacotes() {
    // Sempre que for usar algo que precise do firebase
    //colocar dentro de um try catch
    // assim ele não quebra nos testes
    // quando eu achar uma solução melhor eu implemento
    try {
      _controller = PacoteController();
      setState(() {
        _futurePacotes = _controller.visualizarPacotes();
      });
    } on FirebaseException {
      _futurePacotes = widget.pacotesOnTest ?? Future.value(<Pacote>[]);
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
            title: 'Pacotes de treino',
          ),
          Expanded(
            child: CardContainer(
              colorTheme: colorTheme,
              child: FutureBuilder<List<Pacote>>(
                future: _futurePacotes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child:
                          Text('Erro ao carregar pacotes: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhum pacote encontrado'));
                  }
                  final pacotes = snapshot.data!;
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: pacotes.length,
                          itemBuilder: (context, index) {
                            final pacote = pacotes[index];
                            return PackageCard(
                              colorTheme: colorTheme,
                              packageName: pacote.nome,
                              packageValue: pacote.valorMensal,
                              accessCount: int.parse(pacote.numeroAcessos),
                              packageId: pacote.id ?? '',
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            RoutesNames.novoPacote.route,
            arguments: null,
          );
        },
        backgroundColor: colorTheme.lemon_secondary_500,
        child: SvgPicture.asset(
          'assets/icons/package_plus.svg',
          color: colorTheme.black_onSecondary_100,
          width: 30.0,
          height: 30.0,
        ),
      ),
    );
  }
}
