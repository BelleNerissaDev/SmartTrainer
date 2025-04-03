import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:SmartTrainer/components/radio_button/radio_button_group.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/utils/anamnese_questions.dart';
import 'package:SmartTrainer/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer/fonts.dart';

class AnamneseHistoricoSaudeForm extends StatefulWidget {
  final MyColorFamily colorTheme;
  final Anamnese? ultimaAnamnese;

  const AnamneseHistoricoSaudeForm(
      {Key? key, required this.colorTheme, required this.ultimaAnamnese})
      : super(key: key);

  @override
  AnamneseHistoricoSaudeFormState createState() =>
      AnamneseHistoricoSaudeFormState();
}

class AnamneseHistoricoSaudeFormState
    extends State<AnamneseHistoricoSaudeForm> {
  final _formKey = GlobalKey<FormState>();

  // Variáveis de seleção dos Radio Buttons
  String? selectedOption1;
  String? selectedOption2;
  String? selectedOption3;
  String? selectedOption4;
  String? selectedOption5;
  String? selectedOption6;
  String? selectedOption7;
  String? selectedOption8;

  // Controladores dos campos de texto
  final _textController9 = TextEditingController();
  final _textController10 = TextEditingController();

  // Controladores para os campos de texto opcionais
  final _opcionalTextController5 = TextEditingController();
  final _opcionalTextController6 = TextEditingController();

  bool isDataLoaded = false;

  // Variáveis de erro para exibir mensagens de validação
  bool showError1 = false;
  bool showError2 = false;
  bool showError3 = false;
  bool showError4 = false;
  bool showError5 = false;
  bool showError5opt = false;
  bool showError6 = false;
  bool showError6opt = false;
  bool showError7 = false;
  bool showError8 = false;
  bool showError9 = false;
  bool showError10 = false;

  // Método para validar os campos do formulário
  bool validateForm() {
    setState(() {
      showError1 = selectedOption1 == null;
      showError2 = selectedOption2 == null;
      showError3 = selectedOption3 == null;
      showError4 = selectedOption4 == null;
      showError5 = selectedOption5 == null;
      showError6 = selectedOption6 == null;
      showError7 = selectedOption7 == null;
      showError8 = selectedOption8 == null;
      showError9 = _textController9.text.isEmpty;
      showError10 = _textController9.text.isEmpty;
      showError5opt =
          _opcionalTextController5.text.isEmpty && selectedOption5 == 'Sim';
      showError6opt =
          _opcionalTextController6.text.isEmpty && selectedOption6 == 'Sim';
    });

    // Retorna true se todos os campos estiverem válidos
    return !(showError1 ||
        showError2 ||
        showError3 ||
        showError4 ||
        showError5 ||
        showError6 ||
        showError7 ||
        showError8 ||
        showError9 ||
        showError10 ||
        showError5opt ||
        showError6opt);
  }

  void getHistSaudeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.ultimaAnamnese != null) {
        setState(() {
          selectedOption1 = widget.ultimaAnamnese!.respostasHistSaude
              ?.respostas['testeHistSaudeQ1'];
          selectedOption2 = widget.ultimaAnamnese!.respostasHistSaude
              ?.respostas['testeHistSaudeQ2'];
          selectedOption3 = widget.ultimaAnamnese!.respostasHistSaude
              ?.respostas['testeHistSaudeQ3'];
          selectedOption4 = widget.ultimaAnamnese!.respostasHistSaude
              ?.respostas['testeHistSaudeQ4'];
          selectedOption5 = widget.ultimaAnamnese!.respostasHistSaude
              ?.respostas['testeHistSaudeQ5'];
          selectedOption6 = widget.ultimaAnamnese!.respostasHistSaude
              ?.respostas['testeHistSaudeQ6'];
          selectedOption7 = widget.ultimaAnamnese!.respostasHistSaude
              ?.respostas['testeHistSaudeQ7'];
          selectedOption8 = widget.ultimaAnamnese!.respostasHistSaude
              ?.respostas['testeHistSaudeQ8'];

          _textController9.text = widget.ultimaAnamnese!.respostasHistSaude!
              .respostas['testeHistSaudeQ9']!;
          _textController10.text = widget.ultimaAnamnese!.respostasHistSaude!
              .respostas['testeHistSaudeQ10']!;

          _opcionalTextController5.text = widget
                  .ultimaAnamnese!.respostasHistSaude?.respostas['opcional5'] ??
              '';
          _opcionalTextController6.text = widget
                  .ultimaAnamnese!.respostasHistSaude?.respostas['opcional6'] ??
              '';

          isDataLoaded = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getHistSaudeData();
  }

  // Método para gerar o mapa com os dados preenchidos
  Map<String, dynamic>? getTesteHistSaudeData() {
    bool isValid = validateForm();

    if (isValid) {
      return {
        'testeHistSaudeQ1': selectedOption1,
        'testeHistSaudeQ2': selectedOption2,
        'testeHistSaudeQ3': selectedOption3,
        'testeHistSaudeQ4': selectedOption4,
        'testeHistSaudeQ5': selectedOption5,
        'opcional5': _opcionalTextController5.text,
        'testeHistSaudeQ6': selectedOption6,
        'opcional6': _opcionalTextController6.text,
        'testeHistSaudeQ7': selectedOption7,
        'testeHistSaudeQ8': selectedOption8,
        'testeHistSaudeQ9': _textController9.text,
        'testeHistSaudeQ10': _textController10.text,
      };
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = widget.colorTheme;
    final enabled = widget.ultimaAnamnese!.status != StatusAnamneseEnum.PEDENTE
        ? false
        : true;

    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ1.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.gray_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    enabled: enabled,
                    colorTheme: colorTheme,
                    showError: showError1,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ1.options,
                    hadTextField: false,
                    groupValue: selectedOption1,
                    onChanged: (value) {
                      setState(() {
                        selectedOption1 = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ2.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.gray_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    enabled: enabled,
                    colorTheme: colorTheme,
                    showError: showError2,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ2.options,
                    groupValue: selectedOption2,
                    hadTextField: false,
                    onChanged: (value) {
                      setState(() {
                        selectedOption2 = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ3.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.gray_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    enabled: enabled,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ3.options,
                    showError: showError3,
                    colorTheme: colorTheme,
                    groupValue: selectedOption3,
                    hadTextField: false,
                    onChanged: (value) {
                      setState(() {
                        selectedOption3 = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ4.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.gray_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    enabled: enabled,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ4.options,
                    showError: showError4,
                    colorTheme: colorTheme,
                    groupValue: selectedOption4,
                    hadTextField: false,
                    onChanged: (value) {
                      setState(() {
                        selectedOption4 = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ5.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.gray_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    enabled: enabled,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ5.options,
                    showError: showError5,
                    colorTheme: colorTheme,
                    hadTextField: true,
                    controllerTextField: _opcionalTextController5,
                    groupValue: selectedOption5,
                    onChanged: (value) {
                      setState(() {
                        selectedOption5 = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ6.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.gray_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    enabled: enabled,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ6.options,
                    showError: showError6,
                    hadTextField: true,
                    controllerTextField: _opcionalTextController6,
                    colorTheme: colorTheme,
                    groupValue: selectedOption6,
                    onChanged: (value) {
                      setState(() {
                        selectedOption6 = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ7.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.gray_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    enabled: enabled,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ7.options,
                    showError: showError7,
                    hadTextField: false,
                    colorTheme: colorTheme,
                    groupValue: selectedOption7,
                    onChanged: (value) {
                      setState(() {
                        selectedOption7 = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ8.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.gray_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    enabled: enabled,
                    colorTheme: colorTheme,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ8.options,
                    showError: showError8,
                    hadTextField: false,
                    groupValue: selectedOption8,
                    onChanged: (value) {
                      setState(() {
                        selectedOption8 = value;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ9.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.gray_700,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    child: ObscuredTextField(
                      enabled: enabled,
                      colorTheme: colorTheme,
                      controller: _textController9,
                      backgroundColor: colorTheme.gray_500.withOpacity(0),
                      showErrors: showError9,
                      errors: showError9
                          ? [ErrorMessage(message: 'Inválido', error: true)]
                          : [],
                      obscureText: false,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ10.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.gray_700,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    child: ObscuredTextField(
                      enabled: enabled,
                      colorTheme: colorTheme,
                      controller: _textController10,
                      backgroundColor: colorTheme.gray_500.withOpacity(0),
                      showErrors: showError10,
                      errors: showError10
                          ? [ErrorMessage(message: 'Inválido', error: true)]
                          : [],
                      obscureText: false,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
