import 'package:flutter/material.dart';

class PortraitPositionedUser extends StatelessWidget {
  final double topPadding;
  final Color backgroundColor;
  final String? imagePath;
  final double sizeFactor;

  const PortraitPositionedUser({
    Key? key,
    required this.topPadding,
    required this.backgroundColor,
    required this.imagePath,
    this.sizeFactor = 0.30, // Define o fator de escala padrão do círculo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * topPadding,
      left: MediaQuery.of(context).size.width *
          (1 - sizeFactor) /
          2, // Centraliza horizontalmente
      child: Container(
        width: MediaQuery.of(context).size.width *
            sizeFactor, // Tamanho do círculo
        height: MediaQuery.of(context).size.width *
            sizeFactor, // Tamanho do círculo
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: imagePath != null && imagePath!.isNotEmpty
            ? CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.225,
                backgroundImage: NetworkImage(imagePath!),
                backgroundColor: backgroundColor,
              )
            : CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.225,
                backgroundColor: backgroundColor,
                child: Icon(
                  Icons.person,
                  size: MediaQuery.of(context).size.width * 0.12,
                ),
              ),
      ),
    );
  }
}
