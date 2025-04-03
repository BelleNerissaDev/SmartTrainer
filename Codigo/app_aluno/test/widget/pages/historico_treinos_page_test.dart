import 'package:SmartTrainer/components/feedback/card_analise_grupo_muscular.dart';
import 'package:SmartTrainer/components/treinos/card_historico_treino.dart';
import 'package:SmartTrainer/models/entity/nivel_esforco.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';
import 'package:SmartTrainer/models/entity/treino.dart';
import 'package:SmartTrainer/pages/widgets/historico_treinos_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/realizacao_treino.dart';
import 'package:SmartTrainer/models/entity/feedback.dart' as feedback;
import 'package:SmartTrainer/connections/repository/realizacao_treino_repository.dart';
import 'package:mockito/mockito.dart';

import 'historico_treinos_page_test.mocks.dart';

@GenerateMocks([
  RealizacaoTreinoRepository,
  Aluno,
])
void main() {
  group('HistóricoTreinosPage', () {
    late AlunoProvider alunoProvider;
    late ThemeProvider themeProvider;
    late MockRealizacaoTreinoRepository mockRealizacaoTreinoRepository;
    late MockAluno mockAluno;

    setUp(() {
      alunoProvider = AlunoProvider();
      themeProvider = ThemeProvider();
      mockRealizacaoTreinoRepository = MockRealizacaoTreinoRepository();
      mockAluno = MockAluno();
      alunoProvider.setAluno(mockAluno);

      when(mockAluno.nome).thenReturn('Aluno');
      when(mockAluno.imagem).thenReturn(null);
      when(mockAluno.id).thenReturn('1');
      when(mockAluno.pacote).thenReturn(
          Pacote(nome: 'Pacote', valorMensal: '20', numeroAcessos: '20'));
    });

    testWidgets('HistoricoTreinosPage displays list of treinos',
        (WidgetTester tester) async {
      final realizacoes = [
        RealizacaoTreino(
          treino: Treino(nome: 'Treino 1'),
          data: DateTime(2024, 10, 10),
          tempo: 600,
          feedback: feedback.Feedback(
            nivelEsforco: NivelEsforco.ALTO,
            observacao: 'Teste',
          ),
        ),
        RealizacaoTreino(
          treino: Treino(nome: 'Treino 2'),
          data: DateTime(2024, 10, 12),
          tempo: 630,
          feedback: feedback.Feedback(
            nivelEsforco: NivelEsforco.ALTO,
            observacao: 'Teste 2',
          ),
        ),
      ];

      when(mockRealizacaoTreinoRepository.readAllByAlunoByMes(any, any))
          .thenAnswer((_) async => realizacoes);

      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<AlunoProvider>.value(value: alunoProvider),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ],
        child: MaterialApp(
          home: HistoricoTreinosPage(
            realizacoesOnTest: realizacoes,
          ),
        ),
      ));
      await tester.pump();

      expect(find.text('Treino 1'), findsOneWidget);
      expect(find.text('Teste'), findsOneWidget);
      expect(find.text('10:00 - 10-10-2024'), findsOneWidget);

      expect(find.text('Treino 2'), findsOneWidget);
      expect(find.text('Teste 2'), findsOneWidget);
      expect(find.text('10:30 - 12-10-2024'), findsOneWidget);

      expect(find.text('Esforço: '), findsNWidgets(2));
      expect(find.text('Observação: '), findsNWidgets(2));

      expect(find.byType(CardHistoricoTreino), findsNWidgets(2));
      expect(find.byType(CardAnaliseGrupoMuscular), findsOneWidget);
    });
  });
}
