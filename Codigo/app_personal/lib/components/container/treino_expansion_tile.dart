import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:flutter/material.dart';

class TreinoExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final ColorFamily colorTheme;

  const TreinoExpansionTile({
    Key? key,
    required this.title,
    required this.children,
    required this.colorTheme,
  }) : super(key: key);

  @override
  _TreinoExpansionTileState createState() => _TreinoExpansionTileState();
}

class _TreinoExpansionTileState extends State<TreinoExpansionTile> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    var colorTheme = widget.colorTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
              vertical: 0, horizontal: 8.0), // Reduz o padding vertical
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorTheme.indigo_primary_700,
            ),
          ),
          trailing: Transform.rotate(
            angle: 1.5708, // Rotaciona 90 graus (em radianos)
            child: Icon(
              _isExpanded
                  ? Icons.arrow_forward_ios_sharp
                  : Icons.arrow_back_ios,
              color: colorTheme.grey_font_700,
              size: 16, // Cor do ícone
            ),
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          Column(
            children: widget.children,
          ),
      ],
    );
  }
}
