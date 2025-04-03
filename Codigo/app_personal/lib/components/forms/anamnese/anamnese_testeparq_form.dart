import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/titles/headline_titles.dart';
import 'package:SmartTrainer_Personal/components/radio_button/radio_button_group.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/utils/anamnese_questions.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

// ignore: must_be_immutable
class AnamneseTesteparqForm extends StatelessWidget {
  final ColorFamily colorTheme;
  final Anamnese? anamnese;
  late String? TPQselectedOption1;
  late String? TPQselectedOption2;
  late String? TPQselectedOption3;
  late String? TPQselectedOption4;
  late String? TPQselectedOption5;
  late String? TPQselectedOption6;
  late String? TPQselectedOption7;
  final bool TPQshowError1;
  final bool TPQshowError2;
  final bool TPQshowError3;
  final bool TPQshowError4;
  final bool TPQshowError5;
  final bool TPQshowError6;
  final bool TPQshowError7;
  final Function(String?) onOption1Changed;
  final Function(String?) onOption2Changed;
  final Function(String?) onOption3Changed;
  final Function(String?) onOption4Changed;
  final Function(String?) onOption5Changed;
  final Function(String?) onOption6Changed;
  final Function(String?) onOption7Changed;

  AnamneseTesteparqForm({
    Key? key,
    required this.colorTheme,
    required this.anamnese,
    required this.TPQselectedOption1,
    required this.TPQselectedOption2,
    required this.TPQselectedOption3,
    required this.TPQselectedOption4,
    required this.TPQselectedOption5,
    required this.TPQselectedOption6,
    required this.TPQselectedOption7,
    required this.TPQshowError1,
    required this.TPQshowError2,
    required this.TPQshowError3,
    required this.TPQshowError4,
    required this.TPQshowError5,
    required this.TPQshowError6,
    required this.TPQshowError7,
    required this.onOption1Changed,
    required this.onOption2Changed,
    required this.onOption3Changed,
    required this.onOption4Changed,
    required this.onOption5Changed,
    required this.onOption6Changed,
    required this.onOption7Changed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeadlineTitles(title: 'Teste Par-q'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                TesteParqQuestions.testeParqQ1.question,
                style: Theme.of(context).textTheme.body12px!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorTheme.grey_font_700,
                    ),
              ),
            ),
            CustomRadioButtonGroup(
              key: const Key('radio_button_TPQQ1'),
              options: TesteParqQuestions.testeParqQ1.options,
              colorTheme: colorTheme,
              hadTextField: false,
              showError: TPQshowError1,
              groupValue: TPQselectedOption1,
              onChanged: (String? value) {
                onOption1Changed(value);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                TesteParqQuestions.testeParqQ2.question,
                style: Theme.of(context).textTheme.body12px!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorTheme.grey_font_700,
                    ),
              ),
            ),
            CustomRadioButtonGroup(
                key: const Key('radio_button_TPQQ2'),
                colorTheme: colorTheme,
                options: TesteParqQuestions.testeParqQ2.options,
                showError: TPQshowError2,
                hadTextField: false,
                groupValue: TPQselectedOption2,
                onChanged: (value) {
                  onOption2Changed(value);
                }),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                TesteParqQuestions.testeParqQ3.question,
                style: Theme.of(context).textTheme.body12px!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorTheme.grey_font_700,
                    ),
              ),
            ),
            CustomRadioButtonGroup(
                options: TesteParqQuestions.testeParqQ3.options,
                showError: TPQshowError3,
                colorTheme: colorTheme,
                hadTextField: false,
                groupValue: TPQselectedOption3,
                onChanged: (value) {
                  onOption3Changed(value);
                }),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                TesteParqQuestions.testeParqQ4.question,
                style: Theme.of(context).textTheme.body12px!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorTheme.grey_font_700,
                    ),
              ),
            ),
            CustomRadioButtonGroup(
                colorTheme: colorTheme,
                showError: TPQshowError4,
                options: TesteParqQuestions.testeParqQ4.options,
                hadTextField: false,
                groupValue: TPQselectedOption4,
                onChanged: (value) {
                  onOption4Changed(value);
                }),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                TesteParqQuestions.testeParqQ5.question,
                style: Theme.of(context).textTheme.body12px!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorTheme.grey_font_700,
                    ),
              ),
            ),
            CustomRadioButtonGroup(
                showError: TPQshowError5,
                options: TesteParqQuestions.testeParqQ5.options,
                colorTheme: colorTheme,
                hadTextField: false,
                groupValue: TPQselectedOption5,
                onChanged: (value) {
                  onOption5Changed(value);
                }),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                TesteParqQuestions.testeParqQ6.question,
                style: Theme.of(context).textTheme.body12px!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorTheme.grey_font_700,
                    ),
              ),
            ),
            CustomRadioButtonGroup(
                showError: TPQshowError6,
                options: TesteParqQuestions.testeParqQ6.options,
                colorTheme: colorTheme,
                hadTextField: false,
                groupValue: TPQselectedOption6,
                onChanged: (value) {
                  onOption6Changed(value);
                }),
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                TesteParqQuestions.testeParqQ7.question,
                style: Theme.of(context).textTheme.body12px!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorTheme.grey_font_700,
                    ),
              ),
            ),
            CustomRadioButtonGroup(
                showError: TPQshowError7,
                options: TesteParqQuestions.testeParqQ7.options,
                colorTheme: colorTheme,
                hadTextField: false,
                groupValue: TPQselectedOption7,
                onChanged: (value) {
                  onOption7Changed(value);
                }),
          ],
        ),
      ],
    );
  }
}
