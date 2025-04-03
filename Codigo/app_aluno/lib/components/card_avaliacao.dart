import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer/utils/formatters.dart';
import 'package:flutter/material.dart';

class CardAvaliacao extends StatelessWidget {
  final AvaliacaoFisica avaliacao;
  final MyColorFamily colorTheme;
  final bool isExpanded;
  final void Function() onTap;
  final void Function() action;

  const CardAvaliacao({
    Key? key,
    required this.avaliacao,
    required this.colorTheme,
    required this.isExpanded,
    required this.onTap,
    required this.action,
  }) : super(key: key);

  Widget _buildRowWithIcon({
    required String label,
    required String value,
    required context,
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
            style: TextStyle(
              color: colorTheme.black_onSecondary_100,
              fontWeight: FontWeight.bold,
                fontSize: 14
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colorTheme.gray_800,
              fontSize: 18
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 8),
            Icon(icon, color: iconColor, size: 18),
          ],
          if (description != null) ...[
            const SizedBox(width: 8),
            Text(
              overflow: TextOverflow.ellipsis,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (avaliacao.status == StatusAvaliacao.pendente)
                    Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Icon(
                        Icons.error,
                        color: colorTheme.red_error_500,
                        size: 28,
                      ),
                    ),
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
                      onTap: onTap,
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              if (isExpanded && avaliacao.tipoAvaliacao == TipoAvaliacao.online)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRowWithIcon(
                        context: context,
                        label: 'IMC:',
                        value: ' ${avaliacao.imc?.toStringAsFixed(2)}',
                        icon: Icons.check_circle,
                        iconColor: colorTheme.green_sucess_500,
                        description: 'Peso ideal',
                      ),
                      _buildRowWithIcon(
                        context: context,
                        label: 'Percentual de gordura:',
                        value:
                            '''${avaliacao.percentualGordura?.toStringAsFixed(2)}%''',
                        icon: Icons.cancel,
                        iconColor: colorTheme.red_error_500,
                        description: 'Médio',
                      ),
                      _buildRowWithIcon(
                        context: context,
                        label: 'Relação cintura-quadril:',
                        value:
                            ''' ${avaliacao.relacaoCinturaQuadril?.toStringAsFixed(2)}''',
                        icon: Icons.check_circle,
                        iconColor: colorTheme.green_sucess_500,
                        description: 'Moderado',
                      ),
                      _buildRowWithIcon(
                        context: context,
                        label: 'Peso de gordura:',
                        value:
                            ' ${avaliacao.pesoGordura?.toStringAsFixed(2)}kg',
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
