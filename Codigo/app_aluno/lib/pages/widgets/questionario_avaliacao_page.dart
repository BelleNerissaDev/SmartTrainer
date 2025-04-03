import 'package:SmartTrainer/components/header/header.dart';
import 'package:SmartTrainer/components/number_input.dart';
import 'package:SmartTrainer/components/stack_bar/snack_bar.dart';
import 'package:SmartTrainer/config/aluno_provider.dart';
import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/models/entity/aluno.dart';
import 'package:SmartTrainer/models/entity/avaliacao_fisica.dart';
import 'package:SmartTrainer/pages/controller/avaliacao_fisica_controller.dart';
import 'package:SmartTrainer/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class QuestionarioAvaliacaoPage extends StatefulWidget {
  const QuestionarioAvaliacaoPage({Key? key}) : super(key: key);

  @override
  _QuestionarioAvaliacaoPageState createState() =>
      _QuestionarioAvaliacaoPageState();
}

class _QuestionarioAvaliacaoPageState extends State<QuestionarioAvaliacaoPage> {
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _pescocoController = TextEditingController();
  final TextEditingController _cinturaController = TextEditingController();
  final TextEditingController _quadrilController = TextEditingController();

  final Map<String, List<ErrorMessage>> _errors = {
    'altura': [ErrorMessage(message: 'Insira a altura em cm', error: true)],
    'peso': [ErrorMessage(message: 'Insira o peso', error: true)],
    'pescoco': [ErrorMessage(message: 'Insira o pescoço', error: true)],
    'cintura': [ErrorMessage(message: 'Insira a cintura', error: true)],
    'quadril': [ErrorMessage(message: 'Insira o quadril', error: true)],
  };

  final Map<String, bool> _showErrors = {
    'altura': false,
    'peso': false,
    'pescoco': false,
    'cintura': false,
    'quadril': false,
  };

  Aluno? aluno;
  AvaliacaoFisica? avaliacaoFisica;

  bool hasErrors() => _showErrors.containsValue(true);

  void clearErrors() => setState(() {
        _showErrors['altura'] = false;
        _showErrors['peso'] = false;
        _showErrors['pescoco'] = false;
        _showErrors['cintura'] = false;
        _showErrors['quadril'] = false;
      });

  void loadErrors({
    bool altura = false,
    bool peso = false,
    bool pescoco = false,
    bool cintura = false,
    bool quadril = false,
  }) {
    setState(() {
      _showErrors['altura'] = altura;
      _showErrors['peso'] = peso;
      _showErrors['pescoco'] = pescoco;
      _showErrors['cintura'] = cintura;
      _showErrors['quadril'] = quadril;
    });
  }

  Future<void> _finalizar() async {
    clearErrors();

    final altura = int.tryParse(_alturaController.text.replaceAll(',', '.'));
    final peso = double.tryParse(_pesoController.text.replaceAll(',', '.'));
    final pescoco =
        double.tryParse(_pescocoController.text.replaceAll(',', '.'));
    final cintura =
        double.tryParse(_cinturaController.text.replaceAll(',', '.'));
    final quadril =
        double.tryParse(_quadrilController.text.replaceAll(',', '.'));

    loadErrors(
      altura: altura == null,
      peso: peso == null,
      pescoco: pescoco == null,
      cintura: cintura == null,
      quadril: quadril == null,
    );

    if (hasErrors()) {
      return;
    }

    final avaliacaoController = AvaliacaoFisicaController();
    final cadastrado = await avaliacaoController.cadastrarAvaliacaoOnline(
      avaliacaoFisica: avaliacaoFisica!,
      altura: altura!,
      peso: peso!,
      pescoco: pescoco!,
      cintura: cintura!,
      quadril: quadril!,
    );
 
    if (cadastrado) {
      Navigator.of(context).pop();
    } else {
      showSnackBar(
        context: context,
        message: 'Ocorreu um erro ao cadastrar a avaliação',
        error: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    aluno = Provider.of<AlunoProvider>(context, listen: false).aluno!;
    avaliacaoFisica =
        (ModalRoute.of(context)!.settings.arguments! as AvaliacaoFisica);
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    return Scaffold(
      appBar: Header(
        colorTheme: colorTheme,
      ),
      body: aluno == null || avaliacaoFisica == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Avaliação Física',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.play_circle_fill,
                            color: Colors.blue),
                        label:
                            const Text('Assista ao vídeo de Guia de Medidas'),
                        onPressed: () {
                          // Lógica do vídeo guia
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: NumberInputField(
                            label: 'Altura',
                            colorTheme: colorTheme,
                            controller: _alturaController,
                            errors: _errors['altura']!,
                            showErrors: _showErrors['altura']!,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: NumberInputField(
                            label: 'Peso',
                            colorTheme: colorTheme,
                            controller: _pesoController,
                            errors: _errors['peso']!,
                            showErrors: _showErrors['peso']!,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SvgPicture.asset(
                            aluno!.sexo == 'Masculino'
                                ? 'assets/svg/silhueta_homem.svg'
                                : 'assets/svg/silhueta_mulher.svg',
                            height: MediaQuery.of(context).size.height * 0.6,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 20,
                          child: Row(
                            children: [
                              Container(
                                width: 140,
                                height: 1,
                                color: colorTheme.black_onSecondary_100,
                              ),
                              SizedBox(
                                width: 120,
                                child: NumberInputField(
                                  label: 'Pescoço:',
                                  colorTheme: colorTheme,
                                  controller: _pescocoController,
                                  errors: _errors['pescoco']!,
                                  showErrors: _showErrors['pescoco']!,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 120,
                          child: Row(
                            children: [
                              Container(
                                width: 150,
                                height: 1,
                                color: colorTheme.black_onSecondary_100,
                              ),
                              SizedBox(
                                width: 120,
                                child: NumberInputField(
                                  label: 'Cintura:',
                                  colorTheme: colorTheme,
                                  controller: _cinturaController,
                                  errors: _errors['cintura']!,
                                  showErrors: _showErrors['cintura']!,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 190,
                          child: Row(
                            children: [
                              Container(
                                width: 150,
                                height: 1,
                                color: colorTheme.black_onSecondary_100,
                              ),
                              SizedBox(
                                width: 120,
                                child: NumberInputField(
                                  label: 'Quadril:',
                                  colorTheme: colorTheme,
                                  controller: _quadrilController,
                                  errors: _errors['quadril']!,
                                  showErrors: _showErrors['quadril']!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _finalizar,
                      child: const Text('Finalizar',
                          style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
