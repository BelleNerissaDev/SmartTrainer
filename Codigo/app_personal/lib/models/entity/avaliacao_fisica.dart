import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TipoAvaliacao {
  pdf,
  online;

  String get name {
    switch (this) {
      case TipoAvaliacao.pdf:
        return 'PDF';
      case TipoAvaliacao.online:
        return 'Online';
    }
  }
}

enum StatusAvaliacao {
  realizada,
  pendente,
  ;

  String get name {
    switch (this) {
      case StatusAvaliacao.realizada:
        return 'Realizada';
      case StatusAvaliacao.pendente:
        return 'Pendente';
    }
  }
}

class AvaliacaoFisica {
  String? id;
  Aluno? aluno;

  DateTime _data;
  StatusAvaliacao _status;
  TipoAvaliacao _tipoAvaliacao;

  double? _peso;
  int? _altura;
  int? _idade;
  double? _imc;
  double? _percentualGordura;
  double? _relacaoCinturaQuadril;
  double? _pesoGordura;
  double? _medidaCintura;
  double? _medidaQuadril;
  double? _medidaPescoco;

  String? _linkArquivo;

  // Getters
  DateTime get data => _data;
  StatusAvaliacao get status => _status;
  TipoAvaliacao get tipoAvaliacao => _tipoAvaliacao;

  double? get peso => _peso;
  int? get altura => _altura;
  int? get idade => _idade;
  double? get imc => _imc;
  double? get percentualGordura => _percentualGordura;
  double? get relacaoCinturaQuadril => _relacaoCinturaQuadril;
  double? get pesoGordura => _pesoGordura;
  double? get medidaCintura => _medidaCintura;
  double? get medidaQuadril => _medidaQuadril;
  double? get medidaPescoco => _medidaPescoco;

  String? get linkArquivo => _linkArquivo;

  // Setters
  set data(DateTime value) => _data = value;
  set status(StatusAvaliacao value) => _status = value;
  set tipoAvaliacao(TipoAvaliacao value) => _tipoAvaliacao = value;

  set peso(double? value) => _peso = value;
  set altura(int? value) => _altura = value;
  set idade(int? value) => _idade = value;
  set imc(double? value) => _imc = value;
  set percentualGordura(double? value) => _percentualGordura = value;
  set relacaoCinturaQuadril(double? value) => _relacaoCinturaQuadril = value;
  set pesoGordura(double? value) => _pesoGordura = value;
  set medidaCintura(double? value) => _medidaCintura = value;
  set medidaQuadril(double? value) => _medidaQuadril = value;
  set medidaPescoco(double? value) => _medidaPescoco = value;

  set linkArquivo(String? value) => _linkArquivo = value;

  AvaliacaoFisica({
    this.id,
    this.aluno,
    required DateTime data,
    required StatusAvaliacao status,
    required TipoAvaliacao tipoAvaliacao,
    double? peso,
    int? altura,
    int? idade,
    double? imc,
    double? percentualGordura,
    double? relacaoCinturaQuadril,
    double? pesoGordura,
    double? medidaCintura,
    double? medidaQuadril,
    double? medidaPescoco,
    String? linkArquivo,
  })  : _data = data,
        _status = status,
        _tipoAvaliacao = tipoAvaliacao,
        _peso = peso,
        _altura = altura,
        _idade = idade,
        _imc = imc,
        _percentualGordura = percentualGordura,
        _relacaoCinturaQuadril = relacaoCinturaQuadril,
        _pesoGordura = pesoGordura,
        _medidaCintura = medidaCintura,
        _medidaQuadril = medidaQuadril,
        _medidaPescoco = medidaPescoco,
        _linkArquivo = linkArquivo;

  static AvaliacaoFisica? fromMap(Map<String, dynamic> map) {
    try {
      return AvaliacaoFisica(
        data: (map['data'] as Timestamp).toDate(),
        status:
            StatusAvaliacao.values.firstWhere((e) => e.name == map['status']),
        tipoAvaliacao: TipoAvaliacao.values
            .firstWhere((e) => e.name == map['tipoAvaliacao']),
        peso: map['peso'],
        altura: map['altura'],
        idade: map['idade'],
        imc: map['imc'],
        percentualGordura: map['percentualGordura'],
        relacaoCinturaQuadril: map['relacaoCinturaQuadril'],
        pesoGordura: map['pesoGordura'],
        medidaCintura: map['medidaCintura'],
        medidaQuadril: map['medidaQuadril'],
        medidaPescoco: map['medidaPescoco'],
        linkArquivo: map['linkArquivo'],
        id: map['id'],
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'data': _data,
      'status': _status.name,
      'tipoAvaliacao': _tipoAvaliacao.name,
      if (_peso != null) 'peso': _peso,
      if (_altura != null) 'altura': _altura,
      if (_idade != null) 'idade': _idade,
      if (_imc != null) 'imc': _imc,
      if (_percentualGordura != null) 'percentualGordura': _percentualGordura,
      if (_relacaoCinturaQuadril != null)
        'relacaoCinturaQuadril': _relacaoCinturaQuadril,
      if (_pesoGordura != null) 'pesoGordura': _pesoGordura,
      if (_medidaCintura != null) 'medidaCintura': _medidaCintura,
      if (_medidaQuadril != null) 'medidaQuadril': _medidaQuadril,
      if (_medidaPescoco != null) 'medidaPescoco': _medidaPescoco,
      if (_linkArquivo != null) 'linkArquivo': _linkArquivo,
    };
  }
}
