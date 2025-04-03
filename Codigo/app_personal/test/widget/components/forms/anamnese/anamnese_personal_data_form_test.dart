import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/forms/anamnese/anamnese_personal_data_form.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/components/titles/headline_titles.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('Anamnese Personal Data Form Widget Tests', () {
    testWidgets('renders CardCalendarioTreinos correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          final TextEditingController _emailController =
              TextEditingController();
          final TextEditingController _telefoneController =
              TextEditingController();
          final TextEditingController _nomeController = TextEditingController();
          final TextEditingController _idadeController =
              TextEditingController();
          final TextEditingController _responsavelController =
              TextEditingController();
          final TextEditingController _nomeContatoEmergenciaController =
              TextEditingController();
          final TextEditingController _telfoneContatoEmergenciaController =
              TextEditingController();
          Sexo? selectedSexo;
          final TextEditingController sexoDropdownController =
              TextEditingController();
          Map<String, bool> PDerrors = {
            'nomeCompleto': false,
            'email': false,
            'idade': false,
            'telefone': false,
            'nomeContatoEmergencia': false,
            'telefoneContatoEmergencia': false,
            'sexo': false,
            'responsavel': false,
          };
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
                          errors: PDerrors,
                          colorTheme: colorTheme,
                          emailController: _emailController,
                          telefoneController: _telefoneController,
                          nomeController: _nomeController,
                          idadeController: _idadeController,
                          responsavelController: _responsavelController,
                          nomeContatoEmergenciaController:
                              _nomeContatoEmergenciaController,
                          telfoneContatoEmergenciaController:
                              _telfoneContatoEmergenciaController,
                          selectedSexo: selectedSexo,
                          sexoDropdownController: sexoDropdownController,
                          onSexoChanged: (Sexo? value) {},
                          validatePersonalData: () {
                            return true;
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ));
      // Verificando se todos os itens do menu estão presentes
      expect(find.textContaining('Dados Pessoais'), findsOneWidget);
      expect(find.widgetWithText(ObscuredTextField, 'Nome Completo'),
          findsOneWidget);
      expect(find.widgetWithText(ObscuredTextField, 'Idade'), findsOneWidget);
      expect(
          find.widgetWithText(ObscuredTextField, 'Nome Contato de emergência'),
          findsOneWidget);

      expect(find.byType(HeadlineTitles), findsWidgets);
    });
  });
}
