import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/radio_button/radio_button_group.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/utils/anamnese_questions.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer/fonts.dart';

class AnamneseTesteparqForm extends StatefulWidget {
  final MyColorFamily colorTheme;
  final Anamnese? ultimaAnamnese;

  const AnamneseTesteparqForm(
      {Key? key, required this.colorTheme, required this.ultimaAnamnese})
      : super(key: key);

  @override
  AnamneseTesteparqFormState createState() => AnamneseTesteparqFormState();
}

class AnamneseTesteparqFormState extends State<AnamneseTesteparqForm> {
  final _formKey = GlobalKey<FormState>();
  // Variáveis de seleção dos Radio Buttons
  String? selectedOption1;
  String? selectedOption2;
  String? selectedOption3;
  String? selectedOption4;
  String? selectedOption5;
  String? selectedOption6;
  String? selectedOption7;

  bool isDataLoaded = false;

  // Variáveis de erro para exibir mensagens de validação
  bool showError1 = false;
  bool showError2 = false;
  bool showError3 = false;
  bool showError4 = false;
  bool showError5 = false;
  bool showError6 = false;
  bool showError7 = false;

  // Método para gerar o mapa com os dados dos Radio Buttons
  Map<String, dynamic> getTesteParqFormData() {
    bool isValid = validateForm();
    if (isValid) {
      return {
        'testeParqQ1': selectedOption1,
        'testeParqQ2': selectedOption2,
        'testeParqQ3': selectedOption3,
        'testeParqQ4': selectedOption4,
        'testeParqQ5': selectedOption5,
        'testeParqQ6': selectedOption6,
        'testeParqQ7': selectedOption7,
      };
    } else {
      return {};
    }
  }

  bool validateForm() {
    setState(() {
      showError1 = selectedOption1 == null;
      showError2 = selectedOption2 == null;
      showError3 = selectedOption3 == null;
      showError4 = selectedOption4 == null;
      showError5 = selectedOption5 == null;
      showError6 = selectedOption6 == null;
      showError7 = selectedOption7 == null;
    });

    return !(showError1 ||
        showError2 ||
        showError3 ||
        showError4 ||
        showError5 ||
        showError6 ||
        showError7);
  }

  void getParqData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.ultimaAnamnese != null) {
        setState(() {
          selectedOption1 =
              widget.ultimaAnamnese!.respostasParq?.respostas['testeParqQ1'];
          selectedOption2 =
              widget.ultimaAnamnese!.respostasParq?.respostas['testeParqQ2'];
          selectedOption3 =
              widget.ultimaAnamnese!.respostasParq?.respostas['testeParqQ3'];
          selectedOption4 =
              widget.ultimaAnamnese!.respostasParq?.respostas['testeParqQ4'];
          selectedOption5 =
              widget.ultimaAnamnese!.respostasParq?.respostas['testeParqQ5'];
          selectedOption6 =
              widget.ultimaAnamnese!.respostasParq?.respostas['testeParqQ6'];
          selectedOption7 =
              widget.ultimaAnamnese!.respostasParq?.respostas['testeParqQ7'];
          isDataLoaded = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getParqData();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = widget.colorTheme;
    final enabled = widget.ultimaAnamnese!.status != StatusAnamneseEnum.PEDENTE
        ? false
        : true;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  (TesteParqQuestions.values
                                  .indexOf(TesteParqQuestions.testeParqQ1) +
                              1)
                          .toString() +
                      '- ' +
                      TesteParqQuestions.testeParqQ1.question,
                  style: Theme.of(context).textTheme.body12px!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorTheme.gray_700,
                      ),
                ),
              ),
              CustomRadioButtonGroup(
                  enabled: enabled,
                  options: TesteParqQuestions.testeParqQ1.options,
                  colorTheme: colorTheme,
                  hadTextField: false,
                  showError: showError1,
                  groupValue: selectedOption1,
                  onChanged: (value) {
                    setState(() {
                      selectedOption1 = value;
                      showError1 = false;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  (TesteParqQuestions.values
                                  .indexOf(TesteParqQuestions.testeParqQ2) +
                              1)
                          .toString() +
                      '- ' +
                      TesteParqQuestions.testeParqQ2.question,
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
                  options: TesteParqQuestions.testeParqQ2.options,
                  hadTextField: false,
                  groupValue: selectedOption2,
                  onChanged: (value) {
                    setState(() {
                      selectedOption2 = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  (TesteParqQuestions.values
                                  .indexOf(TesteParqQuestions.testeParqQ3) +
                              1)
                          .toString() +
                      '- ' +
                      TesteParqQuestions.testeParqQ3.question,
                  style: Theme.of(context).textTheme.body12px!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorTheme.gray_700,
                      ),
                ),
              ),
              CustomRadioButtonGroup(
                  enabled: enabled,
                  options: TesteParqQuestions.testeParqQ3.options,
                  showError: showError3,
                  colorTheme: colorTheme,
                  hadTextField: false,
                  groupValue: selectedOption3,
                  onChanged: (value) {
                    setState(() {
                      selectedOption3 = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  (TesteParqQuestions.values
                                  .indexOf(TesteParqQuestions.testeParqQ4) +
                              1)
                          .toString() +
                      '- ' +
                      TesteParqQuestions.testeParqQ4.question,
                  style: Theme.of(context).textTheme.body12px!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorTheme.gray_700,
                      ),
                ),
              ),
              CustomRadioButtonGroup(
                  enabled: enabled,
                  colorTheme: colorTheme,
                  showError: showError4,
                  options: TesteParqQuestions.testeParqQ4.options,
                  hadTextField: false,
                  groupValue: selectedOption4,
                  onChanged: (value) {
                    setState(() {
                      selectedOption4 = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  (TesteParqQuestions.values
                                  .indexOf(TesteParqQuestions.testeParqQ5) +
                              1)
                          .toString() +
                      '- ' +
                      TesteParqQuestions.testeParqQ5.question,
                  style: Theme.of(context).textTheme.body12px!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorTheme.gray_700,
                      ),
                ),
              ),
              CustomRadioButtonGroup(
                  enabled: enabled,
                  showError: showError5,
                  options: TesteParqQuestions.testeParqQ5.options,
                  colorTheme: colorTheme,
                  hadTextField: false,
                  groupValue: selectedOption5,
                  onChanged: (value) {
                    setState(() {
                      selectedOption5 = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  (TesteParqQuestions.values
                                  .indexOf(TesteParqQuestions.testeParqQ6) +
                              1)
                          .toString() +
                      '- ' +
                      TesteParqQuestions.testeParqQ6.question,
                  style: Theme.of(context).textTheme.body12px!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorTheme.gray_700,
                      ),
                ),
              ),
              CustomRadioButtonGroup(
                  enabled: enabled,
                  showError: showError6,
                  options: TesteParqQuestions.testeParqQ6.options,
                  colorTheme: colorTheme,
                  hadTextField: false,
                  groupValue: selectedOption6,
                  onChanged: (value) {
                    setState(() {
                      selectedOption6 = value;
                    });
                  }),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  (TesteParqQuestions.values
                                  .indexOf(TesteParqQuestions.testeParqQ7) +
                              1)
                          .toString() +
                      '- ' +
                      TesteParqQuestions.testeParqQ7.question,
                  style: Theme.of(context).textTheme.body12px!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorTheme.gray_700,
                      ),
                ),
              ),
              CustomRadioButtonGroup(
                  enabled: enabled,
                  showError: showError7,
                  options: TesteParqQuestions.testeParqQ7.options,
                  colorTheme: colorTheme,
                  hadTextField: false,
                  groupValue: selectedOption7,
                  onChanged: (value) {
                    setState(() {
                      selectedOption7 = value;
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
