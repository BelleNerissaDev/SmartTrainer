import 'dart:io';

import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/components/loading/loading.dart';
import 'package:SmartTrainer_Personal/components/radio_button/radio_button_group.dart';
import 'package:SmartTrainer_Personal/components/snack_bar/messages_snack_bar.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/connections/repository/grupo_muscular_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/exercicio.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import 'package:SmartTrainer_Personal/pages/controller/exercicio/exercicio_generico_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mask/mask.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NovoExercicioPage extends StatefulWidget {
  const NovoExercicioPage({
    Key? key,
    this.grupoMuscularOnTest,
    this.imageOnTest,
  }) : super(key: key);
  final Future<List<GrupoMuscular>>? grupoMuscularOnTest;
  final XFile? imageOnTest;
  // final Function(ImageSource source)? onImageSelected;

  @override
  _NovoExercicioPageState createState() => _NovoExercicioPageState();
}

class _NovoExercicioPageState extends State<NovoExercicioPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _metodologiaController = TextEditingController();
  final TextEditingController _cargaController = TextEditingController();
  final TextEditingController _tipoCargaController = TextEditingController();
  final TextEditingController _repeticoesController = TextEditingController();
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _intervaloController = TextEditingController();
  String? _metodologia;
  final List<GrupoMuscular> _gruposMusculares = [];

  XFile? _imagemSelecionada;

  Future<List<GrupoMuscular>>? gruposMusculares;

  YoutubePlayerController? _youtubeController;
  final TextEditingController _videoUrlController = TextEditingController();

  void _loadYoutubeVideo() {
    final url = _videoUrlController.text;
    if (YoutubePlayer.convertUrlToId(url) != null) {
      setState(() {
        _youtubeController = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(url)!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: true,
          ),
        );
      });
    } else {
      showMessageSnackBar(
          Provider.of<ThemeProvider>(context, listen: false).colorTheme,
          context,
          'URL inválida');
    }
  }

  void _removeYoutubeVideo() {
    setState(() {
      _youtubeController = null;
      _videoUrlController.clear();
    });
  }

  void _validateFields() {
    final colorTheme =
        Provider.of<ThemeProvider>(context, listen: false).colorTheme;
    if (_nomeController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Nome vazio', error: true);
    } else if (_metodologia == null && _metodologiaController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Metodologia vazia',
          error: true);
    } else if (_cargaController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Carga vazia', error: true);
    } else if (_repeticoesController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Repetições vazias',
          error: true);
    } else if (_descricaoController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Descrição vazia', error: true);
    } else if (_seriesController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Séries vazias', error: true);
    } else if (_intervaloController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Intervalo vazio', error: true);
    } else if (_imagemSelecionada == null) {
      showMessageSnackBar(colorTheme, context, 'Imagem vazia', error: true);
    } else {
      _cadastrarNovoExercicio();
    }
  }

  Future<void> _cadastrarNovoExercicio() async {
    final nomeExercicio = _nomeController.text;
    final descricao = _descricaoController.text;
    final metodologia = _metodologia ?? _metodologiaController.text;
    final carga = double.parse(_cargaController.text);
    final tipoCarga = _tipoCargaController.text;
    final repeticoes = int.parse(_repeticoesController.text);
    final series = int.parse(_seriesController.text);
    final intervalo = _intervaloController.text;
    final videoUrl = _videoUrlController.text;
    final imagem = File(_imagemSelecionada!.path);

    final success = await ExercicioGenericoController().adicionarExercicio(
      nomeExercicio: nomeExercicio,
      descricao: descricao,
      metodologia: metodologia,
      carga: carga,
      tipoCarga: tipoCarga,
      repeticoes: repeticoes,
      series: series,
      intervalo: intervalo,
      videoUrl: videoUrl,
      imagem: imagem,
      gruposMusculares: _gruposMusculares,
    );

    if (success) {
      showMessageSnackBar(
          Provider.of<ThemeProvider>(context, listen: false).colorTheme,
          context,
          'Exercício cadastrado com sucesso');
      Navigator.of(context).pop();
    } else {
      showMessageSnackBar(
          Provider.of<ThemeProvider>(context, listen: false).colorTheme,
          context,
          'Erro ao cadastrar exercício',
          error: true);
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _fetchGruposMusculares() {
    try {
      final GrupoMuscularRepository grupoMuscularRepository =
          GrupoMuscularRepository();
      gruposMusculares = grupoMuscularRepository.readAll();
    } on FirebaseException {
      gruposMusculares =
          widget.grupoMuscularOnTest ?? Future.value(<GrupoMuscular>[]);
    } catch (e) {
      gruposMusculares = Future.error(e);
    }
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
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: gruposMusculares.length,
                  itemBuilder: (context, index) {
                    final grupo = gruposMusculares[index];
                    return Container(
                      height: 8,
                      margin: const EdgeInsets.all(5),
                      child: FilterChip(
                        padding: EdgeInsets.zero,
                        backgroundColor: colorTheme.grey_font_500,
                        showCheckmark: false,
                        label: Text(
                          grupo.nome,
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        selected: _gruposMusculares.contains(grupo),
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _gruposMusculares.add(grupo);
                            } else {
                              _gruposMusculares.remove(grupo);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          }
        });
  }

  void _openDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () async {
                  showLoading(context); // Mostrar o loading
                  await _editImagem(ImageSource.camera);
                  Navigator.of(context).pop(); // Fechar o modal
                  Navigator.of(context).pop(); // Fechar o loading
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () async {
                  showLoading(context); // Mostrar o loading
                  await _editImagem(ImageSource.gallery);
                  Navigator.of(context).pop(); // Fechar o modal
                  Navigator.of(context).pop(); // Fechar o loading
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editImagem(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = widget.imageOnTest != null
        ? widget.imageOnTest
        : await picker.pickImage(
            source: source,
          );
    if (image != null) {
      setState(() {
        _imagemSelecionada = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
      endDrawer: NotificationMenu(colorTheme: colorTheme),
      body: Column(
        children: [
          HeaderContainer(
            colorTheme: colorTheme,
            title: 'Novo Exercício',
          ),
          Expanded(
            child: CardContainer(
              colorTheme: colorTheme,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ObscuredTextField(
                        obscureText: false,
                        label: 'Nome',
                        controller: _nomeController,
                        colorTheme: colorTheme,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Metodologia do exercício (Padrão)',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CustomRadioButtonGroup(
                        options: MetodologiaExercicio.values
                            .map((e) => e.toString().split('.').last)
                            .toList(),
                        groupValue: _metodologia,
                        onChanged: (value) {
                          setState(() {
                            _metodologia = value;
                          });
                        },
                        hadTextField: true,
                        colorTheme: colorTheme,
                        showError: false,
                        textFieldOption: 'Personalizado',
                        textFieldLabel: ':',
                        readOnly: false,
                        fieldWidth: 200,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Carga (Padrão)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ObscuredTextField(
                                        key: const ValueKey('NovoExInputCarga'),
                                        obscureText: false,
                                        controller: _cargaController,
                                        colorTheme: colorTheme,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    const Text('kg'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tipo de Carga',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                ObscuredTextField(
                                  key: const ValueKey('NovoExInputTipoCarga'),
                                  obscureText: false,
                                  controller: _tipoCargaController,
                                  colorTheme: colorTheme,
                                  keyboardType: TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20), // Espaço entre as linhas
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 60, // Altura fixa
                                  alignment: Alignment
                                      .center, // Centraliza verticalmente
                                  child: const Text(
                                    'Repetições (Padrão)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                ObscuredTextField(
                                  key: const ValueKey('NovoExInputRepeticoes'),
                                  obscureText: false,
                                  controller: _repeticoesController,
                                  colorTheme: colorTheme,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 60, // Altura fixa
                                  alignment: Alignment
                                      .center, // Centraliza verticalmente
                                  child: const Text(
                                    'Séries (Padrão)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                ObscuredTextField(
                                  key: const ValueKey('NovoExInputSeries'),
                                  obscureText: false,
                                  controller: _seriesController,
                                  colorTheme: colorTheme,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 60, // Altura fixa
                                  alignment: Alignment
                                      .center, // Centraliza verticalmente
                                  child: const Text(
                                    'Tempo de Descanso (Padrão)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ObscuredTextField(
                                        key:
                                            // ignore: lines_longer_than_80_chars
                                            const ValueKey(
                                                'NovoExInputIntervalo'),
                                        obscureText: false,
                                        controller: _intervaloController,
                                        colorTheme: colorTheme,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          Mask.generic(
                                            masks: ['##:##'],
                                          ),
                                        ],
                                        onEditingComplete: () {
                                          if (_intervaloController
                                              .text.isEmpty) {
                                            _intervaloController.text = '00:00';
                                          }
                                        },
                                      ),
                                    ),
                                    Icon(
                                      Icons.timer_outlined,
                                      color: colorTheme.grey_font_700,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Grupos musculares',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      _buildFilter(colorTheme),
                      const SizedBox(height: 20),
                      const Text(
                        'Descrição',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ObscuredTextField(
                        key: const ValueKey('NovoExInputDescricao'),
                        obscureText: false,
                        controller: _descricaoController,
                        colorTheme: colorTheme,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'URL do Vídeo (YouTube)',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ObscuredTextField(
                        key: const ValueKey('NovoExInputVideo'),
                        obscureText: false,
                        controller: _videoUrlController,
                        colorTheme: colorTheme,
                        onEditingComplete: _loadYoutubeVideo,
                      ),
                      if (_youtubeController != null)
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: YoutubePlayer(
                                controller: _youtubeController!,
                                showVideoProgressIndicator: false,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: colorTheme.red_error_500,
                                ),
                                onPressed: _removeYoutubeVideo,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      const Text(
                        'Imagem',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 300,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _imagemSelecionada == null
                              ? IconButton(
                                  icon: const Icon(Icons.add_a_photo),
                                  onPressed: _openDialog,
                                )
                              : Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      File(_imagemSelecionada!.path),
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: colorTheme.red_error_500,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _imagemSelecionada =
                                                null; // Remove a imagem
                                          });
                                        },
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('NovoExButtonSubmit'),
        onPressed: _validateFields,
        backgroundColor: colorTheme.lemon_secondary_500,
        child: Icon(
          Icons.check,
          color: colorTheme.black_onSecondary_100,
        ),
      ),
    );
  }
}
