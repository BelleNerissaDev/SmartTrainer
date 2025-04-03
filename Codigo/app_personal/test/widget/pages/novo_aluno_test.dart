import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_aluno_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/titles/headline_titles.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/components/buttons/primary_button.dart';
import 'package:SmartTrainer_Personal/components/inputs/dropdown_input.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('NovoPacotePage Widget Tests', () {
    testWidgets('renders NovoPacotePage correctly',
        (WidgetTester tester) async {
      // Inicializa a NovoPacotePage dentro do widget de teste
      await tester.pumpWidget(createWidgetUnderTest(
        child: const NovoAlunoPage(),
      ));

      // Verifica se o AppBar personalizado está sendo exibido
      expect(find.byType(CustomAppBar), findsOneWidget);

      // Verifica se o HeaderContainer está presente com o título correto
      expect(find.byType(HeaderContainer), findsOneWidget);
      expect(find.text('Novo Aluno'), findsOneWidget);

      // Verifica a presença do CardContainer
      expect(find.byType(CardContainer), findsOneWidget);

      // Verifica se o título do formulário está correto
      expect(find.byType(HeadlineTitles), findsOneWidget);
      expect(find.text('Informações do aluno'), findsOneWidget);
      expect(find.text('Preencha com os dados do aluno'), findsOneWidget);

      // Verifica se os campos de texto estão presentes
      expect(find.byType(ObscuredTextField), findsNWidgets(4));
      expect(find.widgetWithText(ObscuredTextField, 'Nome'), findsOneWidget);
      expect(find.widgetWithText(ObscuredTextField, 'E-mail'), findsOneWidget);
      expect(find.widgetWithText(ObscuredTextField, 'Data de Nascimento'),
          findsOneWidget);
      expect(find.widgetWithText(DropdownInput<Sexo>, 'Sexo'), findsOneWidget);

      await tester.pumpAndSettle();
      var finder = find.byType(CardContainer);
      var moveBy = const Offset(0, -300);
      var dragDuration = const Duration(seconds: 1);

      await tester.timedDrag(finder, moveBy, dragDuration);

      expect(
          find.widgetWithText(ObscuredTextField, 'Telefone'), findsOneWidget);
      expect(find.widgetWithText(DropdownInput<Pacote>, 'Pacote de treino'),
          findsOneWidget);

      // Verifica se o botão de cadastro está presente
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Cadastrar'), findsOneWidget);
    });

    testWidgets('allows text input and button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: const NovoAlunoPage(),
      ));

      // Insere texto nos campos de texto
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'E-mail'), 'bla@bla.com');
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'Nome'), 'Tester');
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'Data de Nascimento'),
          '01012000');

      // Verifica se o texto foi inserido corretamente
      expect(find.text('bla@bla.com'), findsOneWidget);
      expect(find.text('Tester'), findsOneWidget);
      expect(find.text('01/01/2000'), findsOneWidget);

      await tester.tap(find.byType(DropdownInput<Sexo>));
      await tester.pumpAndSettle();

      // Verificando se os itens aparecem na lista suspensa
      expect(find.text('Feminino'), findsOneWidget);
      expect(find.text('Masculino'), findsOneWidget);
      expect(find.text('Outro'), findsOneWidget);

      await tester.tap(find.textContaining('Masculino'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(DropdownInput<Sexo>, 'Masculino'),
          findsOneWidget);

      await tester.enterText(find.widgetWithText(ObscuredTextField, 'Telefone'),
          '11999999999');
      await tester.pumpAndSettle();
      expect(find.text('(11) 9 9999-9999'), findsOneWidget);

      // Rolagem para baixo para garantir que o botão de cadastro seja visível
      await tester.pumpAndSettle();

      var finder = find.byType(CardContainer);
      var moveBy = const Offset(0, -300);
      var dragDuration = const Duration(seconds: 1);

      await tester.timedDrag(finder, moveBy, dragDuration);

      // Simula o clique no botão de cadastro
      await tester.tap(find.text('Cadastrar'));
    });
  });
}
