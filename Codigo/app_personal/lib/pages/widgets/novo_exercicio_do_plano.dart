import 'dart:io';

import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/fonts.dart';
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
import 'package:flutter/material.dart';
import 'package:mask/mask.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NovoExercicioDoPlano extends StatefulWidget {
  final Exercicio? exercicioOnTest;
  const NovoExercicioDoPlano({Key? key, this.exercicioOnTest})
      : super(key: key);

  @override
  _NovoExercicioPageState createState() => _NovoExercicioPageState();
}

class _NovoExercicioPageState extends State<NovoExercicioDoPlano> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _metodologiaController = TextEditingController();
  final TextEditingController _cargaController = TextEditingController();
  final TextEditingController _tipoCargaController = TextEditingController();
  final TextEditingController _repeticoesController = TextEditingController();
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _intervaloController = TextEditingController();
  String? _metodologia;
  XFile? _imagemSelecionada;
  final ImagePicker _picker = ImagePicker();
  YoutubePlayerController? _youtubeController;
  final TextEditingController _videoUrlController = TextEditingController();

  List<GrupoMuscular> _gruposMusculares = [];
  Future<List<GrupoMuscular>>? gruposMusculares;

  late Exercicio exercicio;

  bool isValidated = false;
  bool _isExercicioDataLoaded = false;

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
    } else if (_videoUrlController.text != '') {
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

  Future<void> _validateFields() async {
    final colorTheme =
        Provider.of<ThemeProvider>(context, listen: false).colorTheme;
    if (_metodologia == null && _metodologiaController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Metodologia vazia',
          error: true);
    } else if (_cargaController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Carga vazia', error: true);
    } else if (_repeticoesController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Repetições vazias',
          error: true);
    } else if (_intervaloController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Intervalo vazio', error: true);
    } else if (_descricaoController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Descrição vazia', error: true);
    } else if (_seriesController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Séries vazias', error: true);
    } else if (_intervaloController.text.isEmpty) {
      showMessageSnackBar(colorTheme, context, 'Intervalo vazio', error: true);
    } else {
      isValidated = true;
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
      gruposMusculares = grupoMuscularRepository.readAll().then((result) {
        setState(() {
          _gruposMusculares = exercicio.gruposMusculares;
        });

        return result;
      });
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

            // Ordena a lista para que os selecionados venham primeiro
            gruposMusculares.sort((a, b) {
              final isASelected = _gruposMusculares.any((g) => g.id == a.id);
              final isBSelected = _gruposMusculares.any((g) => g.id == b.id);

              // Coloca os selecionados (isASelected == true) antes
              if (isASelected && !isBSelected) {
                return -1;
              } else if (!isASelected && isBSelected) {
                return 1;
              }
              return 0; // Mantém a ordem original para o restante
            });

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
                        selected:
                            _gruposMusculares.any((g) => g.id == grupo.id),
                        onSelected: (isSelected) {},
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
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      setState(() {
        _imagemSelecionada = image;
      });
    }
  }

  void _updateControllers(Exercicio exercicio) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nomeController.text = exercicio.nome;
      _descricaoController.text = exercicio.descricao;
      _metodologiaController.text = exercicio.metodologia.toString();
      _cargaController.text = exercicio.carga.toString();
      _tipoCargaController.text = exercicio.tipoCarga.toString();
      _repeticoesController.text = exercicio.repeticoes.toString();
      _seriesController.text = exercicio.series.toString();
      // TODO Temporario
      _intervaloController.text = exercicio.intervalo.isEmpty
          ? '00:00'
          : exercicio.intervalo.toString();
      _videoUrlController.text = exercicio.videoUrl ?? '';
      // Carrega a metodologia personalizada se for o caso
      _metodologia = exercicio.metodologia.toString();

      // Atualiza a lista de grupos musculares selecionados
      _gruposMusculares.clear();
      if (exercicio.gruposMusculares.isNotEmpty) {
        _gruposMusculares.addAll(exercicio.gruposMusculares);
      }
      // Atualiza o controle do vídeo do YouTube
      if (exercicio.videoUrl != null) {
        _loadYoutubeVideo();
      }
      // Carregar imagem se houver
      if (exercicio.imagem != null && exercicio.imagem!.isNotEmpty) {
        setState(() {
          _imagemSelecionada = XFile(exercicio.imagem!);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchGruposMusculares();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isExercicioDataLoaded) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null) {
        exercicio = arguments['exercicio'] as Exercicio;
        _updateControllers(exercicio);
      }
      else if (widget.exercicioOnTest != null) {
        exercicio = widget.exercicioOnTest!;
        _updateControllers(exercicio);
      }
      _isExercicioDataLoaded = true;
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
                      Center(
                        child: Text(
                          exercicio.nome,
                          style: Theme.of(context)
                              .textTheme
                              .title18px!
                              .copyWith(
                                  color: colorTheme.indigo_primary_800,
                                  fontWeight: FontWeight.bold),
                        ),
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
                          width: 200,
                          height: 150,
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
                                    _imagemSelecionada!.path.startsWith('http')
                                        ? Image.network(
                                            _imagemSelecionada!.path,
                                            fit: BoxFit.fill,
                                          )
                                        : Image.file(
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
                      const SizedBox(height: 20),
                      const Text(
                        'Metodologia do exercício (Padrão)',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomRadioButtonGroup(
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
                          controllerTextField: _metodologiaController,
                          textFieldOption: 'Personalizado',
                          textFieldLabel: ':',
                          readOnly: false,
                          fieldWidth: 200,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
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
                                                _intervaloController.text =
                                                    '00:00';
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _validateFields();
          if (isValidated) {
            Navigator.pop(context, exercicio);
          }
        },
        backgroundColor: colorTheme.lemon_secondary_500,
        child: Icon(
          Icons.check,
          size: 30,
          color: colorTheme.black_onSecondary_100,
        ),
      ),
    );
  }
}
