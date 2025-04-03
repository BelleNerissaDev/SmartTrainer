import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class PackageCard extends StatelessWidget {
  final String packageName;
  final String packageValue;
  final int accessCount;
  final String packageId; // Adicionando o ID do pacote
  final ColorFamily colorTheme;

  const PackageCard({
    Key? key,
    required this.packageName,
    required this.packageValue,
    required this.accessCount,
    required this.packageId,
    required this.colorTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: colorTheme.light_container_500,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorTheme.grey_font_500,
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/package.svg',
                      color: colorTheme.indigo_primary_800,
                      width: 30.0,
                      height: 30.0,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      packageName,
                      style: Theme.of(context).textTheme.headline20px!.copyWith(
                            color: colorTheme.black_onSecondary_100,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    text: 'Valor (mês): ',
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          color: colorTheme.grey_font_700,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: 'R\$ $packageValue',
                        style: Theme.of(context).textTheme.body12px!.copyWith(
                              color: colorTheme.grey_font_700,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    text: 'Número de acessos (mês): ',
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          color: colorTheme.grey_font_700,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      TextSpan(
                        text: '$accessCount',
                        style: Theme.of(context).textTheme.body12px!.copyWith(
                              color: colorTheme.grey_font_700,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              size: 24,
              color: colorTheme.indigo_primary_800,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutesNames
                    .novoPacote.route, // Rota para a página de edição/criação
                arguments: {'packageId': packageId},
              );
            },
          ),
        ],
      ),
    );
  }
}
