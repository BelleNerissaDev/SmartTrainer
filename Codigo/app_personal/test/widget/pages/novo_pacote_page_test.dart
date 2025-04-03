import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/titles/headline_titles.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_pacote_page.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('NovoPacotePage Widget Tests', () {
    testWidgets('renders NovoPacotePage correctly',
        (WidgetTester tester) async {
      // Inicializa a NovoPacotePage dentro do widget de teste
      await tester.pumpWidget(createWidgetUnderTest(
        child: const NovoPacotePage(),
      ));

      await tester.pumpAndSettle();

      // Verifica se o AppBar personalizado está sendo exibido
      expect(find.byType(CustomAppBar), findsOneWidget);

      // Verifica se o HeaderContainer está presente com o título correto
      expect(find.byType(HeaderContainer), findsOneWidget);
      expect(find.text('Novo Pacote'), findsOneWidget);

      // Verifica a presença do CardContainer
      expect(find.byType(CardContainer), findsOneWidget);

      // Verifica se o título do formulário está correto
      expect(find.byType(HeadlineTitles), findsOneWidget);
      expect(find.text('Informações do pacote'), findsOneWidget);
      expect(
          find.text('Preencha com as informações do pacote'), findsOneWidget);

      // Verifica se os campos de texto estão presentes
      expect(find.byType(ObscuredTextField), findsNWidgets(3));
      expect(find.widgetWithText(ObscuredTextField, 'Nome'), findsOneWidget);
      expect(find.widgetWithText(ObscuredTextField, 'Valor mensal (R\$)'),
          findsOneWidget);
      expect(find.widgetWithText(ObscuredTextField, 'Número de acessos (mês)'),
          findsOneWidget);

      // Verifica se o botão de cadastro está presente
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Cadastrar'), findsOneWidget);
    });

    testWidgets('allows text input and button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: const NovoPacotePage(),
      ));

      await tester.pumpAndSettle();

      // Insere texto nos campos de texto
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'Nome'), 'Pacote Teste');
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'Valor mensal (R\$)'),
          '150.00');
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'Número de acessos (mês)'),
          '20');

      // Verifica se o texto foi inserido corretamente
      expect(find.text('Pacote Teste'), findsOneWidget);
      expect(find.text('150.00'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);

      // Simula o clique no botão de cadastro
      await tester.tap(find.text('Cadastrar'));
      await tester.pumpAndSettle();
    });
  });
}
