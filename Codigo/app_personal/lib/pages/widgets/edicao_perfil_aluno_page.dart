import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/sections/portrait_positioned_user.dart';
import 'package:SmartTrainer_Personal/components/snack_bar/messages_snack_bar.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/pages/controller/aluno/aluno_controller.dart';
import 'package:SmartTrainer_Personal/utils/error_message.dart';
import 'package:SmartTrainer_Personal/utils/format_date.dart';
import 'package:SmartTrainer_Personal/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:mask/mask/mask.dart';
import 'package:provider/provider.dart';

class EdicaoPerfilAluno extends StatefulWidget {
  const EdicaoPerfilAluno({Key? key}) : super(key: key);
  @override
  _AlunoPerfilPageState createState() => _AlunoPerfilPageState();
}

class _AlunoPerfilPageState extends State<EdicaoPerfilAluno> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  bool _isLoading = false;

  Aluno? aluno;

  Map<String, bool> errors = {
    'nome': false,
    'dataNascimento': false,
    'telefone': false,
  };

  bool hasError(field) => errors[field]!;

  void _preLoadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;

      setState(() {
        aluno = args['aluno'] as Aluno;
      });
      _nomeController.text = aluno!.nome;
      _dataNascimentoController.text =
          formatDate(aluno!.dataNascimento.toString());
      _telefoneController.text = aluno!.telefone;
    });
  }

  bool validateFields() {
    final String nome = _nomeController.text;
    final String dataNascimento = _dataNascimentoController.text;
    final String telefone = _telefoneController.text;

    final bool nomeValid = Validations.validateNome(nome);
    final bool dataNascimentoValid = Validations.validateData(dataNascimento);
    final bool telefoneValid = Validations.validateTelefone(telefone);

    setState(() {
      errors['nome'] = !nomeValid;
      errors['dataNascimento'] = !dataNascimentoValid;
      errors['telefone'] = !telefoneValid;
    });

    return nomeValid && dataNascimentoValid && telefoneValid;
  }

  void cleanErrors() {
    setState(() {
      errors = {
        'nome': false,
        'dataNascimento': false,
        'telefone': false,
      };
    });
  }

  Future<void> _salvar() async {
    var colorTheme =
        Provider.of<ThemeProvider>(context, listen: false).colorTheme;
    cleanErrors();
    if (!validateFields()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String nome = _nomeController.text;
    final String dataNascimento = _dataNascimentoController.text;
    final String telefone = _telefoneController.text;

    final novoAlunoController = NovoAlunoController();

    final bool result = await novoAlunoController.atualizarAluno(
      nome: nome,
      dataNascimento: dataNascimento,
      telefone: telefone,
      aluno: aluno!,
    );
    setState(() {
      _isLoading = false;
    });

    if (result) {
      showMessageSnackBar(colorTheme, context, 'Aluno atualizado com sucesso');
    } else {
      showMessageSnackBar(
          colorTheme, context, 'Ocorreu erro ao atualizar aluno',
          error: true);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _preLoadData();
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    return Scaffold(
        appBar: CustomAppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorTheme.white_onPrimary_100),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          colorTheme: colorTheme,
          title: 'LOGO',
        ),
        drawer: Menu(colorTheme: colorTheme),
        endDrawer: NotificationMenu(colorTheme: colorTheme),
        body: aluno == null
            ? Center(
                child: CircularProgressIndicator(
                  color: colorTheme.white_onPrimary_100,
                ),
              )
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  if (_isLoading) // Exibe o loading enquanto estiver carregando
                    Center(
                        child: CircularProgressIndicator(
                      color: colorTheme.white_onPrimary_100,
                    )),
                  if (!_isLoading)
                    Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height *
                                0.115), // Espaço para o círculo
                        Expanded(
                          child: CardContainer(
                            colorTheme: colorTheme,
                            child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1),
                                    ObscuredTextField(
                                      colorTheme: colorTheme,
                                      controller: _nomeController,
                                      label: 'Nome',
                                      obscureText: false,
                                      errors: errors['nome']!
                                          ? [
                                              ErrorMessage(
                                                  message: 'Nome inválido',
                                                  error: true)
                                            ]
                                          : [],
                                      showErrors: hasError('nome'),
                                    ),
                                    const SizedBox(height: 15),
                                    ObscuredTextField(
                                      colorTheme: colorTheme,
                                      controller: _dataNascimentoController,
                                      label: 'Data de nascimento',
                                      obscureText: false,
                                      inputFormatters: [Mask.date()],
                                      keyboardType: TextInputType.datetime,
                                      errors: errors['dataNascimento']!
                                          ? [
                                              ErrorMessage(
                                                  message:
                                                      '''Data de Nascimento inválida''',
                                                  error: true)
                                            ]
                                          : [],
                                      showErrors: hasError('dataNascimento'),
                                    ),
                                    const SizedBox(height: 15),
                                    ObscuredTextField(
                                      colorTheme: colorTheme,
                                      controller: _telefoneController,
                                      label: 'Telefone',
                                      obscureText: false,
                                      inputFormatters: [Mask.phone()],
                                      keyboardType: TextInputType.phone,
                                      errors: errors['telefone']!
                                          ? [
                                              ErrorMessage(
                                                  message:
                                                      '''Telefone inválido''',
                                                  error: true)
                                            ]
                                          : [],
                                      showErrors: hasError('telefone'),
                                    ),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: PrimaryButton(
                                        verticalPadding:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                        horizontalPadding:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        label: 'Salvar',
                                        onPressed: _salvar,
                                        backgroundColor:
                                            colorTheme.indigo_primary_500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  PortraitPositionedUser(
                    topPadding: 0.01,
                    backgroundColor: colorTheme.grey_font_500,
                    imagePath: aluno!.imagem,
                  ),
                ],
              ));
  }
}
