import 'package:SmartTrainer_Personal/models/entity/anamnese.dart';
import 'package:SmartTrainer_Personal/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusAlunoEnum {
  ATIVO,
  BLOQUEADO;

  @override
  String toString() {
    switch (this) {
      case StatusAlunoEnum.ATIVO:
        return 'Ativo';
      case StatusAlunoEnum.BLOQUEADO:
        return 'Bloqueado';
    }
  }
}

class Aluno {
  String? id;

  String _nome;
  String _telefone;
  String _email;
  String _sexo;
  bool _primeiroAcesso;
  DateTime _dataNascimento;
  StatusAlunoEnum _status;
  String _uid;
  Pacote _pacote;

  String? _imagem;
  double? _peso;
  int? _altura;

  final _avaliacoesFisicas = <AvaliacaoFisica>[];
  final _anamneses = <Anamnese>[];

  Aluno({
    required String nome,
    required String telefone,
    required String email,
    required String sexo,
    required StatusAlunoEnum status,
    required String uid,
    required bool primeiroAcesso,
    required DateTime dataNascimento,
    required Pacote pacote,
    String? imagem,
    double? peso,
    int? altura,
    this.id,
  })  : _nome = nome,
        _telefone = telefone,
        _email = email,
        _sexo = sexo,
        _imagem = imagem,
        _status = status,
        _peso = peso,
        _altura = altura,
        _uid = uid,
        _dataNascimento = dataNascimento,
        _pacote = pacote,
        _primeiroAcesso = primeiroAcesso;

  void addAvaliacaoFisica(AvaliacaoFisica avaliacaoFisica) {
    _avaliacoesFisicas.add(avaliacaoFisica);
  }

  void addAnamnese(Anamnese anamnese) {
    _anamneses.add(anamnese);
  }

  void addAllAvaliacoesFisicas(List<AvaliacaoFisica> avaliacoesFisicas) {
    for (final avaliacao in avaliacoesFisicas) {
      if (!_avaliacoesFisicas.contains(avaliacao)) {
        _avaliacoesFisicas.add(avaliacao);
      }
    }
  }

  void addAllAnamneses(List<Anamnese> anamneses) {
    for (final anamnese in anamneses) {
      if (!_anamneses.contains(anamnese)) {
        _anamneses.add(anamnese);
      }
    }
  }

  String get nome => _nome;
  String get telefone => _telefone;
  String get email => _email;
  String get sexo => _sexo;
  String? get imagem => _imagem;
  StatusAlunoEnum get status => _status;
  double? get peso => _peso;
  int? get altura => _altura;
  String get uid => _uid;
  List<AvaliacaoFisica> get avaliacoesFisicas => _avaliacoesFisicas;
  List<Anamnese> get anamneses => _anamneses;
  bool get primeiroAcesso => _primeiroAcesso;
  DateTime get dataNascimento => _dataNascimento;
  Pacote get pacote => _pacote;

  get idade => null;

  set nome(String nome) => _nome = nome;
  set telefone(String telefone) => _telefone = telefone;
  set email(String email) => _email = email;
  set sexo(String sexo) => _sexo = sexo;
  set imagem(String? imagem) => _imagem = imagem;
  set status(StatusAlunoEnum status) => _status = status;
  set peso(double? peso) => _peso = peso;
  set altura(int? altura) => _altura = altura;
  set uid(String uid) => _uid = uid;
  set primeiroAcesso(bool primeiroAcesso) => _primeiroAcesso = primeiroAcesso;
  set dataNascimento(DateTime dataNascimento) =>
      _dataNascimento = dataNascimento;
  set pacote(Pacote pacote) => _pacote = pacote;

  Map<String, dynamic> toMap() {
    return {
      'nome': _nome,
      'telefone': _telefone,
      'email': _email,
      'sexo': _sexo,
      'status': _status.toString(),
      if (_peso != null) 'peso': _peso,
      if (_altura != null) 'altura': _altura,
      if (_imagem != null) 'imagem': _imagem,
      'uid': _uid,
      'primeiroAcesso': _primeiroAcesso,
      'dataNascimento': _dataNascimento,
      'pacoteId': _pacote.id,
    };
  }

  static Aluno? fromMap(Map<String, dynamic>? map, String id, Pacote pacote) {
    if (map == null) {
      return null;
    }
    final dataNascimento = map['dataNascimento'] as Timestamp;
    return Aluno(
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
      sexo: map['sexo'],
      status: StatusAlunoEnum.values
          .firstWhere((e) => e.toString() == map['status']),
      imagem: map['imagem'],
      peso: map['peso'],
      altura: map['altura'],
      uid: map['uid'],
      primeiroAcesso: map['primeiroAcesso'],
      dataNascimento: dataNascimento.toDate(),
      pacote: pacote,
      id: id,
    );
  }

}
