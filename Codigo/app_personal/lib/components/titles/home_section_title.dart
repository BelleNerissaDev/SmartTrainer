import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/fonts.dart';
import 'package:provider/provider.dart';

class HomeSectionTitle extends StatelessWidget {
  final String titleBold;
  final String titleRegular;
  final VoidCallback onLinkTap;

  const HomeSectionTitle({
    Key? key,
    required this.titleBold,
    required this.titleRegular,
    required this.onLinkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: titleBold,
                  style: Theme.of(context).textTheme.headline20px!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorTheme.black_onSecondary_100,
                      ),
                ),
                TextSpan(
                  text: ' $titleRegular',
                  style: Theme.of(context).textTheme.label14px!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: colorTheme.grey_font_700,
                      ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onLinkTap,
            child: Text(
              'Veja mais',
              style: Theme.of(context).textTheme.label14px!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: colorTheme.indigo_primary_800,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
