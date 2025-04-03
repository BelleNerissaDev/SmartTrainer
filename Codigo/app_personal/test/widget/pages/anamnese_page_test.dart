import 'package:SmartTrainer_Personal/components/cards/history_anamneses_card.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:SmartTrainer_Personal/pages/widgets/anamneses_page.dart';
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
      final themeProvider = ThemeProvider();
      final aluno = Aluno(
        pacote:
            Pacote(nome: 'teste', valorMensal: '200.00', numeroAcessos: '20'),
        dataNascimento: DateTime(1990, 5, 30),
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
      );
      final anamnese = Anamnese(
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

      aluno.addAnamnese(anamnese);

      // Constrói o widget AnamnesePage com os providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: MaterialApp(
            home: AnamnesesPage(
              alunoOnTest: Future.value([aluno]),
            ),
          ),
        ),
      );

      // Aguarda a renderização completa
      await tester.pumpAndSettle();

      // Verifica se a página foi corretamente renderizada
      expect(find.byType(AnamnesesPage), findsOneWidget);
      expect(find.byType(HistoryAnamensesCard), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Pendente'), findsOneWidget);
    });

    testWidgets('renders AnamnesePage correctly', (WidgetTester tester) async {
      final themeProvider = ThemeProvider();
      final aluno = Aluno(
        pacote:
            Pacote(nome: 'teste', valorMensal: '200.00', numeroAcessos: '20'),
        dataNascimento: DateTime(1990, 5, 30),
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
      );

      // Constrói o widget AnamnesePage com os providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => themeProvider,
            ),
          ],
          child: MaterialApp(
            home: AnamnesesPage(
              alunoOnTest: Future.value([aluno]),
            ),
          ),
        ),
      );

      // Aguarda a renderização completa
      await tester.pumpAndSettle();

      // Verifica se a página foi corretamente renderizada
      expect(find.byType(AnamnesesPage), findsOneWidget);
      expect(find.byType(HistoryAnamensesCard), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Não solicitado'), findsOneWidget);

      // Verifica se o botão "Solicitar" está presente
      expect(find.widgetWithText(ElevatedButton, 'Solicitar'), findsOneWidget);
    });
  });
}
