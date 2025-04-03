import 'package:SmartTrainer_Personal/components/container/card_container.dart';
import 'package:SmartTrainer_Personal/components/header/header_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:SmartTrainer_Personal/pages/widgets/novo_exercicio_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/components/header/app_bar.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/models/entity/grupo_muscular.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late List<GrupoMuscular> mockGrupoMusculares;
  setUpAll(() {
    // Registrar o fallback value para ImageSource
    registerFallbackValue(ImageSource.gallery);
  });

  setUp(() {
    mockGrupoMusculares = [
      GrupoMuscular(id: 'peitoral', nome: 'Peitoral'),
      GrupoMuscular(id: 'pernas', nome: 'Pernas'),
      GrupoMuscular(id: 'costas', nome: 'Costas')
    ];
  });

  group('NovoExercicioPage Widget Tests', () {
    testWidgets('renders NovoExercicioPage correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: NovoExercicioPage(
          grupoMuscularOnTest: Future.value(mockGrupoMusculares),
        ),
      ));

      await tester.pumpAndSettle();

      // Verify basic structure
      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.byType(HeaderContainer), findsOneWidget);
      expect(find.byType(CardContainer), findsOneWidget);
      expect(find.text('Novo Exercício'), findsOneWidget);

      // Verify form fields
      expect(find.widgetWithText(ObscuredTextField, 'Nome'), findsOneWidget);
      expect(find.text('Metodologia do exercício (Padrão)'), findsOneWidget);
      expect(find.text('Carga (Padrão)'), findsOneWidget);
      expect(find.text('Tipo de Carga'), findsOneWidget);
      expect(find.text('Repetições (Padrão)'), findsOneWidget);
      expect(find.text('Séries (Padrão)'), findsOneWidget);
      expect(find.text('Tempo de Descanso (Padrão)'), findsOneWidget);
      expect(find.text('Grupos musculares'), findsOneWidget);

      await tester.pumpAndSettle();
      var finder = find.text('Grupos musculares');
      var moveBy = const Offset(0, -400);
      var dragDuration = const Duration(seconds: 1);

      await tester.timedDrag(finder, moveBy, dragDuration, warnIfMissed: false);

      expect(find.text('Descrição'), findsOneWidget);
      expect(find.text('URL do Vídeo (YouTube)'), findsOneWidget);
      expect(find.text('Imagem'), findsOneWidget);

      // Verify IconButton for adding a photo
      expect(find.byIcon(Icons.add_a_photo), findsOneWidget);
      // Verify FloatingActionButton
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('validates empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: NovoExercicioPage(
          grupoMuscularOnTest: Future.value(mockGrupoMusculares),
        ),
      ));

      await tester.pumpAndSettle();

      // Tap the submit button without filling any fields
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Nome vazio'), findsOneWidget);
    });

    testWidgets('allows input in all text fields', (WidgetTester tester) async {
      // late ImageSource capturedSource;

      await tester.pumpWidget(createWidgetUnderTest(
        child: NovoExercicioPage(
          grupoMuscularOnTest: Future.value(mockGrupoMusculares),
          imageOnTest: XFile('test/assets/avancoEx.jpeg'),
        ),
      ));

      await tester.pumpAndSettle();

      // Fill in the text fields
      await tester.enterText(
          find.widgetWithText(ObscuredTextField, 'Nome'), 'Supino Reto');

      await tester.pumpAndSettle();

      final Finder radioFinder = find.descendant(
        of: find.ancestor(
          of: find.text('Tradicional'),
          matching: find.byType(Row),
        ),
        matching: find.byType(Radio<String>),
      );
      await tester.longPress(radioFinder);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const ValueKey('NovoExInputCarga')), '12.0');
      await tester.enterText(
          find.byKey(const ValueKey('NovoExInputTipoCarga')), 'KettBell');
      await tester.enterText(
          find.byKey(const ValueKey('NovoExInputRepeticoes')), '12');
      await tester.enterText(
          find.byKey(const ValueKey('NovoExInputSeries')), '3');
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const ValueKey('NovoExInputIntervalo')), '00:30');
      await tester.pumpAndSettle();

      await tester.pumpAndSettle();
      var finder = find.byKey(const ValueKey('NovoExInputIntervalo'));
      var moveBy = const Offset(0, -300);
      var dragDuration = const Duration(seconds: 1);
      await tester.timedDrag(finder, moveBy, dragDuration, warnIfMissed: false);

      await tester.pumpAndSettle();
      await tester.longPress(find.text('Peitoral'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('NovoExInputDescricao')),
          'Descricao teste');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('NovoExInputVideo')),
          'https://www.youtube.com/watch?v=dQw4w9WgXcQ');

      await tester.pumpAndSettle();

      await tester.pumpAndSettle();
      finder = find.byKey(const ValueKey('NovoExInputVideo'));
      moveBy = const Offset(0, -300);
      dragDuration = const Duration(seconds: 1);
      await tester.timedDrag(finder, moveBy, dragDuration, warnIfMissed: false);

      await tester.pumpAndSettle();

      // // Verificar se todos os campos foram preenchidos corretamente
      expect(find.text('Supino Reto'), findsOneWidget);
      expect(find.text('12.0'), findsOneWidget);
      expect(find.text('KettBell'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('00:30'), findsOneWidget);
      expect(find.text('Descricao teste'), findsOneWidget);
      expect(find.text('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
          findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('NovoExButtonSubmit')));
      await tester.pumpAndSettle();
    });
  });
}
