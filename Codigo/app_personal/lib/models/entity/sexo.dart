enum Sexo {
  feminino('Feminino'),
  masculino('Masculino'),
  outro('Outro');

  final String label;

  const Sexo(this.label);

  @override
  String toString() =>
      label; // Sobrescreve o método toString para exibir apenas o label

  // Método para converter string em enum Sexo
  static Sexo fromString(String sexo) {
    switch (sexo.toLowerCase()) {
      case 'feminino':
        return Sexo.feminino;
      case 'masculino':
        return Sexo.masculino;
      case 'outro':
        return Sexo.outro;
      default:
        throw ArgumentError('Sexo inválido: $sexo');
    }
  }
}
