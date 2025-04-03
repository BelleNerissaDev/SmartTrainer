import 'package:SmartTrainer/models/entity/grupo_muscular.dart';

enum StatusExercicio {
  CONCLUIDO,
  PENDENTE;
}

class MetodologiaExercicio {
  static final TRADICIONAL = MetodologiaExercicio._(value: 'Tradicional');
  static final BISET = MetodologiaExercicio._(value: 'Bi-set');
  static MetodologiaExercicio PERSONALIZADO(String? value) =>
      MetodologiaExercicio._(value: value);
  // ;

  String? value;

  MetodologiaExercicio._({this.value});

  static List<MetodologiaExercicio> get values => [
        TRADICIONAL,
        BISET,
        PERSONALIZADO(null),
      ];

  static MetodologiaExercicio fromString(String value) {
    return values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => PERSONALIZADO(value),
    );
  }

  @override
  String toString() {
    return value ?? 'Personalizado';
  }
}

class Exercicio {
  String? id;

  String _nome;
  MetodologiaExercicio _metodologia;
  String _descricao;
  double _carga;
  int _repeticoes;
  int _series;
  final String _intervalo;
  String? _tipoCarga;
  StatusExercicio? _status;

  String? _videoUrl;
  String? _imagem;

  final List<GrupoMuscular> _gruposMusculares;

  Exercicio({
    required String nome,
    required MetodologiaExercicio metodologia,
    required String descricao,
    required double carga,
    required int repeticoes,
    required int series,
    required String intervalo,
    List<GrupoMuscular> gruposMusculares = const [],
    String? tipoCarga,
    StatusExercicio? status,
    String? imagem,
    String? videoUrl,
    this.id,
  })  : _nome = nome,
        _metodologia = metodologia,
        _descricao = descricao,
        _carga = carga,
        _repeticoes = repeticoes,
        _series = series,
        _intervalo = intervalo,
        _status = status,
        _videoUrl = videoUrl,
        _imagem = imagem,
        _tipoCarga = tipoCarga,
        _gruposMusculares = gruposMusculares;

  String get nome => _nome;
  MetodologiaExercicio get metodologia => _metodologia;
  String get descricao => _descricao;
  double get carga => _carga;
  StatusExercicio get status => _status!;
  String? get videoUrl => _videoUrl;
  String? get imagem => _imagem;
  List<GrupoMuscular> get gruposMusculares => _gruposMusculares;
  int get repeticoes => _repeticoes;
  int get series => _series;
  String? get tipoCarga => _tipoCarga;
  String get intervalo => _intervalo;

  set nome(String nome) => _nome = nome;
  set metodologia(MetodologiaExercicio metodologia) =>
      _metodologia = metodologia;
  set descricao(String descricao) => _descricao = descricao;
  set carga(double carga) => _carga = carga;
  set status(StatusExercicio status) => _status = status;
  set videoUrl(String? videoUrl) => _videoUrl = videoUrl;
  set imagem(String? imagem) => _imagem = imagem;
  set repeticoes(int repeticoes) => _repeticoes = repeticoes;
  set series(int series) => _series = series;
  set tipoCarga(String? tipoCarga) => _tipoCarga = tipoCarga;

  Map<String, dynamic> toMap() {
    return {
      'nome': _nome,
      'metodologia': _metodologia.toString(),
      'descricao': _descricao,
      'carga': _carga,
      'repeticoes': _repeticoes,
      'series': _series,
      'intervalo': _intervalo,
      if (_videoUrl != null) 'videoUrl': _videoUrl,
      if (_imagem != null) 'imagem': _imagem,
      if (_tipoCarga != null) 'tipoCarga': _tipoCarga,
      'gruposMusculares': _gruposMusculares.map((e) => e.id).toList(),
    };
  }

  static Exercicio fromMap(Map<String, dynamic> map, String id,
      List<GrupoMuscular> gruposMusculares) {
    return Exercicio(
      id: id,
      nome: map['nome'],
      metodologia: MetodologiaExercicio.values.firstWhere(
        (e) => e.toString() == map['metodologia'],
        orElse: () => MetodologiaExercicio.PERSONALIZADO(map['metodologia']),
      ),
      descricao: map['descricao'],
      carga: (map['carga'] as num).toDouble(),
      repeticoes: map['repeticoes'],
      series: map['series'],
      intervalo: map['intervalo'] ?? '',
      tipoCarga: map['tipoCarga'],
      status: StatusExercicio.PENDENTE,
      videoUrl: map['videoUrl'],
      imagem: map['imagem'],
      gruposMusculares: gruposMusculares,
    );
  }
}
