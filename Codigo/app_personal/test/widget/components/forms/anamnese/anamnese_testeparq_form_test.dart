import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/forms/anamnese/anamnese_testeparq_form.dart';
import 'package:SmartTrainer_Personal/components/radio_button/radio_button_group.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('AnamneseTesteparqForm Widget Tests', () {
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

    String? TPQselectedOption1;
    String? TPQselectedOption2;
    String? TPQselectedOption3;
    String? TPQselectedOption4;
    String? TPQselectedOption5;
    String? TPQselectedOption6;
    String? TPQselectedOption7;
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
                  anamnese: anamnese,
                  TPQselectedOption1: TPQselectedOption1,
                  TPQselectedOption2: TPQselectedOption2,
                  TPQselectedOption3: TPQselectedOption3,
                  TPQselectedOption4: TPQselectedOption4,
                  TPQselectedOption5: TPQselectedOption5,
                  TPQselectedOption6: TPQselectedOption6,
                  TPQselectedOption7: TPQselectedOption7,
                  TPQshowError1: false,
                  TPQshowError2: false,
                  TPQshowError3: false,
                  TPQshowError4: false,
                  TPQshowError5: false,
                  TPQshowError6: false,
                  TPQshowError7: false,
                  onOption1Changed: (String? value) {},
                  onOption2Changed: (String? value) {},
                  onOption3Changed: (String? value) {},
                  onOption4Changed: (String? value) {},
                  onOption5Changed: (String? value) {},
                  onOption6Changed: (String? value) {},
                  onOption7Changed: (String? value) {},
                ),
              ],
            ),
          );
        }),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Teste Par-q'), findsOneWidget);
      expect(find.widgetWithText(CustomRadioButtonGroup, 'Sim'), findsWidgets);
      expect(find.widgetWithText(CustomRadioButtonGroup, 'Não'), findsWidgets);
    });
  });
}
