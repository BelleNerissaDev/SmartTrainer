import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/cards/feedback_home_carrousel.dart';
import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/feedback.dart';
import 'package:SmartTrainer_Personal/models/entity/nivel_esforco.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:SmartTrainer_Personal/models/entity/realizacao_treino.dart';
import 'package:SmartTrainer_Personal/models/entity/treino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('FeedbackCarousel Widgets Tests', () {
    testWidgets('renders FeedbackCarousel with correct feedback details',
        (WidgetTester tester) async {
      // TODO: Substituir por mockito
      final List<Map<String, dynamic>> feedbacks = [
        {
          'userName': 'John Doe',
          'userImage': null,
          'trainingPlan': 'Treino C',
          'timeAgo': 'à 2 dias',
          'comment': 'Muito bom treino, rendi bem até a metade dele!',
          'selectedIconIndex': 3,
        },
        {
          'userName': 'Jane Smith',
          'userImage': null,
          'trainingPlan': 'Treino B',
          'timeAgo': 'à 3 dias',
          'comment': 'Gostei muito, mas o final foi bem puxado.',
          'selectedIconIndex': 2,
        },
      ];

      final feedback = feedbacks[0];

      final String userName = feedback['userName'];
      final String? userImage = feedback['userImage'];
      final String trainingPlan = feedback['trainingPlan'];
      final String timeAgo = feedback['timeAgo'];
      final String comment = feedback['comment'];
      final int selectedIconIndex = feedback['selectedIconIndex'];

      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(
          builder: (context) {
            var colorTheme = CustomTheme.colorFamilyLight;

            return FeedbackCard(
              colorTheme: colorTheme,
              userName: userName,
              userImage: userImage,
              trainingPlan: trainingPlan,
              timeAgo: timeAgo,
              comment: comment,
              selectedIconIndex: selectedIconIndex,
            );
          },
        ),
      ));

      expect(find.text(userName), findsOneWidget);
      expect(find.text(trainingPlan), findsOneWidget);
      expect(find.text(timeAgo), findsOneWidget);
      expect(find.text(comment), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);

      final icons = find.byType(Icon);
      expect(icons, findsNWidgets(5));

      final selectedIcon = tester.widget<Icon>(
        icons.at(selectedIconIndex),
      );
      expect(
          selectedIcon.color,
          equals(Provider.of<ThemeProvider>(
            tester.element(find.byType(FeedbackCard)),
            listen: false,
          ).colorTheme.indigo_primary_800));
    });

    testWidgets('navigates between carousel items',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(
          builder: (context) {
            var colorTheme = CustomTheme.colorFamilyLight;

            return FeedbackCarousel(
              colorTheme: colorTheme,
              realizacoes: [
                RealizacaoTreino(
                  data: DateTime.now(),
                  treino: Treino(nome: 'treino A'),
                  tempo: 500,
                  feedback: FeedbackTreino(
                    observacao: 'observacao',
                    nivelEsforco: NivelEsforco.MEDIO,
                  ),
                ),
              ],
              aluno: Aluno(
                nome: 'nome',
                telefone: 'telefone',
                email: 'email',
                sexo: 'sexo',
                status: StatusAlunoEnum.ATIVO,
                uid: 'uid',
                primeiroAcesso: false,
                dataNascimento: DateTime.now(),
                pacote: Pacote(
                  nome: 'pacote',
                  numeroAcessos: '10',
                  valorMensal: 'R\$ 100,00',
                ),
              ),
            );
          },
        ),
      ));

      expect(find.text('nome'), findsOneWidget);

      await tester.drag(find.byType(CarouselSlider), const Offset(-300.0, 0.0));
      await tester.pumpAndSettle();

      expect(find.text('nome'), findsOneWidget);
    });
  });
}
