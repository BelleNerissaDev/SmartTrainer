import 'dart:io';

import 'package:SmartTrainer/components/radio_button/icon_radio_button_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/components/exercicios/card_exercicio.dart';
import 'package:SmartTrainer/models/entity/exercicio.dart';
import 'package:SmartTrainer/models/entity/realizacao_exercicio.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context);
  }
}

void main() {
  late Exercicio exercicio;
  late RealizacaoExercicio realizacaoExercicio;

  group('CardExercicio', () {
    setUp(() {
      HttpOverrides.global = _MyHttpOverrides();
      exercicio = Exercicio(
        nome: 'Test Exercise',
        metodologia: MetodologiaExercicio.TRADICIONAL,
        series: 3,
        repeticoes: 10,
        carga: 20.0,
        intervalo: '00:02',
        descricao: 'Test Description',
        videoUrl: null,
        imagem: 'https://placehold.co/600x400/png',
        status: StatusExercicio.PENDENTE,
      );

      realizacaoExercicio = RealizacaoExercicio(
        novaCarga: 25.0,
        nivelEsforco: NivelEsforco.MEDIO,
        idExercicio: '1',
      );
    });

    Widget createWidgetUnderTest() {
      return ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MaterialApp(
          home: Scaffold(
            body: CardExercicio(
              exercicio: exercicio,
              realizacaoExercicio: realizacaoExercicio,
            ),
          ),
        ),
      );
    }

    testWidgets('CardExercicio displays exercise details',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pumpAndSettle();

      expect(find.text('Test Exercise'), findsOneWidget);
      expect(find.text('Tradicional 3 x 10'), findsOneWidget);
      expect(find.text('Test Description'), findsNothing);
    });

    testWidgets('CardExercicio expands and shows description and video',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test Description'), findsNothing);
      expect(find.byType(YoutubePlayer), findsNothing);

      await tester.tap(find.byIcon(Mdi.chevronRight));
      await tester.pumpAndSettle();

      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('CardExercicio updates carga on text field change',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), '30');
      await tester.pump();

      expect(realizacaoExercicio.novaCarga, 30.0);
    });

    testWidgets('CardExercicio starts rest timer on series tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('10 X 20.0 Kg').first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Mdi.timerOutline), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byIcon(Mdi.checkboxMarkedCircleAutoOutline), findsOneWidget);
    });

    testWidgets(
        'CardExercicio shows effort level icons when exercise is completed',
        (WidgetTester tester) async {
      exercicio.status = StatusExercicio.CONCLUIDO;
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(IconRadioGroup), findsOneWidget);
    });
  });
}
