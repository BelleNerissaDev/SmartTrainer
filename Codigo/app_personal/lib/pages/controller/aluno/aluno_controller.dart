import 'package:SmartTrainer_Personal/connections/provider/auth.dart' as Auth;
import 'package:SmartTrainer_Personal/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer_Personal/models/entity/aluno.dart';
import 'package:SmartTrainer_Personal/models/entity/pacote.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NovoAlunoController {
  final FirebaseAuth _auth;
  final AlunoRepository _alunoRepository;

  NovoAlunoController({
    FirebaseAuth? auth,
    AlunoRepository? alunoRepository,
  })  : _auth = auth ?? Auth.AuthProvider.instance,
        _alunoRepository = alunoRepository ?? AlunoRepository();

  Future<bool> salvarAluno({
    required String email,
    required String senha,
    required String nome,
    required String dataNascimento,
    required String telefone,
    required String sexo,
    required Pacote pacoteTreino,
  }) async {
    User? user;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      user = userCredential.user!;

      final Aluno aluno = Aluno(
        primeiroAcesso: true,
        nome: nome,
        telefone: telefone,
        email: email,
        sexo: sexo,
        imagem: null,
        status: StatusAlunoEnum.ATIVO,
        peso: 0,
        altura: 0,
        uid: user.uid,
        dataNascimento:
            DateTime.parse(dataNascimento.split('/').reversed.join('-')),
        pacote: pacoteTreino,
      );

      await _alunoRepository.create(aluno);

      user.sendEmailVerification();

      return true;
    } catch (e) {
      if (user != null) {
        user.delete();
      }
      return false;
    }
  }

  Future<bool> atualizarAluno({
    required String nome,
    required String dataNascimento,
    required String telefone,
    required Aluno aluno,
  }) async {
    try {
      aluno.nome = nome;
      aluno.telefone = telefone;
      aluno.dataNascimento =
          DateTime.parse(dataNascimento.split('/').reversed.join('-'));

      await _alunoRepository.update(aluno);

      return true;
    } catch (e) {
      return false;
    }
  }
}
