// ignore_for_file: lines_longer_than_80_chars

import 'package:SmartTrainer/utils/anamnese_questions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TesteParqQuestions', () {
    test('should return correct question and options for each enum value', () {
      expect(TesteParqQuestions.testeParqQ1.question,
          'Seu médico já disse que você possui um problema cardíaco e/ou recomendou atividades físicas apenas sob supervisão médica?');
      expect(TesteParqQuestions.testeParqQ1.options, ['Sim', 'Não']);

      expect(TesteParqQuestions.testeParqQ2.question,
          'Você tem dor no peito provocada por atividades físicas?');
      expect(TesteParqQuestions.testeParqQ2.options, ['Sim', 'Não']);

      expect(TesteParqQuestions.testeParqQ3.question,
          'Você sentiu dor no peito no último mês?');
      expect(TesteParqQuestions.testeParqQ3.options, ['Sim', 'Não']);

      expect(TesteParqQuestions.testeParqQ4.question,
          'Você já perdeu a consciência em alguma ocasião ou sofreu alguma queda em virtude de tontura?');
      expect(TesteParqQuestions.testeParqQ4.options, ['Sim', 'Não']);

      expect(TesteParqQuestions.testeParqQ5.question,
          'Você tem algum problema ósseo ou articular que poderia agravar-se com a prática de atividades físicas?');
      expect(TesteParqQuestions.testeParqQ5.options, ['Sim', 'Não']);

      expect(TesteParqQuestions.testeParqQ6.question,
          'Algum médico já lhe prescreveu medicamentos para pressão arterial ou para o coração?');
      expect(TesteParqQuestions.testeParqQ6.options, ['Sim', 'Não']);

      expect(TesteParqQuestions.testeParqQ7.question,
          'Você tem conhecimento, por informação médica ou por experiência própria, de algum motivo que poderia impedi-lo de participar de atividades físicas sem supervisão médica?');
      expect(TesteParqQuestions.testeParqQ7.options, ['Sim', 'Não']);
    });
  });

  group('TesteHistSaudeQuestions', () {
    test('should return correct question and options for each enum value', () {
      expect(TesteHistSaudeQuestions.testeHistSaudeQ1.question,
          'Você fuma ou já foi fumante?');
      expect(TesteHistSaudeQuestions.testeHistSaudeQ1.options,
          ['Fumo', 'Já fui fumante', 'Nunca fumei']);

      expect(TesteHistSaudeQuestions.testeHistSaudeQ2.question,
          'Você tem pressão Alta/ Pressão Baixa?');
      expect(TesteHistSaudeQuestions.testeHistSaudeQ2.options,
          ['Pressão Alta', 'Pressão Baixa', 'Normal', 'Não sei']);

      expect(TesteHistSaudeQuestions.testeHistSaudeQ3.question,
          'Você tem diabetes?');
      expect(TesteHistSaudeQuestions.testeHistSaudeQ3.options, ['Sim', 'Não']);

      expect(TesteHistSaudeQuestions.testeHistSaudeQ4.question,
          'Você tem Colesterol Alto?');
      expect(TesteHistSaudeQuestions.testeHistSaudeQ4.options, ['Sim', 'Não']);

      expect(TesteHistSaudeQuestions.testeHistSaudeQ5.question,
          'Há histórico na família de alguma dessas doenças?');
      expect(TesteHistSaudeQuestions.testeHistSaudeQ5.options, ['Sim', 'Não']);

      expect(TesteHistSaudeQuestions.testeHistSaudeQ6.question,
          'Você tem intolerância alimentar ou alergia?');
      expect(TesteHistSaudeQuestions.testeHistSaudeQ6.options, ['Sim', 'Não']);

      expect(TesteHistSaudeQuestions.testeHistSaudeQ7.question,
          'Você faz a ingestão de Algum Suplemento?');
      expect(TesteHistSaudeQuestions.testeHistSaudeQ7.options, ['Sim', 'Não']);

      expect(TesteHistSaudeQuestions.testeHistSaudeQ8.question,
          'Como é sua ingestão de Água diária?');
      expect(TesteHistSaudeQuestions.testeHistSaudeQ8.options,
          ['Menos de 1L', 'Entre 1L e 2L', 'Entre 2L e 3L', 'Acima de 3L']);

      expect(TesteHistSaudeQuestions.testeHistSaudeQ9.question,
          'Qual seu motivo para a prática de Exercício Físico?');
      expect(TesteHistSaudeQuestions.testeHistSaudeQ9.options, []);

      expect(TesteHistSaudeQuestions.testeHistSaudeQ10.question,
          'Você tem alguma informação a acrescentar que não foi dita anterior?');
      expect(TesteHistSaudeQuestions.testeHistSaudeQ10.options, []);
    });
  });
}
