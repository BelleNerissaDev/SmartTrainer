enum Sexo {
  feminino('Feminino'),
  masculino('Masculino'),
  outro('Outro');

  final String label;

  const Sexo(this.label);

  @override
  String toString() =>
      label; // Sobrescreve o método toString para exibir apenas o label
}
