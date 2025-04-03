import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';
import 'package:SmartTrainer_Personal/models/entity/avaliacao_fisica.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class InfoAlunoAvaliacoes extends StatefulWidget {
  final ColorFamily colorTheme;
  final List<AvaliacaoFisica> avaliacoes;
  final void Function() solicitarAction;
  final void Function() enviarAction;

  const InfoAlunoAvaliacoes({
    Key? key,
    required this.colorTheme,
    required this.avaliacoes,
    required this.solicitarAction,
    required this.enviarAction,
  }) : super(key: key);

  @override
  _AlunoAvaliacoesInfoState createState() => _AlunoAvaliacoesInfoState();
}

class _AlunoAvaliacoesInfoState extends State<InfoAlunoAvaliacoes> {
  List<bool> _expandedStates = [];

  String formatDate(DateTime date) =>
      '''${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}''';

  @override
  void initState() {
    super.initState();
    _expandedStates = List.filled(widget.avaliacoes.length, false);
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = widget.colorTheme;
    var avaliacoes = widget.avaliacoes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Avaliações Físicas',
          style: Theme.of(context).textTheme.title18px!.copyWith(
                color: colorTheme.black_onSecondary_100,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: PrimaryButton(
                label: 'Solicitar',
                onPressed: widget.solicitarAction,
                verticalPadding: 8,
                horizontalPadding: 12,
                textStyle: Theme.of(context).textTheme.body16px!.copyWith(
                      color: colorTheme.black_onSecondary_100,
                      fontWeight: FontWeight.w900,
                    ),
                backgroundColor: colorTheme.lemon_secondary_400,
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: PrimaryButton(
                label: 'Enviar',
                onPressed: widget.enviarAction,
                verticalPadding: 8,
                horizontalPadding: 12,
                textStyle: Theme.of(context).textTheme.body16px!.copyWith(
                      color: colorTheme.white_onPrimary_100,
                      fontWeight: FontWeight.w900,
                    ),
                backgroundColor: colorTheme.indigo_primary_500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: avaliacoes.length,
          itemBuilder: (context, index) {
            final avaliacao = avaliacoes[index];
            final isExpanded = _expandedStates[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        avaliacao.tipoAvaliacao == TipoAvaliacao.pdf
                            ? Icons.picture_as_pdf
                            : Icons.language,
                        color: colorTheme.indigo_primary_800,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        avaliacao.tipoAvaliacao == TipoAvaliacao.pdf
                            ? formatDate(avaliacao.data)
                            : '''Avaliação ${formatDate(avaliacao.data)}''',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      if (avaliacao.tipoAvaliacao == TipoAvaliacao.online &&
                          avaliacao.status == StatusAvaliacao.realizada)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _expandedStates[index] = !_expandedStates[index];
                            });
                          },
                          child: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                  if (isExpanded &&
                      avaliacao.tipoAvaliacao == TipoAvaliacao.online)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRowWithIcon(
                            context: context,
                            colorTheme: colorTheme,
                            label: 'IMC:',
                            value: ' ${avaliacao.imc?.toStringAsFixed(2)}',
                            icon: Icons.check_circle,
                            iconColor: colorTheme.green_sucess_500,
                            description: 'Peso ideal',
                          ),
                          _buildRowWithIcon(
                            context: context,
                            colorTheme: colorTheme,
                            label: 'Percentual de gordura:',
                            value:
                                ''' ${avaliacao.percentualGordura?.toStringAsFixed(2)}%''',
                            icon: Icons.cancel,
                            iconColor: colorTheme.red_error_500,
                            description: 'Médio',
                          ),
                          _buildRowWithIcon(
                            context: context,
                            colorTheme: colorTheme,
                            label: 'Relação cintura-quadril:',
                            value:
                                ''' ${avaliacao.relacaoCinturaQuadril?.toStringAsFixed(2)}''',
                            icon: Icons.check_circle,
                            iconColor: colorTheme.green_sucess_500,
                            description: 'Moderado',
                          ),
                          _buildRowWithIcon(
                            colorTheme: colorTheme,
                            context: context,
                            label: 'Peso de gordura:',
                            value:
                                ''' ${avaliacao.pesoGordura?.toStringAsFixed(2)}kg''',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRowWithIcon({
    required String label,
    required String value,
    required context,
    required colorTheme,
    IconData? icon,
    Color? iconColor,
    String? description,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.body12px!.copyWith(
                  color: colorTheme.black_onSecondary_100,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.body12px!.copyWith(
                  color: colorTheme.grey_font_700,
                ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 8),
            Icon(icon, color: iconColor, size: 18),
          ],
          if (description != null) ...[
            const SizedBox(width: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 10,
                color: colorTheme.black_onSecondary_100,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
