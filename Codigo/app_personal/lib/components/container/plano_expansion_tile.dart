import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:flutter/material.dart';

class PlanoExpansionTile extends StatefulWidget {
  final String title;
  final String status;
  final List<Widget> children;
  final ColorFamily colorTheme;
  final VoidCallback? editFunction;
  final VoidCallback? deleteFunction;
  final VoidCallback? deactivateFunction;

  const PlanoExpansionTile({
    Key? key,
    required this.title,
    required this.status,
    required this.children,
    required this.colorTheme,
    required this.editFunction,
    required this.deleteFunction,
    required this.deactivateFunction,
  }) : super(key: key);

  @override
  _PlanoExpansionTileState createState() => _PlanoExpansionTileState();
}

class _PlanoExpansionTileState extends State<PlanoExpansionTile> {
  bool _isExpanded = true;

  // GlobalKey para acessar a posição do IconButton
  final GlobalKey _iconKey = GlobalKey();

  void _showPopupMenu(BuildContext context) {
    // Obtém o RenderBox e as posições
    final RenderBox renderBox =
        _iconKey.currentContext!.findRenderObject()! as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        position.dx + size.width,
        position.dy,
      ),
      items: [
        PopupMenuItem(
          child: const Text('Editar'),
          onTap: widget.editFunction,
        ),
        PopupMenuItem(
          child: const Text('Ativar'),
          onTap: widget.deactivateFunction,
        ),
        PopupMenuItem(
          child: const Text('Excluir'),
          onTap: widget.deleteFunction,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = widget.colorTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white, // Cor de fundo para o título
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            widget.title,
                                            style: TextStyle(
                                              fontSize: 20,
                                              height: 1.0,
                                              fontWeight: FontWeight.bold,
                                              color: colorTheme
                                                  .black_onSecondary_100,
                                            ),
                                          ),
                                          IconButton(
                                            key: _iconKey,
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: colorTheme.grey_font_700,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              _showPopupMenu(
                                                  context); // Mostra o menu
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(
                                        widget.status,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: widget.status == 'Ativo'
                                              ? colorTheme.green_sucess_500
                                              : colorTheme.red_error_500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    })
                  },
                  child: Transform.rotate(
                    angle: 1.5708, // Rotaciona 90 graus (rad)
                    child: Icon(
                      _isExpanded
                          ? Icons.arrow_forward_ios_sharp
                          : Icons.arrow_back_ios,
                      color: colorTheme.black_onSecondary_100, // Cor do ícone
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Column(
              children: widget.children,
            ),
        ],
      ),
    );
  }
}
