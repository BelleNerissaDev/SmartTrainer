import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double iconSize;
  final VoidCallback onTap; // Callback para a ação do botão

  const ActionButton({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.onTap, // Parâmetro obrigatório para a ação do botão
    this.iconSize = 30.0, // Tamanho padrão do ícone
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Executa a ação passada por parâmetro
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor, // Cor de fundo do botão
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 67, 67, 67).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3), // Sombra
            ),
          ],
        ),
        child: Icon(
          icon,
          size: iconSize, // Tamanho do ícone
          color: iconColor, // Cor do ícone
        ),
      ),
    );
  }
}
