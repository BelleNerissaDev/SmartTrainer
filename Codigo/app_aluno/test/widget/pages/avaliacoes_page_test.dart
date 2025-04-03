import 'package:SmartTrainer/components/card_avaliacao.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer/models/entity/pacote.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/pages/widgets/avaliacoes_page.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';

void main() {
  group('AvaliacoesPage', () {
    late AlunoProvider alunoProvider;
    late Aluno aluno;

    setUp(() {
      alunoProvider = AlunoProvider();
      aluno = Aluno(
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
      );
      alunoProvider.setAluno(aluno);
    });

    Widget createWidgetUnderTest({Future<List<AvaliacaoFisica>>? avaliacoes}) {
      return ChangeNotifierProvider<AlunoProvider>.value(
        value: alunoProvider,
        child: MaterialApp(
          home: AvaliacoesPage(
            avaliacoesOnTest: avaliacoes,
          ),
        ),
      );
    }

    testWidgets('displays loading indicator while fetching data',
        (WidgetTester tester) async {
      final avaliacoes = Future.value(<AvaliacaoFisica>[]);
      await tester.pumpWidget(createWidgetUnderTest(avaliacoes: avaliacoes));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays no evaluations message when there are no evaluations',
        (WidgetTester tester) async {
      final avaliacoes = Future.value(<AvaliacaoFisica>[]);
      await tester.pumpWidget(createWidgetUnderTest(avaliacoes: avaliacoes));
      await tester.pumpAndSettle();

      expect(find.text('nenhuma avaliação cadastrada'), findsOneWidget);
    });

    testWidgets('displays evaluations when data is available',
        (WidgetTester tester) async {
      final avaliacoesList = [
        AvaliacaoFisica(
          data: DateTime.now(),
          status: StatusAvaliacao.pendente,
          tipoAvaliacao: TipoAvaliacao.online,
        ),
        AvaliacaoFisica(
          data: DateTime.now(),
          status: StatusAvaliacao.pendente,
          tipoAvaliacao: TipoAvaliacao.online,
        ),
        AvaliacaoFisica(
          data: DateTime.now(),
          status: StatusAvaliacao.pendente,
          tipoAvaliacao: TipoAvaliacao.online,
        ),
      ];
      final avaliacoes = Future.value(avaliacoesList);

      await tester.pumpWidget(createWidgetUnderTest(avaliacoes: avaliacoes));
      await tester.pumpAndSettle();

      expect(find.byType(CardAvaliacao), findsNWidgets(avaliacoesList.length));
    });

    testWidgets('tapping on sort button changes sorting order',
        (WidgetTester tester) async {
      final avaliacoesList = [
        AvaliacaoFisica(
          data: DateTime.now(),
          status: StatusAvaliacao.pendente,
          tipoAvaliacao: TipoAvaliacao.online,
        ),
        AvaliacaoFisica(
          data: DateTime.now(),
          status: StatusAvaliacao.pendente,
          tipoAvaliacao: TipoAvaliacao.online,
        ),
        AvaliacaoFisica(
          data: DateTime.now(),
          status: StatusAvaliacao.pendente,
          tipoAvaliacao: TipoAvaliacao.online,
        ),
      ];
      final avaliacoes = Future.value(avaliacoesList);

      await tester.pumpWidget(createWidgetUnderTest(avaliacoes: avaliacoes));
      await tester.pumpAndSettle();

      expect(find.byIcon(Mdi.sortCalendarAscending), findsOneWidget);

      await tester.tap(find.byIcon(Mdi.sortCalendarAscending));
      await tester.pumpAndSettle();

      expect(find.byIcon(Mdi.sortCalendarDescending), findsOneWidget);
    });
  });
}
