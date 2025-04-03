import 'dart:io';

import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/card_avaliacao.dart';
import 'package:SmartTrainer/components/header/header.dart';
import 'package:SmartTrainer/components/loading/loading.dart';
import 'package:SmartTrainer/components/menu.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/connections/repository/avaliacao_fisica_repository.dart';
import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AvaliacoesPage extends StatefulWidget {
  final Future<List<AvaliacaoFisica>>? avaliacoesOnTest;

  const AvaliacoesPage({Key? key, this.avaliacoesOnTest}) : super(key: key);
  @override
  _AvaliacoesPageState createState() => _AvaliacoesPageState();
}

class _AvaliacoesPageState extends State<AvaliacoesPage> with RouteAware {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  final ordenacoes = <String>[
    'Mais recentes primeiro',
    'Mais antigas primeiro'
  ];
  int ordenacaoSelecionada = 0;
  Future<List<AvaliacaoFisica>>? avaliacoes;
  List<bool> _expandedStates = [];

  Future<void> _fetchAvaliacoes() async {
    try {
      final avaliacaoFisicaRepository = AvaliacaoFisicaRepository();
      final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);

      final aluno = alunoProvider.aluno;

      setState(() {
        avaliacoes = avaliacaoFisicaRepository.readByAlunoId(aluno!.id!);
        avaliacoes!.then((onValue) {
          setState(() {
            _expandedStates = List.filled(onValue.length, false);
          });
          onValue.forEach((el) => aluno.addAvaliacaoFisica(el));
        });
      });
    } on FirebaseException {
      setState(() {
        avaliacoes =
            widget.avaliacoesOnTest ?? Future.value(<AvaliacaoFisica>[]);
      });
      avaliacoes!.then((onValue) {
        setState(() {
          _expandedStates = List.filled(onValue.length, false);
        });
      });
      return;
    }
  }

  Future<void> setAction(AvaliacaoFisica avaliacao) async {
    if (avaliacao.tipoAvaliacao == TipoAvaliacao.online &&
        avaliacao.status == StatusAvaliacao.pendente) {
      Navigator.of(context).pushNamed(
        '/questionario_avaliacao',
        arguments: avaliacao,
      );
    }

    if (avaliacao.tipoAvaliacao == TipoAvaliacao.pdf) {
      showLoading(context);
      final url = avaliacao.linkArquivo!;

      try {
        // Baixar o arquivo
        String filePath = await downloadFile(url, 'avaliacao.pdf');

        // Abrir o arquivo
        await OpenFile.open(filePath);
        Navigator.of(context).pop(); // Fechar o loading
      } catch (e) {
        //TODO: tratar erro
      }
    }
  }

  Future<String> downloadFile(String url, String fileName) async {
    // Obter o diretório temporário para salvar o arquivo
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/$fileName';

    // Fazer o download do arquivo usando o Dio
    Dio dio = Dio();
    await dio.download(url, tempPath);

    return tempPath;
  }

  @override
  void initState() {
    super.initState();
    _fetchAvaliacoes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _fetchAvaliacoes();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    final colorTheme = brightness == Brightness.light
        ? CustomTheme.colorFamilyLight
        : CustomTheme.colorFamilyDark;

    return Scaffold(
        drawer: Menu(colorTheme: colorTheme),
        appBar: Header(
          colorTheme: colorTheme,
        ),
        body: Column(
          children: [
            const Center(
              child: Text(
                'Minhas Avaliações',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    ordenacaoSelecionada = (ordenacaoSelecionada + 1) % 2;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (ordenacaoSelecionada == 1)
                      const Icon(Mdi.sortCalendarDescending),
                    if (ordenacaoSelecionada == 0)
                      const Icon(Mdi.sortCalendarAscending),
                    Text(ordenacoes[ordenacaoSelecionada]),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: avaliacoes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('nenhuma avaliação cadastrada'),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  data.sort((a, b) {
                    if (ordenacaoSelecionada == 0) {
                      return b.data.compareTo(a.data);
                    } else {
                      return a.data.compareTo(b.data);
                    }
                  });
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final avaliacao = data[index];
                        final isExpanded = _expandedStates[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: CardAvaliacao(
                            avaliacao: avaliacao,
                            colorTheme: colorTheme,
                            isExpanded: isExpanded,
                            onTap: () {
                              setState(() {
                                _expandedStates[index] =
                                    !_expandedStates[index];
                              });
                            },
                            action: () {
                              setAction(avaliacao);
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center();
              },
            )
          ],
        ));
  }
}
