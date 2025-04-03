import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/snack_bar/messages_snack_bar.dart';
import 'package:SmartTrainer_Personal/components/titles/headline_titles.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/pages/controller/pacote/pacote_controller.dart';
import 'package:SmartTrainer_Personal/utils/error_message.dart';
import 'package:SmartTrainer_Personal/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NovoPacotePage extends StatefulWidget {
  const NovoPacotePage({Key? key}) : super(key: key);
  @override
  _NovoPacotePageState createState() => _NovoPacotePageState();
}

class _NovoPacotePageState extends State<NovoPacotePage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _numeroAcessosController =
      TextEditingController();
  var colorTheme;
  bool _isEditing = false;
  String? packageId;

  Map<String, bool> errors = {
    'nome': false,
    'valorMensal': false,
    'numeroAcessos': false,
  };

  bool _isLoading = false;

  bool hasError(field) => errors[field]!;

  bool validateFields() {
    final String nome = _nomeController.text;
    final String valorMensal = _valorController.text;
    final String numeroAcessos = _numeroAcessosController.text;

    final bool nomeValid = Validations.validateNome(nome);
    final bool valorMensalValid =
        Validations.validateValorMonetario(valorMensal);
    final bool numeroAcessosValid =
        Validations.validateNumeroInteiro(numeroAcessos);

    setState(() {
      errors['nome'] = !nomeValid;
      errors['valorMensal'] = !valorMensalValid;
      errors['numeroAcessos'] = !numeroAcessosValid;
    });

    return nomeValid && valorMensalValid && numeroAcessosValid;
  }

  void cleanFields() {
    _nomeController.clear();
    _valorController.clear();
    _numeroAcessosController.clear();
  }

  void cleanErrors() {
    setState(() {
      errors = {
        'nome': false,
        'valorMensal': false,
        'numeroAcessos': false,
      };
    });
  }

  Future<void> savePacote() async {
    cleanErrors();
    if (!validateFields()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final String nome = _nomeController.text;
    final String valorMensal = _valorController.text;
    final String numeroAcessos = _numeroAcessosController.text;

    final novoPacoteController = PacoteController();

    final bool success = _isEditing && packageId != null
        ? await novoPacoteController.editarPacote(
            nome: nome,
            valorMensal: valorMensal,
            numeroAcessos: numeroAcessos,
            id: packageId,
          )
        : await novoPacoteController.criarPacote(
            nome: nome,
            valorMensal: valorMensal,
            numeroAcessos: numeroAcessos,
          );
    if (success) {
      setState(() {
        _isLoading = false;
      });
      showMessageSnackBar(
        colorTheme,
        context,
        _isEditing
            ? 'Pacote atualizado com sucesso'
            : 'Pacote cadastrado com sucesso',
        error: false,
      );
      cleanFields();
    } else {
      setState(() {
        _isLoading = false;
      });
      showMessageSnackBar(
        colorTheme,
        context,
        'Ocorreu erro ao ${_isEditing ? 'atualizar' : 'adicionar'} pacote',
        error: true,
      );
    }
    Navigator.pushNamed(
      context,
      RoutesNames.pacotes.route,
      arguments: {'refresh': true},
    );
  }

  Future<void> _loadPacoteForEdit(String? pacoteId) async {
    if (pacoteId == null) {
      showMessageSnackBar(colorTheme, context, 'Erro ao carregar pacote',
          error: true);
      return;
    }
    final novoPacoteController = PacoteController();
    try {
      setState(() {
        _isLoading = true;
      });
      final pacote = await novoPacoteController.visualizarPacotePorId(pacoteId);
      if (pacote != null) {
        setState(() {
          _nomeController.text = pacote.nome;
          _valorController.text = pacote.valorMensal;
          _numeroAcessosController.text = pacote.numeroAcessos;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        showMessageSnackBar(colorTheme, context, 'Pacote não encontrado',
            error: true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showMessageSnackBar(colorTheme, context, 'Erro ao carregar pacote: $e',
          error: true);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    _numeroAcessosController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      setState(() {
        packageId =
            arguments != null ? arguments['packageId'] as String? : null;
        _isEditing = packageId != null;
      });
      if (packageId != null) {
        _loadPacoteForEdit(packageId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorTheme.white_onPrimary_100),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutesNames.pacotes.route,
              arguments: {'refresh': true},
            );
          },
        ),
        colorTheme: colorTheme,
        title: 'LOGO',
      ),
      drawer: Menu(colorTheme: colorTheme),
      endDrawer: NotificationMenu(colorTheme: colorTheme),
      body: Column(
        children: [
          HeaderContainer(
              colorTheme: colorTheme,
              title: _isEditing ? 'Editar Pacote' : 'Novo Pacote'),
          Expanded(
            child: CardContainer(
                colorTheme: colorTheme,
                child: SingleChildScrollView(
                  child: Column(children: [
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (!_isLoading)
                      Container(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              const HeadlineTitles(
                                title: 'Informações do pacote',
                                subtile:
                                    'Preencha com as informações do pacote',
                              ),
                              const SizedBox(height: 10),
                              ObscuredTextField(
                                colorTheme: colorTheme,
                                controller: _nomeController,
                                label: 'Nome',
                                obscureText: false,
                                showErrors: errors['nome']!,
                                errors: errors['nome']!
                                    ? [
                                        ErrorMessage(
                                            message: 'Nome inválido',
                                            error: true)
                                      ]
                                    : [],
                              ),
                              const SizedBox(height: 15),
                              ObscuredTextField(
                                colorTheme: colorTheme,
                                controller: _valorController,
                                label: 'Valor mensal (R\$)',
                                obscureText: false,
                                showErrors: errors['valorMensal']!,
                                errors: errors['valorMensal']!
                                    ? [
                                        ErrorMessage(
                                            message: 'Valor inválido',
                                            error: true)
                                      ]
                                    : [],
                              ),
                              const SizedBox(height: 15),
                              // TO-DO: Máscara
                              ObscuredTextField(
                                colorTheme: colorTheme,
                                controller: _numeroAcessosController,
                                label: 'Número de acessos (mês)',
                                obscureText: false,
                                showErrors: errors['numeroAcessos']!,
                                errors: errors['numeroAcessos']!
                                    ? [
                                        ErrorMessage(
                                            message:
                                                'Número de acessos inválido',
                                            error: true)
                                      ]
                                    : [],
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: PrimaryButton(
                                  verticalPadding: 8.0,
                                  horizontalPadding:
                                      MediaQuery.of(context).size.width * 0.170,
                                  label: 'Cadastrar',
                                  onPressed: savePacote,
                                  backgroundColor:
                                      colorTheme.indigo_primary_500,
                                ),
                              ),
                            ],
                          )),
                  ]),
                )),
          )
        ],
      ),
    );
  }
}
