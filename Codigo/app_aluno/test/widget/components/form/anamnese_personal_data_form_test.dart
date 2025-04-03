import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/form/anamnese_personal_data_form_test.dart';
import 'package:SmartTrainer/components/input/dropdown_input.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helper.dart';

void main() {
  group('Anamnese Personal Data Form Widget Tests', () {
    testWidgets('renders AnamnesePersonalDataForm correctly',
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
                      AnamnesePersonalDataForm(
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
                            respostasHistSaude:
                                RespostasHistSaude(respostas: {})),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ));

      // Verifica se todos os campos do formulário estão presentes
      expect(find.textContaining('Nome Completo'), findsOneWidget);
      expect(find.textContaining('E-mail'), findsOneWidget);
      expect(find.textContaining('Idade'), findsOneWidget);
      expect(find.textContaining('Sexo'), findsOneWidget);
      expect(
          find.widgetWithText(ObscuredTextField, 'Telefone'), findsOneWidget);
      expect(find.textContaining('Nome Contato de emergência'), findsOneWidget);
      expect(find.textContaining('Telefone Contato de emergência'),
          findsOneWidget);
    });

    testWidgets('shows Responsável field when age is less than 18',
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
                      AnamnesePersonalDataForm(
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
                            respostasHistSaude:
                                RespostasHistSaude(respostas: {})),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ));

      // Entra com uma idade menor que 18
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'Idade'), '15');
      await tester.pump();

      // Simula o clique no DropdownInput de Sexo
      await tester.tap(find.widgetWithText(DropdownInput<Sexo>, 'Sexo'));
      await tester.pumpAndSettle();

      // Seleciona um item do Dropdown (simulando a escolha do sexo)
      await tester.tap(find.text('Masculino').last);
      await tester.pumpAndSettle();

      // Espera por 3 segundos
      await tester.pump(const Duration(seconds: 3));

      // Verifica se o valor foi atualizado corretamente
      expect(find.text('Masculino'), findsOneWidget);

      // Verifica se o campo Responsável aparece
      expect(find.widgetWithText(ObscuredTextField, 'Responsável'),
          findsOneWidget);
    });

    testWidgets('does not show Responsável field when age is 18 or older',
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
                      AnamnesePersonalDataForm(
                        colorTheme: colorTheme,
                        ultimaAnamnese: Anamnese(
                            email: '',
                            nomeCompleto: '',
                            data: DateTime.now(),
                            idade: 18,
                            sexo: Sexo.outro,
                            status: StatusAnamneseEnum.PEDENTE,
                            telefone: '',
                            nomeContatoEmergencia: '',
                            telefoneContatoEmergencia: '',
                            respostasParq: RespostasParq(respostas: {}),
                            respostasHistSaude:
                                RespostasHistSaude(respostas: {})),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ));

      await tester.pumpAndSettle();

      // Verifica se o campo Responsável não aparece
      expect(find.textContaining('Responsável'), findsNothing);
    });
  });
  testWidgets('block interactions from anamnese status "realizada"',
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
                    AnamnesePersonalDataForm(
                      colorTheme: colorTheme,
                      ultimaAnamnese: Anamnese(
                          email: '',
                          nomeCompleto: '',
                          data: DateTime.now(),
                          idade: 0,
                          sexo: Sexo.outro,
                          status: StatusAnamneseEnum.REALIZADA,
                          telefone: '',
                          nomeContatoEmergencia: '',
                          telefoneContatoEmergencia: '',
                          respostasParq: RespostasParq(respostas: {}),
                          respostasHistSaude:
                              RespostasHistSaude(respostas: {})),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    ));

    await tester.enterText(
        find.widgetWithText(ObscuredTextField, 'Idade'), '15');
    await tester.pump();

    expect(find.widgetWithText(ObscuredTextField, '0'), findsOneWidget);
  });
}
