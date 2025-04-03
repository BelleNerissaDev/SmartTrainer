import 'package:SmartTrainer/components/radio_button/icon_radio_button_group.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/models/entity/exercicio.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';
import 'package:SmartTrainer/models/entity/realizacao_exercicio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CardExercicio extends StatefulWidget {
  final Exercicio exercicio;
  final RealizacaoExercicio realizacaoExercicio;

  const CardExercicio({
    Key? key,
    required this.exercicio,
    required this.realizacaoExercicio,
  }) : super(key: key);

  @override
  _CardExercicioState createState() => _CardExercicioState();
}

class _Serie {
  final int repeticoes;
  final double carga;
  bool realizado = false;
  int tempoDescanso;
  bool isTimerActive = false;

  _Serie({
    required this.repeticoes,
    required this.carga,
    String tempoDescanso = '00:30',
  }) : tempoDescanso = _convertToSeconds(tempoDescanso);

  static int _convertToSeconds(String tempoDescanso) {
    final parts = tempoDescanso.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return minutes * 60 + seconds;
  }
}

class _CardExercicioState extends State<CardExercicio> {
  bool _expanded = false;
  List<_Serie> _series = [];
  bool _isAnyTimerActive = false;

  late TextEditingController _controller;

  Future<void> _startRestTimer(_Serie serie) async {
    setState(() {
      serie.isTimerActive = true;
      _isAnyTimerActive = true;
    });

    while (serie.tempoDescanso > 0) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        serie.tempoDescanso--;
      });
    }

    setState(() {
      serie.realizado = true;
      serie.isTimerActive = false;
      _isAnyTimerActive = false;
    });

    _checkIfAllSeriesCompleted();
  }

  void _checkIfAllSeriesCompleted() {
    if (_series.every((serie) => serie.realizado)) {
      setState(() {
        widget.exercicio.status = StatusExercicio.CONCLUIDO;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _series = List.generate(
      widget.exercicio.series,
      (index) => _Serie(
        repeticoes: widget.exercicio.repeticoes,
        carga: widget.exercicio.carga,
        tempoDescanso: widget.exercicio.intervalo,
      ),
    );
    _controller = TextEditingController(
      text: widget.realizacaoExercicio.novaCarga.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    return SizedBox(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CheckboxTheme(
                    data: CheckboxThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return colorTheme.lemon_secondary_400;
                        }
                        return colorTheme.light_container_500;
                      }),
                      checkColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        return colorTheme.black_onSecondary_100;
                      }),
                    ),
                    child: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        value: widget.exercicio.status ==
                            StatusExercicio.CONCLUIDO,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Image.network(
                    widget.exercicio.imagem ??
                        'https://placehold.co/600x400/png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 12.0),
                  SizedBox(
                    width: 150.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercicio.nome,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '''${widget.exercicio.metodologia} ${widget.exercicio.series} x ${widget.exercicio.repeticoes}''',
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.exercicio.tipoCarga ?? ''} ',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    widget.realizacaoExercicio.novaCarga =
                                        double.tryParse(value) ??
                                            widget
                                                .realizacaoExercicio.novaCarga;
                                  });
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Kg',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(_expanded ? Mdi.chevronDown : Mdi.chevronRight),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12.0),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.exercicio.descricao,
                      ),
                      if (widget.exercicio.videoUrl != null)
                        YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: YoutubePlayer.convertUrlToId(
                                widget.exercicio.videoUrl!)!,
                            flags: const YoutubePlayerFlags(
                              autoPlay: false,
                              mute: false,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.exercicio.status != StatusExercicio.CONCLUIDO) ...[
                    for (final serie in _series)
                      GestureDetector(
                        onTap: !_isAnyTimerActive &&
                                !serie.realizado &&
                                !serie.isTimerActive
                            ? () => _startRestTimer(serie)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: serie.realizado || serie.isTimerActive
                                ? colorTheme.indigo_primary_800
                                : colorTheme.white_onPrimary_100,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: serie.realizado
                                ? Icon(
                                    Mdi.checkboxMarkedCircleAutoOutline,
                                    color: colorTheme.white_onPrimary_100,
                                  )
                                : serie.isTimerActive
                                    ? Row(
                                        children: [
                                          Icon(
                                            Mdi.timerOutline,
                                            color:
                                                colorTheme.white_onPrimary_100,
                                          ),
                                          Text(
                                            '${serie.tempoDescanso}',
                                            style: TextStyle(
                                              color: colorTheme
                                                  .white_onPrimary_100,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        '''${serie.repeticoes} X ${serie.carga} Kg''',
                                      ),
                          ),
                        ),
                      ),
                  ] else ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: colorTheme.white_onPrimary_100,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: IconRadioGroup(
                        colorTheme: colorTheme,
                        icons: [
                          Mdi.emoticonCoolOutline,
                          Mdi.emoticonWinkOutline,
                          Mdi.emoticonNeutralOutline,
                          Mdi.emoticonFrownOutline,
                          Mdi.emoticonDeadOutline,
                        ],
                        selectedIconIndex:
                            widget.realizacaoExercicio.nivelEsforco.value,
                        onIconSelected: (index) {
                          setState(() {
                            widget.realizacaoExercicio.nivelEsforco =
                                NivelEsforco.values.firstWhere(
                                    (element) => element.value == index);
                          });
                        },
                      ),
                    )
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
