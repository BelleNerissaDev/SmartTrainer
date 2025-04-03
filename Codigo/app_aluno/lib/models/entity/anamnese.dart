import 'package:SmartTrainer/models/entity/sexo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusAnamneseEnum {
  REALIZADA,
  PEDENTE;

  @override
  String toString() {
    switch (this) {
      case StatusAnamneseEnum.REALIZADA:
        return 'Realizada';
      case StatusAnamneseEnum.PEDENTE:
        return 'Pendente';
    }
  }
}

class Anamnese {
  String? id;
  String email;
  DateTime data;
  String nomeCompleto;
  String? nomeResponsavel;
  int idade;
  Sexo sexo;
  String telefone;
  StatusAnamneseEnum status = StatusAnamneseEnum.PEDENTE;

  String nomeContatoEmergencia;
  String telefoneContatoEmergencia;

  RespostasParq? respostasParq;

  RespostasHistSaude? respostasHistSaude;

  Anamnese(
      {required this.email,
      required this.nomeCompleto,
      required this.data,
      this.nomeResponsavel,
      required this.idade,
      required this.sexo,
      required this.status,
      required this.telefone,
      required this.nomeContatoEmergencia,
      required this.telefoneContatoEmergencia,
      required this.respostasParq,
      required this.respostasHistSaude,
      this.id});

  // Método para converter em Map (para envio ao Firebase)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nomeCompleto': nomeCompleto,
      'nomeResponsavel': nomeResponsavel,
      'data': data,
      'idade': idade,
      'sexo': sexo.toString(),
      'status': status.toString(),
      'telefone': telefone,
      'nomeContatoEmergencia': nomeContatoEmergencia,
      'telefoneContatoEmergencia': telefoneContatoEmergencia,
      'respostasParq': respostasParq?.toMap(),
      'respostasHistSaude': respostasHistSaude?.toMap(),
    };
  }

  // Método para criar a partir de um Map (útil para ler do Firebase)
  factory Anamnese.fromMap(Map<String, dynamic> map, [String? id]) {
    return Anamnese(
      id: id,
      email: map['email'] ?? '',
      data: (map['data'] as Timestamp).toDate(),
      nomeCompleto: map['nomeCompleto'] ?? '',
      nomeResponsavel: map['nomeResponsavel'] ?? '',
      idade: map['idade'] ?? 0,
      sexo: map['sexo'] != null
          ? Sexo.values.firstWhere((e) => e.toString() == map['sexo'],
              orElse: () => Sexo.outro)
          : Sexo.outro,
      status: map['status'] != null
          ? StatusAnamneseEnum.values.firstWhere(
              (e) => e.toString() == map['status'],
              orElse: () => StatusAnamneseEnum.PEDENTE)
          : StatusAnamneseEnum.PEDENTE,
      telefone: map['telefone'] ?? '',
      nomeContatoEmergencia: map['nomeContatoEmergencia'] ?? '',
      telefoneContatoEmergencia: map['telefoneContatoEmergencia'] ?? '',
      respostasParq: RespostasParq.fromMap(map['respostasParq']),
      respostasHistSaude: RespostasHistSaude.fromMap(map['respostasHistSaude']),
    );
  }

  @override
  String toString() {
    return 'Anamnese{\n'
        '  id: $id,\n'
        '  email: $email,\n'
        '  nomeCompleto: $nomeCompleto,\n'
        '  nomeResponsavel: ${nomeResponsavel ?? 'N/A'},\n'
        '  idade: $idade,\n'
        '  sexo: $sexo,\n'
        '  telefone: $telefone,\n'
        '  status: $status,\n'
        '  nomeContatoEmergencia: $nomeContatoEmergencia,\n'
        '  telefoneContatoEmergencia: $telefoneContatoEmergencia,\n'
        '  respostasParq: ${respostasParq.toString()},\n'
        '  respostasHistSaude: ${respostasHistSaude.toString()}\n'
        '}';
  }
}

class RespostasParq {
  Map<String, String> respostas;

  RespostasParq({required this.respostas});

  factory RespostasParq.fromMap(Map<String, dynamic> map) {
    try {
      return RespostasParq(
        respostas: map.map((key, value) {
          return MapEntry(key, value);
        }),
      );
    } catch (e) {
      throw Exception('Falha ao converter RespostasParq a partir do map');
    }
  }

  Map<String, dynamic> toMap() {
    return respostas.map((key, value) => MapEntry(key.toString(), value));
  }

  @override
  String toString() {
    return respostas.toString();
  }

  // Para teste de comparação
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RespostasParq &&
          runtimeType == other.runtimeType &&
          _mapsAreEqual(respostas, other.respostas);
// Para teste de comparação
  @override
  int get hashCode => respostas.hashCode;
// Para teste de comparação
  bool _mapsAreEqual(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    return map1.entries.every((entry) => map2[entry.key] == entry.value);
  }
}

class RespostasHistSaude {
  Map<String, String> respostas;

  RespostasHistSaude({required this.respostas});

  factory RespostasHistSaude.fromMap(Map<String, dynamic> map) {
    try {
      return RespostasHistSaude(
        respostas: map.map((key, value) {
          return MapEntry(key, value);
        }),
      );
    } catch (e) {
      throw Exception('Falha ao converter RespostasHistSaude a partir do map');
    }
  }

  Map<String, dynamic> toMap() {
    return respostas.map((key, value) => MapEntry(key.toString(), value));
  }

  @override
  String toString() {
    return respostas.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RespostasHistSaude &&
          runtimeType == other.runtimeType &&
          _mapsAreEqual(respostas, other.respostas);

  @override
  int get hashCode => respostas.hashCode;

  bool _mapsAreEqual(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    return map1.entries.every((entry) => map2[entry.key] == entry.value);
  }
}
