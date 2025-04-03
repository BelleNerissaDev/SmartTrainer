import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/header/card_nome_aluno.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/header/header.dart';
import 'package:provider/provider.dart';

void main() {
  late AlunoProvider alunoProvider;

  setUp(() {
    alunoProvider = AlunoProvider();
    alunoProvider.setAluno(Aluno(
      nome: 'Nome do Aluno',
      telefone: 'telefone',
      email: 'email',
      sexo: 'sexo',
      status: StatusAlunoEnum.ATIVO,
      peso: 75.9,
      altura: 180,
      uid: 'uid',
      primeiroAcesso: false,
      dataNascimento: DateTime(1990, 1, 1),
      pacote: Pacote(
        nome: 'pacote 1',
        valorMensal: '200',
        numeroAcessos: '20',
      ),
    ));
  });
  testWidgets('Header widget test', (WidgetTester tester) async {
    final theme = CustomTheme.colorFamilyLight;
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => alunoProvider,
        child: MaterialApp(
          home: Scaffold(
            appBar: Header(
              colorTheme: theme,
            ),
          ),
        ),
      ),
    );

    // Verify that the AppBar is rendered with the correct properties
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(CardNomeAluno), findsOneWidget);
  });
}
