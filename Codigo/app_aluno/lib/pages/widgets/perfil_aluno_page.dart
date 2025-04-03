import 'dart:io';

import 'package:SmartTrainer/components/card_email_telefone.dart';
import 'package:SmartTrainer/components/card_infos_pessoais.dart';
import 'package:SmartTrainer/components/card_medidas.dart';
import 'package:SmartTrainer/components/card_pacote.dart';
import 'package:SmartTrainer/components/header/header.dart';
import 'package:SmartTrainer/components/loading/loading.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/pages/controller/editar_foto_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PerfilAlunoPage extends StatefulWidget {
  const PerfilAlunoPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PerfilAlunoPageState();
}

class _PerfilAlunoPageState extends State<PerfilAlunoPage> {
  final ImagePicker _picker = ImagePicker();

  void _openDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remover foto'),
                onTap: () async {
                  showLoading(context); // Mostrar o loading
                  await _removeImagem();
                  Navigator.of(context).pop(); // Fechar o modal
                  Navigator.of(context).pop(); // Fechar o loading
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () async {
                  showLoading(context); // Mostrar o loading
                  await _editImagem(ImageSource.camera);
                  Navigator.of(context).pop(); // Fechar o modal
                  Navigator.of(context).pop(); // Fechar o loading
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () async {
                  showLoading(context); // Mostrar o loading
                  await _editImagem(ImageSource.gallery);
                  Navigator.of(context).pop(); // Fechar o modal
                  Navigator.of(context).pop(); // Fechar o loading
                },
              ),
            ],
          ),
        );
      },
    );
  }

 

  Future<void> _editImagem(ImageSource source) async {
    final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      File file = File(image.path);
      final editarFotoController = EditarFotoController();
      alunoProvider.setAluno(await editarFotoController.editarFoto(file));
    }
  }

  Future<void> _removeImagem() async {
    final alunoProvider = Provider.of<AlunoProvider>(context, listen: false);
    final editarFotoController = EditarFotoController();
    alunoProvider.setAluno(await editarFotoController.removerFoto());
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    final alunoProvider = Provider.of<AlunoProvider>(context);
    final aluno = alunoProvider.aluno!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: Header(colorTheme: colorTheme),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              colorTheme.white_onPrimary_100,
              colorTheme.indigo_primary_400,
              colorTheme.white_onPrimary_100,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight * 1.25,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                Transform.translate(
                  offset: Offset(0, (screenWidth * 0.5) / 2),
                  child: Container(
                    width: screenWidth,
                    padding: EdgeInsets.only(top: (screenWidth * 0.6) / 2),
                    decoration: BoxDecoration(
                      color: colorTheme.white_onPrimary_100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          aluno.nome,
                          style: TextStyle(
                            color: colorTheme.black_onSecondary_100,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          aluno.status.toString(),
                          style: TextStyle(
                              color: () {
                                switch (aluno.status) {
                                  case StatusAlunoEnum.ATIVO:
                                    return colorTheme.green_sucess_500;
                                  case StatusAlunoEnum.BLOQUEADO:
                                    return colorTheme.red_error_500;
                                }
                              }(),
                              fontWeight: FontWeight.w900),
                        ),
                        CardEmailTelefone(
                          colorTheme: colorTheme,
                          email: aluno.email,
                          telefone: aluno.telefone,
                        ),
                        CardInfosPessoais(
                          colorTheme: colorTheme,
                          idade: 30,
                          peso: aluno.peso ?? 0,
                          altura: aluno.altura ?? 0,
                        ),
                        CardMedidas(
                          colorTheme: colorTheme,
                          pescoco: 30,
                          cintura: 30,
                          quadril: 30,
                        ),
                        CardPacote(
                          valor: double.tryParse(aluno.pacote.valorMensal
                                  .replaceAll(',', '.')) ??
                              0,
                          acessos:
                              int.tryParse(aluno.pacote.numeroAcessos) ?? 0,
                          colorTheme: colorTheme,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: colorTheme.white_onPrimary_100,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: screenWidth * 0.25,
                          child: aluno.imagem == null
                              ? Icon(
                                  Icons.person,
                                  size: screenWidth * 0.5,
                                )
                              : ClipOval(
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    aluno.imagem!,
                                    fit: BoxFit.cover,
                                    width: screenWidth * 0.5,
                                    height: screenWidth * 0.5,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(50, 50),
                            maximumSize: const Size(50, 50),
                            backgroundColor: colorTheme.lemon_secondary_200,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Icon(
                            Mdi.pencil,
                            color: Colors.black,
                            size: 24,
                          ),
                          onPressed: _openDialog,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
