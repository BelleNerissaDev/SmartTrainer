import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/forms/anamnese/anamnese_historico_saude_form.dart';
import 'package:SmartTrainer_Personal/components/radio_button/radio_button_group.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:SmartTrainer_Personal/utils/anamnese_questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('Anamnese Hist. Saúde Form Widget Tests', () {
    testWidgets('renders CardCalendarioTreinos correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          final Anamnese anamnese = Anamnese(
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
              respostasHistSaude: RespostasHistSaude(respostas: {}));
          String? HSselectedOption1;
          String? HSselectedOption2;
          String? HSselectedOption3;
          String? HSselectedOption4;
          String? HSselectedOption5;
          String? HSselectedOption6;
          String? HSselectedOption7;
          String? HSselectedOption8;
          TextEditingController HStextController9 = TextEditingController();
          final TextEditingController HStextController10 =
              TextEditingController();
          final TextEditingController HSopcionalTextController5 =
              TextEditingController();
          final TextEditingController HSopcionalTextController6 =
              TextEditingController();

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
                        HSshowError1: false,
                        HSshowError2: false,
                        HSshowError3: false,
                        HSshowError4: false,
                        HSshowError5: false,
                        HSshowError5opt: false,
                        HSshowError6: false,
                        HSshowError6opt: false,
                        HSshowError7: false,
                        HSshowError8: false,
                        HSshowError9: false,
                        HSshowError10: false,
                        HStextController9: HStextController9,
                        HStextController10: HStextController10,
                        HSopcionalTextController5: HSopcionalTextController5,
                        HSopcionalTextController6: HSopcionalTextController6,
                        onOption1Changed: (String? value) {},
                        onOption2Changed: (String? value) {},
                        onOption3Changed: (String? value) {},
                        onOption4Changed: (String? value) {},
                        onOption5Changed: (String? value) {},
                        onOption6Changed: (String? value) {},
                        onOption7Changed: (String? value) {},
                        onOption8Changed: (String? value) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ));
      expect(find.textContaining('Histórico de saúde'), findsOneWidget);
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
    });
  });
}
