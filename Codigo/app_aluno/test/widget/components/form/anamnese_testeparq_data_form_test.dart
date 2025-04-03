import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/form/anamnese_testeparq_form_test.dart';
import 'package:SmartTrainer/components/radio_button/radio_button_group.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helper.dart';

void main() {
  group('AnamneseTesteparqForm Widget Tests', () {
    testWidgets('renders AnamneseTesteparqForm correctly',
        (WidgetTester tester) async {
      var colorTheme = CustomTheme.colorFamilyLight;
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                AnamneseTesteparqForm(
                    colorTheme: colorTheme,
                    ultimaAnamnese: Anamnese(
                        email: '',
                        nomeCompleto: '',
                        data: DateTime.now(),
                        idade: 0,
                        sexo: Sexo.outro,
                        status: StatusAnamneseEnum.PEDENTE,
                        telefone: '',
                        nomeContatoEmergencia: '',
                        telefoneContatoEmergencia: '',
                        respostasParq: RespostasParq(respostas: {}),
                        respostasHistSaude: RespostasHistSaude(respostas: {}))),
              ],
            ),
          );
        }),
      ));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(CustomRadioButtonGroup, 'Sim'), findsWidgets);
      expect(find.widgetWithText(CustomRadioButtonGroup, 'Não'), findsWidgets);
    });

    testWidgets('updates state when radio button is selected',
        (WidgetTester tester) async {
      var colorTheme = CustomTheme.colorFamilyLight;
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                AnamneseTesteparqForm(
                    colorTheme: colorTheme,
                    ultimaAnamnese: Anamnese(
                        email: '',
                        nomeCompleto: '',
                        data: DateTime.now(),
                        idade: 0,
                        sexo: Sexo.outro,
                        status: StatusAnamneseEnum.PEDENTE,
                        telefone: '',
                        nomeContatoEmergencia: '',
                        telefoneContatoEmergencia: '',
                        respostasParq: RespostasParq(respostas: {}),
                        respostasHistSaude: RespostasHistSaude(respostas: {}))),
              ],
            ),
          );
        }),
      ));

      await tester.pumpAndSettle();

      final radioGroup1 = find
          .byWidgetPredicate(
            (widget) => widget is Radio<String>,
          )
          .first;

      expect(radioGroup1, findsOneWidget);
      await tester.tap(radioGroup1);
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate((widget) =>
            widget is CustomRadioButtonGroup && widget.groupValue == 'Sim'),
        findsOneWidget,
      );

      final radioGroup2 = find
          .byWidgetPredicate(
            (widget) => widget is Radio<String>,
          )
          .at(1);

      expect(radioGroup2, findsOneWidget);

      await tester.tap(radioGroup2);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((widget) =>
            widget is CustomRadioButtonGroup && widget.groupValue == 'Não'),
        findsOneWidget,
      );
    });
  });
}
