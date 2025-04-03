import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';
import 'package:SmartTrainer_Personal/components/forms/anamnese/anamnese_historico_saude_form.dart';
import 'package:SmartTrainer_Personal/components/forms/anamnese/anamnese_personal_data_form.dart';
import 'package:SmartTrainer_Personal/components/forms/anamnese/anamnese_testeparq_form.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/drawers/menu.dart';
import 'package:SmartTrainer_Personal/components/drawers/notification_menu.dart';
import 'package:SmartTrainer_Personal/components/sections/portrait_positioned_user.dart';
import 'package:SmartTrainer_Personal/components/snack_bar/messages_snack_bar.dart';
import 'package:SmartTrainer_Personal/config/router.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:SmartTrainer_Personal/pages/controller/anamnese/anamnese_controller.dart';
import 'package:SmartTrainer_Personal/utils/validations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnamneseFormPage extends StatefulWidget {
  const AnamneseFormPage({Key? key}) : super(key: key);
  @override
  _AnamneseFormPageState createState() => _AnamneseFormPageState();
}

class _AnamneseFormPageState extends State<AnamneseFormPage> {
  final PageController _pageController = PageController();
  late Anamnese anamnese;
  late Aluno aluno;
  late String profileImage;

  bool _isAnamneseDataLoaded = false;

  // Controllers Personal Data
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  final TextEditingController _nomeContatoEmergenciaController =
      TextEditingController();
  final TextEditingController _telfoneContatoEmergenciaController =
      TextEditingController();
  Sexo? selectedSexo;
  final TextEditingController sexoDropdownController = TextEditingController();

  // Controllers TesteParq
  String? TPQselectedOption1;
  String? TPQselectedOption2;
  String? TPQselectedOption3;
  String? TPQselectedOption4;
  String? TPQselectedOption5;
  String? TPQselectedOption6;
  String? TPQselectedOption7;

  // Controllers Historico Saude
  String? HSselectedOption1;
  String? HSselectedOption2;
  String? HSselectedOption3;
  String? HSselectedOption4;
  String? HSselectedOption5;
  String? HSselectedOption6;
  String? HSselectedOption7;
  String? HSselectedOption8;

  final TextEditingController _HStextController9 = TextEditingController();
  final TextEditingController _HStextController10 = TextEditingController();
  final TextEditingController _HSopcionalTextController5 =
      TextEditingController();
  final TextEditingController _HSopcionalTextController6 =
      TextEditingController();

  Map<String, bool> PDerrors = {
    'nomeCompleto': false,
    'email': false,
    'idade': false,
    'telefone': false,
    'nomeContatoEmergencia': false,
    'telefoneContatoEmergencia': false,
    'sexo': false,
    'responsavel': false,
  };

  bool TPQshowError1 = false;
  bool TPQshowError2 = false;
  bool TPQshowError3 = false;
  bool TPQshowError4 = false;
  bool TPQshowError5 = false;
  bool TPQshowError6 = false;
  bool TPQshowError7 = false;

  bool HSshowError1 = false;
  bool HSshowError2 = false;
  bool HSshowError3 = false;
  bool HSshowError4 = false;
  bool HSshowError5 = false;
  bool HSshowError5opt = false;
  bool HSshowError6 = false;
  bool HSshowError6opt = false;
  bool HSshowError7 = false;
  bool HSshowError8 = false;
  bool HSshowError9 = false;
  bool HSshowError10 = false;

  // Funções para validar e coletar dados
  bool validatePersonalData() {
    final String nomeCompleto = _nomeController.text;
    final String responsavel = _responsavelController.text;
    final String email = _emailController.text;
    final String idade = _idadeController.text;
    final String telefone = _telefoneController.text;
    final String nomeContatoEmergencia = _nomeContatoEmergenciaController.text;
    final String telefoneContatoEmergencia =
        _telfoneContatoEmergenciaController.text;

    final bool nomeValid = Validations.validateNome(nomeCompleto);
    final bool emailValid = Validations.validateEmail(email);
    final bool idadeValid = Validations.validateNumeroInteiro(idade);
    final bool telefoneValid = Validations.validateTelefone(telefone);
    final bool nomeContatoEmergenciaValid =
        Validations.validateNome(nomeContatoEmergencia);
    final bool telefoneContatoEmergenciaValid =
        Validations.validateTelefone(telefoneContatoEmergencia);
    final bool sexoValid = selectedSexo != null;

    final bool responsavelValid =
        int.tryParse(idade) != null && int.parse(idade) < 18
            ? Validations.validateNome(responsavel)
            : true;

    setState(() {
      PDerrors['nomeCompleto'] = !nomeValid;
      PDerrors['email'] = !emailValid;
      PDerrors['idade'] = !idadeValid;
      PDerrors['telefone'] = !telefoneValid;
      PDerrors['nomeContatoEmergencia'] = !nomeContatoEmergenciaValid;
      PDerrors['telefoneContatoEmergencia'] = !telefoneContatoEmergenciaValid;
      PDerrors['sexo'] = !sexoValid;

      PDerrors['responsavel'] =
          int.tryParse(idade) != null && int.parse(idade) < 18
              ? !responsavelValid
              : false;
    });

    return nomeValid &&
        emailValid &&
        idadeValid &&
        telefoneValid &&
        nomeContatoEmergenciaValid &&
        telefoneContatoEmergenciaValid &&
        sexoValid &&
        responsavelValid;
  }

  bool validateTesteParq() {
    setState(() {
      TPQshowError1 = TPQselectedOption1 == null;
      TPQshowError2 = TPQselectedOption2 == null;
      TPQshowError3 = TPQselectedOption3 == null;
      TPQshowError4 = TPQselectedOption4 == null;
      TPQshowError5 = TPQselectedOption5 == null;
      TPQshowError6 = TPQselectedOption6 == null;
      TPQshowError7 = TPQselectedOption7 == null;
    });

    return !(TPQshowError1 ||
        TPQshowError2 ||
        TPQshowError3 ||
        TPQshowError4 ||
        TPQshowError5 ||
        TPQshowError6 ||
        TPQshowError7);
  }

  bool validateHistoricoSaude() {
    setState(() {
      HSshowError1 = HSselectedOption1 == null;
      HSshowError2 = HSselectedOption2 == null;
      HSshowError3 = HSselectedOption3 == null;
      HSshowError4 = HSselectedOption4 == null;
      HSshowError5 = HSselectedOption5 == null;
      HSshowError6 = HSselectedOption6 == null;
      HSshowError7 = HSselectedOption7 == null;
      HSshowError8 = HSselectedOption8 == null;

      HSshowError9 = _HStextController9.text.isEmpty;
      HSshowError10 = _HStextController10.text.isEmpty;

      HSshowError5opt =
          _HSopcionalTextController5.text.isEmpty && HSshowError5 == 'Sim';
      HSshowError6opt =
          _HSopcionalTextController6.text.isEmpty && HSshowError6 == 'Sim';
    });

    // Retorna true se todos os campos estiverem válidos
    return !(HSshowError1 ||
        HSshowError2 ||
        HSshowError3 ||
        HSshowError4 ||
        HSshowError5 ||
        HSshowError5opt ||
        HSshowError6 ||
        HSshowError6opt ||
        HSshowError7 ||
        HSshowError8 ||
        HSshowError9 ||
        HSshowError10);
  }

  void getAnamneseData(Anamnese anamnese) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nomeController.text = anamnese.nomeCompleto!;
      _emailController.text = anamnese.email!;
      _idadeController.text =
          anamnese.idade != null ? anamnese.idade.toString() : '';
      _telefoneController.text = anamnese.telefone!;
      _responsavelController.text = anamnese.nomeResponsavel ?? '';
      _nomeContatoEmergenciaController.text = anamnese.nomeContatoEmergencia!;
      _telfoneContatoEmergenciaController.text =
          anamnese.telefoneContatoEmergencia!;
      sexoDropdownController.text = anamnese.sexo.toString();
      setState(() {
        selectedSexo = anamnese.sexo;
      });
    });
  }

  void getParqData(Anamnese anamnese) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        TPQselectedOption1 = anamnese.respostasParq?.respostas['testeParqQ1'];
        TPQselectedOption2 = anamnese.respostasParq?.respostas['testeParqQ2'];
        TPQselectedOption3 = anamnese.respostasParq?.respostas['testeParqQ3'];
        TPQselectedOption4 = anamnese.respostasParq?.respostas['testeParqQ4'];
        TPQselectedOption5 = anamnese.respostasParq?.respostas['testeParqQ5'];
        TPQselectedOption6 = anamnese.respostasParq?.respostas['testeParqQ6'];
        TPQselectedOption7 = anamnese.respostasParq?.respostas['testeParqQ7'];
      });
    });
  }

  void getHistSaudeData(Anamnese anamnese) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        HSselectedOption1 =
            anamnese.respostasHistSaude?.respostas['testeHistSaudeQ1'];
        HSselectedOption2 =
            anamnese.respostasHistSaude?.respostas['testeHistSaudeQ2'];
        HSselectedOption3 =
            anamnese.respostasHistSaude?.respostas['testeHistSaudeQ3'];
        HSselectedOption4 =
            anamnese.respostasHistSaude?.respostas['testeHistSaudeQ4'];
        HSselectedOption5 =
            anamnese.respostasHistSaude?.respostas['testeHistSaudeQ5'];
        HSselectedOption6 =
            anamnese.respostasHistSaude?.respostas['testeHistSaudeQ6'];
        HSselectedOption7 =
            anamnese.respostasHistSaude?.respostas['testeHistSaudeQ7'];
        HSselectedOption8 =
            anamnese.respostasHistSaude?.respostas['testeHistSaudeQ8'];

        _HStextController9.text =
            anamnese.respostasHistSaude!.respostas['testeHistSaudeQ9']!;
        _HStextController10.text =
            anamnese.respostasHistSaude!.respostas['testeHistSaudeQ10']!;

        _HSopcionalTextController5.text =
            anamnese.respostasHistSaude!.respostas['opcional5'] ?? '';
        _HSopcionalTextController6.text =
            anamnese.respostasHistSaude!.respostas['opcional6'] ?? '';
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isAnamneseDataLoaded) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>?;
      if (arguments != null) {
        anamnese = arguments['anamnese'] as Anamnese;
        aluno = arguments['aluno'] as Aluno;
        profileImage = arguments['profileImage'];
        getAnamneseData(anamnese);
        getParqData(anamnese);
        getHistSaudeData(anamnese);
      }
      _isAnamneseDataLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    // Função para enviar dados
    Future<void> _submitForm() async {
      try {
        // Valide os dados
        if (validatePersonalData() &&
            validateTesteParq() &&
            validateHistoricoSaude()) {
          // Se todos os dados forem válidos, faça o submit

          AnamneseController anamneseController = AnamneseController();

          await anamneseController.editarAnamense(
            id: anamnese.id!,
            idAluno: aluno.id!,
            data: anamnese.data,
            nomeCompleto: _nomeController.text,
            email: _emailController.text,
            idade: int.parse(_idadeController.text),
            sexo: selectedSexo!,
            telefone: _telefoneController.text,
            status: anamnese.status,
            nomeResponsavel: _responsavelController.text,
            nomeContatoEmergencia: _nomeContatoEmergenciaController.text,
            telefoneContatoEmergencia: _telfoneContatoEmergenciaController.text,
            respostasParq: RespostasParq(
              respostas: {
                'testeParqQ1': TPQselectedOption1!,
                'testeParqQ2': TPQselectedOption2!,
                'testeParqQ3': TPQselectedOption3!,
                'testeParqQ4': TPQselectedOption4!,
                'testeParqQ5': TPQselectedOption5!,
                'testeParqQ6': TPQselectedOption6!,
                'testeParqQ7': TPQselectedOption7!,
              },
            ),
            respostasHistSaude: RespostasHistSaude(
              respostas: {
                'testeHistSaudeQ1': HSselectedOption1!,
                'testeHistSaudeQ2': HSselectedOption2!,
                'testeHistSaudeQ3': HSselectedOption3!,
                'testeHistSaudeQ4': HSselectedOption4!,
                'testeHistSaudeQ5': HSselectedOption5!,
                'testeHistSaudeQ6': HSselectedOption6!,
                'testeHistSaudeQ7': HSselectedOption7!,
                'testeHistSaudeQ8': HSselectedOption8!,
                'testeHistSaudeQ9': _HStextController9.text,
                'testeHistSaudeQ10': _HStextController10.text,
                'opcional5': _HSopcionalTextController5.text,
                'opcional6': _HSopcionalTextController6.text,
              },
            ),
          );
          showMessageSnackBar(
            colorTheme,
            context,
            'Anamense editada com sucesso',
            error: false,
          );
          Navigator.pushNamed(
            context,
            RoutesNames.anamnese.route,
            arguments: {'refresh': true},
          );
        } else {
          // Exiba uma mensagem de erro
          showMessageSnackBar(
            colorTheme,
            context,
            'Há campos inválidos',
            error: true,
          );
        }
      } catch (e) {
        showMessageSnackBar(
          colorTheme,
          context,
          'Ocorreu erro ao editar anamnese',
          error: true,
        );
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        colorTheme: colorTheme,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorTheme.white_onPrimary_100),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: 'LOGO',
      ),
      drawer: Menu(colorTheme: colorTheme),
      endDrawer: NotificationMenu(colorTheme: colorTheme),
      body: Stack(
        clipBehavior: Clip.none, // Permite que os widgets se sobreponham
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.135, // Espaço para o círculo
              ),
              Expanded(
                child: CardContainer(
                  colorTheme: colorTheme,
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Cada Container desses é uma pagina do PageView
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 0, 4, 4),
                                  margin: const EdgeInsets.all(4),
                                  child: Column(
                                    children: [
                                      // Personal Data Form
                                      AnamnesePersonalDataForm(
                                        errors: PDerrors,
                                        colorTheme: colorTheme,
                                        emailController: _emailController,
                                        telefoneController: _telefoneController,
                                        nomeController: _nomeController,
                                        idadeController: _idadeController,
                                        responsavelController:
                                            _responsavelController,
                                        nomeContatoEmergenciaController:
                                            _nomeContatoEmergenciaController,
                                        telfoneContatoEmergenciaController:
                                            _telfoneContatoEmergenciaController,
                                        selectedSexo: selectedSexo,
                                        sexoDropdownController:
                                            sexoDropdownController,
                                        onSexoChanged: (Sexo? value) {
                                          setState(() {
                                            selectedSexo = value;
                                          });
                                        },
                                        validatePersonalData:
                                            validatePersonalData,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 6.0,
                            radius: const Radius.circular(10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                    margin: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        AnamneseTesteparqForm(
                                          colorTheme: colorTheme,
                                          anamnese: anamnese,
                                          TPQselectedOption1:
                                              TPQselectedOption1,
                                          TPQselectedOption2:
                                              TPQselectedOption2,
                                          TPQselectedOption3:
                                              TPQselectedOption3,
                                          TPQselectedOption4:
                                              TPQselectedOption4,
                                          TPQselectedOption5:
                                              TPQselectedOption5,
                                          TPQselectedOption6:
                                              TPQselectedOption6,
                                          TPQselectedOption7:
                                              TPQselectedOption7,
                                          TPQshowError1: TPQshowError1,
                                          TPQshowError2: TPQshowError2,
                                          TPQshowError3: TPQshowError3,
                                          TPQshowError4: TPQshowError4,
                                          TPQshowError5: TPQshowError5,
                                          TPQshowError6: TPQshowError6,
                                          TPQshowError7: TPQshowError7,
                                          onOption1Changed: (String? value) {
                                            setState(() {
                                              TPQselectedOption1 = value;
                                            });
                                          },
                                          onOption2Changed: (String? value) {
                                            setState(() {
                                              TPQselectedOption2 = value;
                                            });
                                          },
                                          onOption3Changed: (String? value) {
                                            setState(() {
                                              TPQselectedOption3 = value;
                                            });
                                          },
                                          onOption4Changed: (String? value) {
                                            setState(() {
                                              TPQselectedOption4 = value;
                                            });
                                          },
                                          onOption5Changed: (String? value) {
                                            setState(() {
                                              TPQselectedOption5 = value;
                                            });
                                          },
                                          onOption6Changed: (String? value) {
                                            setState(() {
                                              TPQselectedOption6 = value;
                                            });
                                          },
                                          onOption7Changed: (String? value) {
                                            setState(() {
                                              TPQselectedOption7 = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 6.0,
                            radius: const Radius.circular(10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 0, 4, 4),
                                    margin: const EdgeInsets.all(4),
                                    child: Column(
                                      children: [
                                        AnamneseHistoricoSaudeForm(
                                          colorTheme: colorTheme,
                                          anamnese: anamnese,
                                          HSselectedOption1: HSselectedOption1,
                                          HSselectedOption2: HSselectedOption2,
                                          HSselectedOption3: HSselectedOption3,
                                          HSselectedOption4: HSselectedOption4,
                                          HSselectedOption5: HSselectedOption5,
                                          HSselectedOption6: HSselectedOption6,
                                          HSselectedOption7: HSselectedOption7,
                                          HSselectedOption8: HSselectedOption8,
                                          HSshowError1: HSshowError1,
                                          HSshowError2: HSshowError2,
                                          HSshowError3: HSshowError3,
                                          HSshowError4: HSshowError4,
                                          HSshowError5: HSshowError5,
                                          HSshowError5opt: HSshowError5opt,
                                          HSshowError6: HSshowError6,
                                          HSshowError6opt: HSshowError6opt,
                                          HSshowError7: HSshowError7,
                                          HSshowError8: HSshowError8,
                                          HSshowError9: HSshowError9,
                                          HSshowError10: HSshowError10,
                                          HStextController9: _HStextController9,
                                          HStextController10:
                                              _HStextController10,
                                          HSopcionalTextController5:
                                              _HSopcionalTextController5,
                                          HSopcionalTextController6:
                                              _HSopcionalTextController6,
                                          onOption1Changed: (String? value) {
                                            setState(() {
                                              HSselectedOption1 = value;
                                            });
                                          },
                                          onOption2Changed: (String? value) {
                                            setState(() {
                                              HSselectedOption2 = value;
                                            });
                                          },
                                          onOption3Changed: (String? value) {
                                            setState(() {
                                              HSselectedOption3 = value;
                                            });
                                          },
                                          onOption4Changed: (String? value) {
                                            setState(() {
                                              HSselectedOption4 = value;
                                            });
                                          },
                                          onOption5Changed: (String? value) {
                                            setState(() {
                                              HSselectedOption5 = value;
                                            });
                                          },
                                          onOption6Changed: (String? value) {
                                            setState(() {
                                              HSselectedOption6 = value;
                                            });
                                          },
                                          onOption7Changed: (String? value) {
                                            setState(() {
                                              HSselectedOption7 = value;
                                            });
                                          },
                                          onOption8Changed: (String? value) {
                                            setState(() {
                                              HSselectedOption8 = value;
                                            });
                                          },
                                        ),
                                      ],
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
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: colorTheme.light_container_500,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: ExpandingDotsEffect(
                          dotHeight: 8.0,
                          dotWidth: 8.0,
                          activeDotColor: colorTheme.indigo_primary_800,
                          dotColor: colorTheme.grey_font_500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                      child: Center(
                        child: PrimaryButton(
                          verticalPadding: 12.0,
                          horizontalPadding:
                              MediaQuery.of(context).size.width * 0.170,
                          label: 'Salvar',
                          onPressed: () async {
                            _submitForm();
                          },
                          backgroundColor: colorTheme.indigo_primary_500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          PortraitPositionedUser(
            topPadding: 0.01, // Ajuste a distância do topo
            backgroundColor: colorTheme.grey_font_500,
            imagePath: profileImage != '' ? profileImage : '',
          ),
        ],
      ),
    );
  }
}
