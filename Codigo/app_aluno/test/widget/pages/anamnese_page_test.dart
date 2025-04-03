import 'package:SmartTrainer/components/button/primary_button.dart';
import 'package:SmartTrainer/components/form/anamnese_personal_data_form_test.dart';
import 'package:SmartTrainer/components/input/dropdown_input.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:SmartTrainer/components/text/headline_title.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';

import 'package:SmartTrainer/pages/widgets/anamnese_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('AnamnesePage Widget Tests', () {
    testWidgets('renders AnamnesePage correctly', (WidgetTester tester) async {
      final aluno = Aluno(
        nome: 'John Doe',
        email: 'john.doe@example.com',
        telefone: '123456789',
        peso: 70,
        altura: 175,
        imagem: null,
        sexo: 'Masculino',
        primeiroAcesso: false,
        status: StatusAlunoEnum.ATIVO,
        uid: '',
        dataNascimento: DateTime(1990, 1, 1),
        pacote: Pacote(
          nome: 'pacote 1',
          valorMensal: '200',
          numeroAcessos: '20',
        ),
      );

      // Inicializa os providers
      final alunoProvider = AlunoProvider();
      alunoProvider.setAluno(aluno);
      final themeProvider = ThemeProvider();

      // Constrói o widget AnamnesePage com os providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AlunoProvider>(
              create: (_) => alunoProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: MaterialApp(
            home: AnamnesePage(
                anamensesOnTest: Anamnese(
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
          ),
        ),
      );

      // Aguarda a renderização completa
      await tester.pumpAndSettle();

      // Verifica se a página foi corretamente renderizada
      expect(find.byType(AnamnesePage), findsOneWidget);

      // Verifica se o primeiro formulário foi carregado
      expect(find.byType(AnamnesePersonalDataForm), findsOneWidget);

      expect(find.widgetWithText(ObscuredTextField, 'Nome Completo'),
          findsOneWidget);
      expect(find.widgetWithText(ObscuredTextField, 'Idade'), findsOneWidget);
      expect(find.widgetWithText(ObscuredTextField, 'E-mail'), findsOneWidget);
      await tester.tap(find.byType(DropdownInput<Sexo>));
      await tester.pumpAndSettle();

      expect(find.text('Feminino'), findsOneWidget);
      expect(find.text('Masculino'), findsOneWidget);

      await tester.tap(find.textContaining('Masculino'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(DropdownInput<Sexo>, 'Masculino'),
          findsOneWidget);
      expect(
          find.widgetWithText(ObscuredTextField, 'Nome Contato de emergência'),
          findsOneWidget);
      expect(
          find.widgetWithText(
              ObscuredTextField, 'Telefone Contato de emergência'),
          findsOneWidget);

      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'Nome Completo'), 'Teste');
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'E-mail'), 'teste@teste.com');
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'Idade'), '23');
      await tester.enterText(find.widgetWithText(ObscuredTextField, 'Telefone'),
          '(31) 99999-9999');
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'Nome Contato de emergência'),
          'Emergencia trste');

      await tester.enterText(
          find.widgetWithText(
              ObscuredTextField, 'Telefone Contato de emergência'),
          '(31) 99999-9999');

      // Verifica se o botão de cadastro está presente
      expect(find.byType(PrimaryButton), findsOneWidget);
      
      await tester.pumpAndSettle();
      var finder = find.byType(HeadlineTitles);
      var moveBy = const Offset(0, -300);
      var dragDuration = const Duration(seconds: 1);

      await tester.timedDrag(finder, moveBy, dragDuration, warnIfMissed: false);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();
    });
  });
}
