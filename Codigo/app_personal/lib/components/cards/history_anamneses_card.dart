import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/utils/format_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class HistoryAnamensesCard extends StatelessWidget {
  final Aluno aluno;
  final String name;
  final String status;
  final String? profileImage;
  final String date;
  final void Function()? solicitarAction;
  final Anamnese? anamnese;

  const HistoryAnamensesCard({
    Key? key,
    this.anamnese,
    required this.aluno,
    required this.name,
    required this.status,
    required this.date,
    required this.profileImage,
    this.solicitarAction,
  }) : super(key: key);

  // Função para determinar cor e ícone com base no status
  Map<String, dynamic> _getStatusProperties(String status) {
    switch (status) {
      case 'Realizada':
        return {
          'icon': null,
          'color': Colors.transparent,
        };
      case 'Pendente':
        return {
          'icon': Icons.info_outline,
          'color': Colors.orange,
        };
      case 'Não solicitado':
        return {
          'icon': Icons.cancel_outlined,
          'color': Colors.red,
        };
      default:
        return {
          'icon': Icons.help_outline,
          'color': Colors.blueGrey,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    final statusProperties = _getStatusProperties(status);
    return GestureDetector(
      onTap: () {
        if (anamnese != null)
          Navigator.pushNamed(
            context,
            RoutesNames.anamneseForm.route,
            arguments: {
              'aluno': aluno,
              'anamnese': anamnese,
              'profileImage': profileImage ?? ''
            },
          );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorTheme.light_container_500,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorTheme.grey_font_500.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: profileImage != null
                  ? NetworkImage(profileImage!)
                  : null, // Se a imagem for nula, backgroundImage é null
              child: profileImage == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headline20px!.copyWith(
                          color: colorTheme.black_onSecondary_100,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (statusProperties['icon'] != null)
                        Icon(
                          statusProperties['icon'],
                          color: statusProperties['color'],
                          size: 18,
                        ),
                      const SizedBox(width: 4),
                      Text(
                        status + (status == 'Realizada' ? ' em' : ''),
                        style: Theme.of(context).textTheme.label10px!.copyWith(
                            color: colorTheme.grey_font_700,
                            fontWeight: status == 'Realizada'
                                ? FontWeight.normal
                                : FontWeight.bold),
                      ),
                      if (date.isNotEmpty && status == 'Realizada')
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            formatDate(date),
                            style: Theme.of(context)
                                .textTheme
                                .body12px!
                                .copyWith(
                                    color: colorTheme.black_onSecondary_100,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (status == 'Não solicitado')
              ElevatedButton(
                onPressed: solicitarAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorTheme.lemon_secondary_500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(100, 32),
                ),
                child: Text(
                  'Solicitar',
                  style: Theme.of(context).textTheme.label10px!.copyWith(
                        color: colorTheme.black_onSecondary_100,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
