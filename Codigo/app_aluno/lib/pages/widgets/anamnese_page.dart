import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/button/primary_button.dart';
import 'package:SmartTrainer/components/form/anamnese_historico_saude_form_test.dart';
import 'package:SmartTrainer/components/form/anamnese_personal_data_form_test.dart';
import 'package:SmartTrainer/components/form/anamnese_testeparq_form_test.dart';
import 'package:SmartTrainer/components/stack_bar/snack_bar.dart';
import 'package:SmartTrainer/components/text/headline_title.dart';
import 'package:SmartTrainer/components/header/header.dart';
import 'package:SmartTrainer/components/menu.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/router.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';
import 'package:SmartTrainer/pages/controller/anamnese_controller.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer/fonts.dart';
import 'package:provider/provider.dart';

class AnamnesePage extends StatefulWidget {
  const AnamnesePage({Key? key, this.anamensesOnTest}) : super(key: key);
  final Anamnese? anamensesOnTest;

  @override
  _AnamnesePageState createState() => _AnamnesePageState();
}

class _AnamnesePageState extends State<AnamnesePage> {
  int currentFormIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isLoadingPost = false;
  Anamnese? ultimaAnamnese;

  final GlobalKey<AnamnesePersonalDataFormState> _personalDataFormKey =
      GlobalKey<AnamnesePersonalDataFormState>();
  final GlobalKey<AnamneseTesteparqFormState> _testeparqFormKey =
      GlobalKey<AnamneseTesteparqFormState>();
  final GlobalKey<AnamneseHistoricoSaudeFormState> _historicoSaudeFormKey =
      GlobalKey<AnamneseHistoricoSaudeFormState>();

  Future<void> carregarAnamnese() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final Aluno? aluno =
          Provider.of<AlunoProvider>(context, listen: false).aluno;

      // Tenta carregar a anamnese do Firebase
      final anamnese = await AnamneseController().carregarAnamnese(aluno!.id!);
      Provider.of<AlunoProvider>(context, listen: false)
          .updateUltimaAnamnese(anamnese!);
      setState(() {
        ultimaAnamnese = anamnese;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        ultimaAnamnese = widget.anamensesOnTest;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    carregarAnamnese();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final screenWidth = MediaQuery.of(context).size.width;
    final aluno = Provider.of<AlunoProvider>(context).aluno;

    var colorTheme = brightness == Brightness.light
        ? CustomTheme.colorFamilyLight
        : CustomTheme.colorFamilyDark;

    Future<void> _submitAnamnese() async {
      final personalData = Provider.of<AlunoProvider>(context, listen: false)
          .ultimaAnamnesePersonalData;
      final parqData = Provider.of<AlunoProvider>(context, listen: false)
          .ultimaAnamneseParqData;
      final histSaudeData = Provider.of<AlunoProvider>(context, listen: false)
          .ultimaAnamneseHistSaudeData;

      final respostasParq = RespostasParq.fromMap(parqData);
      final respostasHistSaude = RespostasHistSaude.fromMap(histSaudeData);

      AnamneseController anamneseController = AnamneseController();

      await anamneseController.editarAnamense(
        id: ultimaAnamnese?.id ?? '',
        idAluno: aluno?.id ?? '',
        data: DateTime.now(),
        nomeCompleto: personalData['nomeCompleto'],
        email: personalData['email'],
        nomeResponsavel: personalData['nomeResponsavel'],
        status: StatusAnamneseEnum.REALIZADA,
        idade: personalData['idade'],
        sexo:
            Sexo.values.firstWhere((e) => e.toString() == personalData['sexo']),
        telefone: personalData['telefone'],
        nomeContatoEmergencia: personalData['nomeContatoEmergencia'],
        telefoneContatoEmergencia: personalData['telefoneContatoEmergencia'],
        respostasParq: respostasParq,
        respostasHistSaude: respostasHistSaude,
      );
      Provider.of<AlunoProvider>(context, listen: false).clearAnamneseData();
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesNames.home.route,
        (route) => false,
      );
    }

    void _showErrorSnackBar() {
      showSnackBar(
        context: context,
        message: 'Ocorreu erro ao adicionar anamnese',
        error: true,
      );
    }

    void _showSuccessSnackBar(String message) {
      showSnackBar(
        context: context,
        message: message,
        error: false,
      );
    }

    void _nextFormStep() {
      setState(() {
        currentFormIndex++;
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }

    Widget getForm() {
      switch (currentFormIndex) {
        case 0:
          return AnamnesePersonalDataForm(
            colorTheme: colorTheme,
            key: _personalDataFormKey,
            ultimaAnamnese: ultimaAnamnese,
          );
        case 1:
          return AnamneseTesteparqForm(
            colorTheme: colorTheme,
            key: _testeparqFormKey,
            ultimaAnamnese: ultimaAnamnese,
          );
        case 2:
          return AnamneseHistoricoSaudeForm(
            colorTheme: colorTheme,
            key: _historicoSaudeFormKey,
            ultimaAnamnese: ultimaAnamnese,
          );
        default:
          return AnamnesePersonalDataForm(
            colorTheme: colorTheme,
            key: _personalDataFormKey,
            ultimaAnamnese: ultimaAnamnese,
          );
      }
    }

    Future<void> _handleFormSubmission({
      required dynamic formKey,
      required Function(Map<String, dynamic>) updateFunction,
      required Map<String, dynamic>? Function() getFormData,
    }) async {
      final formData = getFormData();
      if (formData != null && formData.isNotEmpty) {
        updateFunction(formData);
        _nextFormStep();
      } else {
        _showErrorSnackBar();
      }
    }

    Future<void> _handleFinalSubmission() async {
      setState(() => _isLoadingPost = true);

      final histSaudeFormData =
          _historicoSaudeFormKey.currentState?.getTesteHistSaudeData();
      if (histSaudeFormData != null) {
        Provider.of<AlunoProvider>(context, listen: false)
            .updateHistSaudeData(histSaudeFormData);

        try {
          await _submitAnamnese();
          _showSuccessSnackBar('Anamnese cadastrada com sucesso!');
        } catch (e) {
          _showErrorSnackBar();
        }
      } else {
        _showErrorSnackBar();
      }
      setState(() => _isLoadingPost = false);
    }

    Future<void> _submitForm() async {
      try {
        if (currentFormIndex == 0) {
          await _handleFormSubmission(
            formKey: _personalDataFormKey,
            updateFunction: (formData) =>
                Provider.of<AlunoProvider>(context, listen: false)
                    .updatePersonalData(formData),
            getFormData: () => _personalDataFormKey.currentState
                ?.getPersonalFormDataforSubmit(),
          );
        } else if (currentFormIndex == 1) {
          await _handleFormSubmission(
            formKey: _testeparqFormKey,
            updateFunction: (formData) =>
                Provider.of<AlunoProvider>(context, listen: false)
                    .updateParqData(formData),
            getFormData: () =>
                _testeparqFormKey.currentState?.getTesteParqFormData(),
          );
        } else if (currentFormIndex == 2) {
          _handleFinalSubmission();
        }
      } catch (e) {
        _showErrorSnackBar();
      }
    }

    return Scaffold(
      drawer: Menu(colorTheme: colorTheme),
      appBar: Header(
        colorTheme: colorTheme,
      ),
      body: Container(
        width: screenWidth,
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: MediaQuery.of(context).size.width * 0.08,
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    HeadlineTitles(
                      title: 'Questionário de Anamnese',
                      colorTheme: colorTheme,
                      subtile: currentFormIndex == 0
                          ? 'Informações Pessoais'
                          : currentFormIndex == 1
                              ? 'Teste Par-q'
                              : 'Histórico de saúde',
                    ),
                    const SizedBox(height: 10),
                    ultimaAnamnese != null
                        ? Column(
                            children: [
                              getForm(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, bottom: 10.0, right: 10),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: _isLoadingPost
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : (currentFormIndex == 2 &&
                                              ultimaAnamnese!.status !=
                                                  StatusAnamneseEnum.PEDENTE)
                                          ? PrimaryButton(
                                              horizontalPadding:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                              label: 'Anamnese já realizada',
                                              onPressed: () {},
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .label14px!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: colorTheme
                                                        .black_onSecondary_100,
                                                  ),
                                              backgroundColor:
                                                  colorTheme.gray_500,
                                            )
                                          : PrimaryButton(
                                              horizontalPadding:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                              label: currentFormIndex == 2
                                                  ? 'Enviar'
                                                  : 'Próxima página',
                                              onPressed: () {
                                                setState(() {
                                                  _submitForm();
                                                });
                                              },
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .label14px!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: colorTheme
                                                        .black_onSecondary_100,
                                                  ),
                                              backgroundColor: colorTheme
                                                  .lemon_secondary_500,
                                            ),
                                ),
                              ),
                            ],
                          )
                        : const Text('Anamense não solicitada'),
                  ],
                ),
        ),
      ),
    );
  }
}
