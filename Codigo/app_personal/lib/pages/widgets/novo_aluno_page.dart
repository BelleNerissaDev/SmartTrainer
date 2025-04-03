import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';
import 'package:SmartTrainer_Personal/components/inputs/dropdown_input.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/snack_bar/messages_snack_bar.dart';
import 'package:SmartTrainer_Personal/components/titles/headline_titles.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/connections/repository/pacote_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:SmartTrainer_Personal/pages/controller/aluno/aluno_controller.dart';
import 'package:SmartTrainer_Personal/utils/error_message.dart';

import 'package:SmartTrainer_Personal/utils/validations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:mask/mask/mask.dart';
import 'package:provider/provider.dart';

class NovoAlunoPage extends StatefulWidget {
  final List<Pacote>? pacotesOnTest;

  const NovoAlunoPage({Key? key, this.pacotesOnTest}) : super(key: key);
  @override
  _NovoAlunoPageState createState() => _NovoAlunoPageState();
}

class _NovoAlunoPageState extends State<NovoAlunoPage> {
  // Variáveis de seleção do conteúdo dos dropdowns
  Sexo? selectedSexo;
  Pacote? selectedPacote;

  List<Pacote> pacotes = [];

  // Variáveis de controle do conteúdo dos dropdowns
  final TextEditingController _sexoDropdownController = TextEditingController();
  final TextEditingController _pacoteDropdownController =
      TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  Map<String, bool> errors = {
    'email': false,
    'nome': false,
    'dataNascimento': false,
    'telefone': false,
    'sexo': false,
    'pacote': false,
  };

  Future<void> initPacotes() async {
    try {
    final pacoteRepository = PacoteRepository();
    final allPacotes = await pacoteRepository.readAll();

    setState(() {
      this.pacotes = allPacotes;
      });
    } on FirebaseException {
      return;
    }
  }

  bool _isLoading = false; // Adiciona a variável de loading

  bool hasError(field) => errors[field]!;

  bool validateFields() {
    final String email = _emailController.text;
    final String nome = _nomeController.text;
    final String dataNascimento = _dataNascimentoController.text;
    final String telefone = _telefoneController.text;

    final bool emailValid = Validations.validateEmail(email);
    final bool nomeValid = Validations.validateNome(nome);
    final bool dataNascimentoValid = Validations.validateData(dataNascimento);
    final bool telefoneValid = Validations.validateTelefone(telefone);

    final bool sexoValid = selectedSexo != null;
    final bool pacoteValid = selectedPacote != null;

    setState(() {
      errors['email'] = !emailValid;
      errors['nome'] = !nomeValid;
      errors['dataNascimento'] = !dataNascimentoValid;
      errors['telefone'] = !telefoneValid;
      errors['sexo'] = !sexoValid;
      errors['pacote'] = !pacoteValid;
    });

    return emailValid &&
        nomeValid &&
        dataNascimentoValid &&
        telefoneValid &&
        sexoValid &&
        pacoteValid;
  }

  void cleanFields() {
    _emailController.clear();
    _nomeController.clear();
    _dataNascimentoController.clear();
    _telefoneController.clear();
    _sexoDropdownController.clear();
    _pacoteDropdownController.clear();
    selectedSexo = null;
    selectedPacote = null;
  }

  void cleanErrors() {
    setState(() {
      errors = {
        'email': false,
        'nome': false,
        'dataNascimento': false,
        'telefone': false,
        'sexo': false,
        'pacote': false,
      };
    });
  }

  Future<void> createAluno() async {
    var colorTheme =
        Provider.of<ThemeProvider>(context, listen: false).colorTheme;
    try {
      cleanErrors();
      if (!validateFields()) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final String email = _emailController.text;
      final String nome = _nomeController.text;
      final String dataNascimento = _dataNascimentoController.text;
      final String telefone = _telefoneController.text;
      final Sexo sexo = selectedSexo!;
      final Pacote pacote = selectedPacote!;

      final novoAlunoController = NovoAlunoController();

      final bool success = await novoAlunoController.salvarAluno(
        email: email,
        // Senha padrão para todos os alunos
        senha: '12345678',
        nome: nome,
        dataNascimento: dataNascimento,
        telefone: telefone,
        sexo: sexo.toString(),
        pacoteTreino: pacote,
      );

      cleanFields();
      
      setState(() {
        _isLoading = false;
      });

      if (success) {
        showMessageSnackBar(
          colorTheme,
          context,
          'Aluno cadastrado com sucesso',
        );
      } else {
        showMessageSnackBar(
          colorTheme,
          context,
          'Ocorreu erro ao adicionar aluno',
          error: true,
        );
      }
    } on FirebaseException {
      return;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nomeController.dispose();
    _dataNascimentoController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPacotes();
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
      body: Column(
        children: [
          HeaderContainer(
            colorTheme: colorTheme,
            title: 'Novo Aluno',
          ),
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
                                title: 'Informações do aluno',
                                subtile: 'Preencha com os dados do aluno',
                              ),
                              const SizedBox(height: 10),
                              ObscuredTextField(
                                colorTheme: colorTheme,
                                controller: _emailController,
                                label: 'E-mail',
                                obscureText: false,
                                showErrors: hasError('email'),
                                keyboardType: TextInputType.emailAddress,
                              errors: errors['email']!
                                    ? [
                                        ErrorMessage(
                                            message: 'Email inválido',
                                            error: true)
                                      ]
                                    : [],
                              ),
                              const SizedBox(height: 15),
                              ObscuredTextField(
                                colorTheme: colorTheme,
                                controller: _nomeController,
                                label: 'Nome',
                                obscureText: false,
                                showErrors: hasError('nome'),
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
                                controller: _dataNascimentoController,
                                label: 'Data de Nascimento',
                                obscureText: false,
                                inputFormatters: [Mask.date()],
                              keyboardType: TextInputType.datetime,
                              showErrors: hasError('dataNascimento'),
                                errors: errors['dataNascimento']!
                                    ? [
                                        ErrorMessage(
                                            message:
                                                'Data de nascimento inválida',
                                            error: true)
                                      ]
                                    : [],
                              ),
                              const SizedBox(height: 15),
                                DropdownInput<Sexo>(
                                width: double.infinity,
                                selectedValue: selectedSexo,
                                label: 'Sexo',
                                items: Sexo.values,
                                onSelected: (Sexo? newValue) {
                                  setState(() {
                                    selectedSexo = newValue;
                                  });
                                },
                                dropdownController: _sexoDropdownController,
                                showErrors: errors['sexo']!,
                                errors: errors['sexo']!
                                    ? [
                                        ErrorMessage(
                                            message: 'Insira um valor válido',
                                            error: true)
                                      ]
                                    : [],
                              ),
                              const SizedBox(height: 15),
                                ObscuredTextField(
                                colorTheme: colorTheme,
                                controller: _telefoneController,
                                label: 'Telefone',
                                obscureText: false,
                                inputFormatters: [Mask.phone()],
                              keyboardType: TextInputType.phone,
                              showErrors: hasError('telefone'),
                                errors: errors['telefone']!
                                    ? [
                                        ErrorMessage(
                                            message: 'Telefone inválido',
                                            error: true)
                                      ]
                                    : [],
                              ),
                              const SizedBox(height: 15),
                                DropdownInput<Pacote>(
                                width: double.infinity,
                                selectedValue: selectedPacote,
                                  label: 'Pacote de treino',
                                items: pacotes,
                                onSelected: (Pacote? newValue) {
                                  setState(() {
                                    selectedPacote = newValue;
                                  });
                                },
                                dropdownController: _pacoteDropdownController,
                                showErrors: errors['pacote']!,
                                errors: errors['pacote']!
                                    ? [
                                        ErrorMessage(
                                            message: 'Insira um valor válido',
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
                                  onPressed: createAluno,
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
