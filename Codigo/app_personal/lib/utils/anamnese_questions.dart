// ignore_for_file: lines_longer_than_80_chars

enum TesteParqQuestions {
  testeParqQ1(
      'Seu médico já disse que você possui um problema cardíaco e/ou recomendou atividades físicas apenas sob supervisão médica?',
      ['Sim', 'Não']),
  testeParqQ2('Você tem dor no peito provocada por atividades físicas?',
      ['Sim', 'Não']),
  testeParqQ3('Você sentiu dor no peito no último mês?', ['Sim', 'Não']),
  testeParqQ4(
      'Você já perdeu a consciência em alguma ocasião ou sofreu alguma queda em virtude de tontura?',
      ['Sim', 'Não']),
  testeParqQ5(
      'Você tem algum problema ósseo ou articular que poderia agravar-se com a prática de atividades físicas?',
      ['Sim', 'Não']),
  testeParqQ6(
      'Algum médico já lhe prescreveu medicamentos para pressão arterial ou para o coração?',
      ['Sim', 'Não']),
  testeParqQ7(
      'Você tem conhecimento, por informação médica ou por experiência própria, de algum motivo que poderia impedi-lo de participar de atividades físicas sem supervisão médica?',
      ['Sim', 'Não']);

  final String question;
  final List<String> options;

  const TesteParqQuestions(this.question, this.options);

  @override
  String toString() => question;
}

enum TesteHistSaudeQuestions {
  testeHistSaudeQ1('Você fuma ou já foi fumante?',
      ['Fumo', 'Já fui fumante', 'Nunca fumei']),
  testeHistSaudeQ2('Você tem pressão Alta/ Pressão Baixa?',
      ['Pressão Alta', 'Pressão Baixa', 'Normal', 'Não sei']),
  testeHistSaudeQ3('Você tem diabetes?', ['Sim', 'Não']),
  testeHistSaudeQ4('Você tem Colesterol Alto?', ['Sim', 'Não']),
  testeHistSaudeQ5(
      'Há histórico na família de alguma dessas doenças?', ['Sim', 'Não']),
  testeHistSaudeQ6(
      'Você tem intolerância alimentar ou alergia?', ['Sim', 'Não']),
  testeHistSaudeQ7('Você faz a ingestão de Algum Suplemento?', ['Sim', 'Não']),
  testeHistSaudeQ8('Como é sua ingestão de Água diária?',
      ['Menos de 1L', 'Entre 1L e 2L', 'Entre 2L e 3L', 'Acima de 3L']),
  testeHistSaudeQ9('Qual seu motivo para a prática de Exercício Físico?', []),
  testeHistSaudeQ10(
      'Você tem alguma informação a acrescentar que não foi dita anterior?',
      []);

  final String question;
  final List<String> options;

  const TesteHistSaudeQuestions(this.question, this.options);

  @override
  String toString() => question;
}
