import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';

void main() {
  group('Anamnese', () {
    late RespostasParq respostasParq;
    late RespostasHistSaude respostasHistSaude;

    setUpAll(() {
      respostasParq = RespostasParq(respostas: {
        'testeParqQ1': 'Não',
        'testeParqQ2': 'Não',
        'testeParqQ3': 'Não',
        'testeParqQ4': 'Não',
        'testeParqQ5': 'Não',
        'testeParqQ6': 'Não',
        'testeParqQ7': 'Não',
      });

      // Mock das respostas para RespostasHistSaude
      respostasHistSaude = RespostasHistSaude(respostas: {
        'testeHistSaudeQ1': 'Fumo',
        'testeHistSaudeQ2': 'Não sei',
        'testeHistSaudeQ3': 'Não',
        'testeHistSaudeQ4': 'Não',
        'testeHistSaudeQ5': 'Não',
        'testeHistSaudeQ6': 'Não',
        'testeHistSaudeQ7': 'Não',
        'testeHistSaudeQ8': 'Menos que 1L',
        'testeHistSaudeQ9': 'Nenhum',
        'testeHistSaudeQ10': 'Nada',
      });
    });

    test('should create an instance of Anamnese', () {
      final anamnese = Anamnese(
        id: '1',
        email: 'example@example.com',
        nomeCompleto: 'John Doe',
        data: DateTime(2023, 10, 10),
        idade: 25,
        sexo: Sexo.masculino,
        status: StatusAnamneseEnum.PEDENTE,
        telefone: '123456789',
        nomeContatoEmergencia: 'Jane Doe',
        telefoneContatoEmergencia: '987654321',
        respostasParq: respostasParq,
        respostasHistSaude: respostasHistSaude,
      );

      expect(anamnese.id, '1');
      expect(anamnese.email, 'example@example.com');
      expect(anamnese.nomeCompleto, 'John Doe');
      expect(anamnese.data, DateTime(2023, 10, 10));
      expect(anamnese.idade, 25);
      expect(anamnese.sexo, Sexo.masculino);
      expect(anamnese.status, StatusAnamneseEnum.PEDENTE);
      expect(anamnese.telefone, '123456789');
      expect(anamnese.nomeContatoEmergencia, 'Jane Doe');
      expect(anamnese.telefoneContatoEmergencia, '987654321');
      expect(anamnese.respostasParq, respostasParq);
      expect(anamnese.respostasHistSaude, respostasHistSaude);
    });

    test('should convert Anamnese to map', () {
      final anamnese = Anamnese(
        id: '1',
        email: 'example@example.com',
        nomeCompleto: 'John Doe',
        data: DateTime(2023, 10, 10),
        idade: 25,
        sexo: Sexo.masculino,
        status: StatusAnamneseEnum.PEDENTE,
        telefone: '123456789',
        nomeContatoEmergencia: 'Jane Doe',
        telefoneContatoEmergencia: '987654321',
        respostasParq: respostasParq,
        respostasHistSaude: respostasHistSaude,
      );

      final expectedMap = {
        'email': 'example@example.com',
        'nomeCompleto': 'John Doe',
        'nomeResponsavel': null,
        'data': DateTime(2023, 10, 10),
        'idade': 25,
        'sexo': 'Masculino',
        'status': 'Pendente',
        'telefone': '123456789',
        'nomeContatoEmergencia': 'Jane Doe',
        'telefoneContatoEmergencia': '987654321',
        'respostasParq': respostasParq.toMap(),
        'respostasHistSaude': respostasHistSaude.toMap(),
      };

      final map = anamnese.toMap();

      expect(map, expectedMap);
    });

    test('should create an instance of Anamnese from map', () {
      final map = {
        'email': 'example@example.com',
        'nomeCompleto': 'John Doe',
        'data': Timestamp.fromDate(DateTime(2023, 10, 10)),
        'idade': 25,
        'sexo': 'Masculino',
        'status': 'Realizada',
        'telefone': '123456789',
        'nomeContatoEmergencia': 'Jane Doe',
        'telefoneContatoEmergencia': '987654321',
        'respostasParq': respostasParq.toMap(),
        'respostasHistSaude': respostasHistSaude.toMap(),
      };

      final anamnese = Anamnese.fromMap(map);

      expect(anamnese.email, 'example@example.com');
      expect(anamnese.nomeCompleto, 'John Doe');
      expect(anamnese.data, DateTime(2023, 10, 10));
      expect(anamnese.idade, 25);
      expect(anamnese.sexo, Sexo.masculino);
      expect(anamnese.status, StatusAnamneseEnum.REALIZADA);
      expect(anamnese.telefone, '123456789');
      expect(anamnese.nomeContatoEmergencia, 'Jane Doe');
      expect(anamnese.telefoneContatoEmergencia, '987654321');
      expect(anamnese.respostasParq, respostasParq);
      expect(anamnese.respostasHistSaude, respostasHistSaude);
    });
  });
}
