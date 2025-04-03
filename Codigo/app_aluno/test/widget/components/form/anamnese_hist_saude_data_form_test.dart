import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/form/anamnese_historico_saude_form_test.dart';
import 'package:SmartTrainer/components/radio_button/radio_button_group.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';
import 'package:SmartTrainer/utils/anamnese_questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helper.dart';

void main() {
  group('Anamnese Hist. Saúde Form Widget Tests', () {
    testWidgets('renders CardCalendarioTreinos correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                  margin: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      //Form
                      AnamneseHistoricoSaudeForm(
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
                            respostasParq: RespostasParq(respostas: {
                              'testeParqQ1': 'Não',
                              'testeParqQ2': 'Não',
                              'testeParqQ3': 'Não',
                              'testeParqQ4': 'Não',
                              'testeParqQ5': 'Não',
                              'testeParqQ6': 'Não',
                              'testeParqQ7': 'Não',
                            }),
                            respostasHistSaude: RespostasHistSaude(respostas: {
                              'testeHistSaudeQ1': 'Fumo',
                              'testeHistSaudeQ2': 'Não sei',
                              'testeHistSaudeQ3': 'Não',
                              'testeHistSaudeQ4': 'Não',
                              'testeHistSaudeQ5': 'Não',
                              'testeHistSaudeQ6': 'Não',
                              'testeHistSaudeQ7': 'Não',
                              'testeHistSaudeQ8': 'Menos que 1L',
                              'testeHistSaudeQ9': 'Nenhum',
                              'testeHistSaudeQ10': 'Nada',
                            })),
                        colorTheme: colorTheme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ));
      expect(
          find.widgetWithText(CustomRadioButtonGroup, 'Fumo'), findsOneWidget);
      expect(find.widgetWithText(CustomRadioButtonGroup, 'Já fui fumante'),
          findsOneWidget);
      expect(find.widgetWithText(CustomRadioButtonGroup, 'Nunca fumei'),
          findsOneWidget);
      expect(find.widgetWithText(CustomRadioButtonGroup, 'Pressão Baixa'),
          findsOneWidget);
      expect(find.widgetWithText(CustomRadioButtonGroup, 'Entre 2L e 3L'),
          findsOneWidget);
      expect(find.widgetWithText(CustomRadioButtonGroup, 'Menos de 1L'),
          findsOneWidget);
      expect(find.widgetWithText(CustomRadioButtonGroup, 'Sim'), findsWidgets);
      expect(find.widgetWithText(CustomRadioButtonGroup, 'Não'), findsWidgets);

      expect(
          find.textContaining(
              TesteHistSaudeQuestions.testeHistSaudeQ10.question),
          findsOneWidget);

      expect(find.byType(TextField), findsWidgets);

      final radioGroup2 = find
          .byWidgetPredicate(
            (widget) => widget is Radio<String>,
          )
          .at(0);

      expect(radioGroup2, findsOneWidget);

      await tester.tap(radioGroup2);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((widget) =>
            widget is CustomRadioButtonGroup && widget.groupValue == 'Fumo'),
        findsOneWidget,
      );
    });
  });
}
