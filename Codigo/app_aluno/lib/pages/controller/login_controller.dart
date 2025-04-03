import 'package:SmartTrainer/connections/provider/auth_provider.dart' as Auth;
import 'package:SmartTrainer/connections/repository/aluno_repository.dart';
import 'package:SmartTrainer/events/notificacao_events.dart.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginStatus {
  logado,
  logadoPrimeiraVez,
  emailNaoVerificado,
  senhaIncorreta,
  erroDesconhecido,
  limiteAcessosExcedido;
}

class LoginController {
  final FirebaseAuth _auth;
  final AlunoRepository _alunoRepository;
  final Future<SharedPreferences> _prefs;
  final FlutterSecureStorage _secureStorage;

  LoginController({
    FirebaseAuth? auth,
    AlunoRepository? alunoRepository,
    Future<SharedPreferences>? prefs,
    FlutterSecureStorage? secureStorage,
  })  : _auth = auth ?? Auth.AuthProvider.instance,
        _alunoRepository = alunoRepository ?? AlunoRepository(),
        _prefs = prefs ?? SharedPreferences.getInstance(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<bool> controlarAcessos(Aluno aluno) async {
    final prefs = await _prefs;

    int acessosMensais = int.parse(aluno.pacote.numeroAcessos);

    int acessosSemanais = (acessosMensais / 4).ceil().clamp(0, 7);

    String chaveAcessos = 'acessos_semanais';
    String chaveUltimoAcesso = 'ultimo_acesso';
    String chaveQuantidadeAcessos = 'quantidade_acessos';

    int acessosUsadosSemana = prefs.getInt(chaveAcessos) ?? 0;
    String? ultimoAcessoStr = prefs.getString(chaveUltimoAcesso);
    DateTime hoje = DateTime.now();
    DateTime ultimoAcesso = ultimoAcessoStr != null
        ? DateTime.parse(ultimoAcessoStr)
        : hoje.subtract(const Duration(days: 7));

    if (acessosUsadosSemana != aluno.acessosUsadosSemana) {
      acessosUsadosSemana = aluno.acessosUsadosSemana;
    }
    if (!DateUtils.isSameDay(ultimoAcesso, aluno.ultimoAcesso)) {
      ultimoAcesso = aluno.ultimoAcesso;
    }

    if (ehNovaSemana(ultimoAcesso, hoje)) {
      acessosUsadosSemana = 0;
    }

    if (acessosUsadosSemana >= acessosSemanais) {
      return false;
    }

    if (!DateUtils.isSameDay(ultimoAcesso, hoje) || acessosUsadosSemana == 0) {
      acessosUsadosSemana += 1;
    }
    await prefs.setInt(chaveAcessos, acessosUsadosSemana);
    await prefs.setString(chaveUltimoAcesso, hoje.toIso8601String());
    await prefs.setInt(chaveQuantidadeAcessos, acessosSemanais);
    aluno.acessosUsadosSemana = acessosUsadosSemana;
    aluno.ultimoAcesso = hoje;

    await _alunoRepository.update(aluno);

    return true;
  }

  bool ehNovaSemana(DateTime ultimoAcesso, DateTime agora) {
    DateTime inicioSemanaUltimoAcesso =
        ultimoAcesso.subtract(Duration(days: ultimoAcesso.weekday % 7));
    DateTime inicioSemanaAtual =
        agora.subtract(Duration(days: agora.weekday % 7));

    inicioSemanaUltimoAcesso = DateTime(
      inicioSemanaUltimoAcesso.year,
      inicioSemanaUltimoAcesso.month,
      inicioSemanaUltimoAcesso.day,
    );

    inicioSemanaAtual = DateTime(
      inicioSemanaAtual.year,
      inicioSemanaAtual.month,
      inicioSemanaAtual.day,
    );

    return inicioSemanaAtual.isAfter(inicioSemanaUltimoAcesso);
  }

  Future<LoginStatus> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (!userCredential.user!.emailVerified) {
        return LoginStatus.emailNaoVerificado;
      }

      String uid = userCredential.user!.uid;

      final aluno = await _alunoRepository.readBy('uid', uid);

      if (aluno.primeiroAcesso) {
        NotificacaoEvents.notificarPrimeiroAcesso(aluno.nome, aluno.imagem);
        return LoginStatus.logadoPrimeiraVez;
      }

      bool acessoPermitido = await controlarAcessos(aluno);

      if (!acessoPermitido) {
        return LoginStatus.limiteAcessosExcedido;
      }

      final prefs = await _prefs;
      await userCredential.user!.updateDisplayName(aluno.nome);

      String? token = await userCredential.user?.getIdToken();

      if (token != null) {
        DateTime now = DateTime.now();
        DateTime expiryTime = DateTime(now.year, now.month, now.day, 23, 59);

        await prefs.setString('token', token);
        await prefs.setString('tokenExpiry', expiryTime.toIso8601String());
        await prefs.setString('userId', aluno.id!);
        _secureStorage.write(key: 'email', value: aluno.email);
        _secureStorage.write(key: 'password', value: password);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return LoginStatus.senhaIncorreta;
      } else {
        return LoginStatus.erroDesconhecido;
      }
    } catch (e) {
      return LoginStatus.erroDesconhecido;
    }
    return LoginStatus.logado;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      final prefs = await _prefs;
      await prefs.remove('token');
      await prefs.remove('tokenExpiry');
      await prefs.remove('userId');
      await _secureStorage.delete(key: 'email');
      await _secureStorage.delete(key: 'password');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isTokenValid() async {
    final prefs = await _prefs;
    String? expiryDateStr = prefs.getString('tokenExpiry');

    if (expiryDateStr != null) {
      DateTime expiryDate = DateTime.parse(expiryDateStr);
      return DateTime.now().isBefore(expiryDate);
    }
    return false;
  }

  Future<bool> loginFromToken() async {
    final prefs = await _prefs;
    String? token = prefs.getString('token');
    String? email = await _secureStorage.read(key: 'email');
    String? password = await _secureStorage.read(key: 'password');

    if (await isTokenValid() && token != null) {
      User? user = _auth.currentUser;
      AuthCredential credential =
          EmailAuthProvider.credential(email: email!, password: password!);
      await user?.reauthenticateWithCredential(credential);
      return user != null;
    }

    return false;
  }

  Future<bool> esqueciSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }
}
