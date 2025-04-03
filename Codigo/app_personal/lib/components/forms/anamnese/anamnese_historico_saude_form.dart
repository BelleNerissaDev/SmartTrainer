import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/components/titles/headline_titles.dart';
import 'package:SmartTrainer_Personal/components/radio_button/radio_button_group.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/utils/anamnese_questions.dart';
import 'package:SmartTrainer_Personal/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

// ignore: must_be_immutable
class AnamneseHistoricoSaudeForm extends StatelessWidget {
  final ColorFamily colorTheme;
  final Anamnese? anamnese;
  late String? HSselectedOption1;
  late String? HSselectedOption2;
  late String? HSselectedOption3;
  late String? HSselectedOption4;
  late String? HSselectedOption5;
  late String? HSselectedOption6;
  late String? HSselectedOption7;
  late String? HSselectedOption8;
  final TextEditingController HStextController9;
  final TextEditingController HStextController10;
  final bool HSshowError1;
  final bool HSshowError2;
  final bool HSshowError3;
  final bool HSshowError4;
  final bool HSshowError5;
  final bool HSshowError6;
  final bool HSshowError7;
  final bool HSshowError8;
  final bool HSshowError9;
  final bool HSshowError10;
  final bool HSshowError5opt;
  final bool HSshowError6opt;
  final TextEditingController HSopcionalTextController5;
  final TextEditingController HSopcionalTextController6;
  final Function(String?) onOption1Changed;
  final Function(String?) onOption2Changed;
  final Function(String?) onOption3Changed;
  final Function(String?) onOption4Changed;
  final Function(String?) onOption5Changed;
  final Function(String?) onOption6Changed;
  final Function(String?) onOption7Changed;
  final Function(String?) onOption8Changed;

  AnamneseHistoricoSaudeForm(
      {Key? key,
      required this.colorTheme,
      required this.anamnese,
      required this.HSselectedOption1,
      required this.HSselectedOption2,
      required this.HSselectedOption3,
      required this.HSselectedOption4,
      required this.HSselectedOption5,
      required this.HSselectedOption6,
      required this.HSselectedOption7,
      required this.HSselectedOption8,
      required this.HStextController9,
      required this.HStextController10,
      required this.HSshowError1,
      required this.HSshowError2,
      required this.HSshowError3,
      required this.HSshowError4,
      required this.HSshowError5,
      required this.HSshowError6,
      required this.HSshowError7,
      required this.HSshowError8,
      required this.HSshowError9,
      required this.HSshowError10,
      required this.HSshowError5opt,
      required this.HSshowError6opt,
      required this.HSopcionalTextController5,
      required this.HSopcionalTextController6,
      required this.onOption1Changed,
      required this.onOption2Changed,
      required this.onOption3Changed,
      required this.onOption4Changed,
      required this.onOption5Changed,
      required this.onOption6Changed,
      required this.onOption7Changed,
      required this.onOption8Changed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: [
            const HeadlineTitles(title: 'Histórico de saúde'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ1.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.grey_font_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    colorTheme: colorTheme,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ1.options,
                    showError: HSshowError1,
                    hadTextField: false,
                    groupValue: HSselectedOption1,
                    onChanged: (value) {
                      onOption1Changed(value);
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ2.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.grey_font_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    colorTheme: colorTheme,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ2.options,
                    showError: HSshowError2,
                    groupValue: HSselectedOption2,
                    hadTextField: false,
                    onChanged: (value) {
                      onOption2Changed(value);
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ3.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.grey_font_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    options: TesteHistSaudeQuestions.testeHistSaudeQ3.options,
                    colorTheme: colorTheme,
                    showError: HSshowError3,
                    groupValue: HSselectedOption3,
                    hadTextField: false,
                    onChanged: (value) {
                      onOption3Changed(value);
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ4.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.grey_font_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    options: TesteHistSaudeQuestions.testeHistSaudeQ4.options,
                    showError: HSshowError4,
                    colorTheme: colorTheme,
                    groupValue: HSselectedOption4,
                    hadTextField: true,
                    onChanged: (value) {
                      onOption4Changed(value);
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ5.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.grey_font_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    options: TesteHistSaudeQuestions.testeHistSaudeQ5.options,
                    showError: HSshowError5,
                    colorTheme: colorTheme,
                    hadTextField: true,
                    groupValue: HSselectedOption5,
                    onChanged: (value) {
                      onOption5Changed(value);
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ6.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.grey_font_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    options: TesteHistSaudeQuestions.testeHistSaudeQ6.options,
                    showError: HSshowError6,
                    hadTextField: true,
                    colorTheme: colorTheme,
                    groupValue: HSselectedOption6,
                    onChanged: (value) {
                      onOption6Changed(value);
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ7.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.grey_font_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    options: TesteHistSaudeQuestions.testeHistSaudeQ7.options,
                    showError: HSshowError7,
                    hadTextField: true,
                    colorTheme: colorTheme,
                    groupValue: HSselectedOption7,
                    onChanged: (value) {
                      onOption7Changed(value);
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ8.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.grey_font_700,
                        ),
                  ),
                ),
                CustomRadioButtonGroup(
                    colorTheme: colorTheme,
                    options: TesteHistSaudeQuestions.testeHistSaudeQ8.options,
                    showError: HSshowError8,
                    hadTextField: false,
                    groupValue: HSselectedOption8,
                    onChanged: (value) {
                      onOption8Changed(value);
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    TesteHistSaudeQuestions.testeHistSaudeQ9.question,
                    style: Theme.of(context).textTheme.body12px!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorTheme.grey_font_700,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    child: ObscuredTextField(
                      colorTheme: colorTheme,
                      controller: HStextController9,
                      backgroundColor: colorTheme.grey_font_500.withOpacity(0),
                      showErrors: HSshowError9,
                      errors: HSshowError9
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
                          color: colorTheme.grey_font_700,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    child: ObscuredTextField(
                      colorTheme: colorTheme,
                      controller: HStextController10,
                      backgroundColor: colorTheme.grey_font_500.withOpacity(0),
                      showErrors: HSshowError10,
                      errors: HSshowError10
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
