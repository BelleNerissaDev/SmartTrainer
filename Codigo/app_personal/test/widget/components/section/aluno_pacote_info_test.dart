import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/sections/info_aluno_pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('AlunoPacoteInfoComEdicao Widget Tests', () {
    testWidgets('renders AlunoPacoteInfoComEdicao correctly',
        (WidgetTester tester) async {
      // Variável de controle para verificar botão de edição foi pressionado
      bool editTapped = false;
      var colorTheme = CustomTheme.colorFamilyLight;

      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          return InfoAlunoPacoteComEdicao(
            colorTheme: colorTheme,
            onEditTap: () {
              editTapped =
                  true; // Altera a variável quando o botão é pressionado
            },
            aluno: Aluno(
              id: '123',
              imagem: null,
              primeiroAcesso: true,
              nome: 'John Doe',
              telefone: '123456789',
              email: 'test@example',
              sexo: 'Male',
              status: StatusAlunoEnum.ATIVO,
              peso: 70.5,
              altura: 180,
              uid: '12345',
              dataNascimento: DateTime(1990, 1, 1),
              pacote: Pacote(
                nome: 'pacote 1',
                valorMensal: '200,00',
                numeroAcessos: '30',
              ),
            ),
          );
        }),
      ));

      expect(find.text('Pacote atual'), findsOneWidget);

      expect(find.text('Trocar Pacote'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Verifica se a função de callback foi chamada
      expect(editTapped, isTrue);

      expect(find.textContaining('Valor (mês):'), findsOneWidget);
      expect(find.textContaining('R\$ 200,00'), findsOneWidget);
      expect(find.textContaining('Número de acessos (mês):'), findsOneWidget);
      expect(find.textContaining('30'), findsOneWidget);
    });
  });
}
