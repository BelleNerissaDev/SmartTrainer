import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/components/input/dropdown_input.dart';
import 'package:SmartTrainer/components/input/text_input.dart';
import 'package:SmartTrainer/models/entity/anamnese.dart';
import 'package:SmartTrainer/models/entity/sexo.dart';
import 'package:SmartTrainer/utils/error_message.dart';
import 'package:SmartTrainer/utils/validations.dart';
import 'package:flutter/material.dart';

class AnamnesePersonalDataForm extends StatefulWidget {
  final MyColorFamily colorTheme;
  final Anamnese? ultimaAnamnese;

  const AnamnesePersonalDataForm(
      {Key? key, required this.colorTheme, required this.ultimaAnamnese})
      : super(key: key);

  @override
  AnamnesePersonalDataFormState createState() =>
      AnamnesePersonalDataFormState();
}

class AnamnesePersonalDataFormState extends State<AnamnesePersonalDataForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _responsavelController = TextEditingController();
  final _nomeContatoEmergenciaController = TextEditingController();
  final _telfoneContatoEmergenciaController = TextEditingController();
  Sexo? selectedSexo;
  final TextEditingController sexoDropdownController = TextEditingController();

  bool isDataLoaded = false;

  Map<String, bool> errors = {
    'nomeCompleto': false,
    'email': false,
    'idade': false,
    'telefone': false,
    'nomeContatoEmergencia': false,
    'telefoneContatoEmergencia': false,
    'sexo': false,
    'responsavel': false,
  };

  void getAnamneseData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.ultimaAnamnese != null) {
        setState(() {
          _nomeController.text = widget.ultimaAnamnese!.nomeCompleto;
          _emailController.text = widget.ultimaAnamnese!.email;
          _idadeController.text = widget.ultimaAnamnese!.idade.toString();
          _telefoneController.text = widget.ultimaAnamnese!.telefone;
          _responsavelController.text =
              widget.ultimaAnamnese!.nomeResponsavel ?? '';
          _nomeContatoEmergenciaController.text =
              widget.ultimaAnamnese!.nomeContatoEmergencia;
          _telfoneContatoEmergenciaController.text =
              widget.ultimaAnamnese!.telefoneContatoEmergencia;
          selectedSexo = widget.ultimaAnamnese!.sexo;

          isDataLoaded = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getAnamneseData();
  }

  bool hasError(field) => errors[field]!;

  bool validateFields() {
    final String nomeCompleto = _nomeController.text;
    final String responsavel = _responsavelController.text;
    final String email = _emailController.text;
    final String idade = _idadeController.text;
    final String telefone = _telefoneController.text;
    final String nomeContatoEmergencia = _nomeContatoEmergenciaController.text;
    final String telefoneContatoEmergencia =
        _telfoneContatoEmergenciaController.text;

    final bool nomeValid = Validations.validateNome(nomeCompleto);
    final bool emailValid = Validations.validateEmail(email);
    final bool idadeValid = Validations.validateNumeroInteiro(idade);
    final bool telefoneValid = Validations.validateTelefone(telefone);
    final bool nomeContatoEmergenciaValid =
        Validations.validateNome(nomeContatoEmergencia);
    final bool telefoneContatoEmergenciaValid =
        Validations.validateTelefone(telefoneContatoEmergencia);
    final bool sexoValid = selectedSexo != null;

    final bool responsavelValid =
        int.tryParse(idade) != null && int.parse(idade) < 18
            ? Validations.validateNome(responsavel)
            : true;

    setState(() {
      errors['nomeCompleto'] = !nomeValid;
      errors['email'] = !emailValid;
      errors['idade'] = !idadeValid;
      errors['telefone'] = !telefoneValid;
      errors['nomeContatoEmergencia'] = !nomeContatoEmergenciaValid;
      errors['telefoneContatoEmergencia'] = !telefoneContatoEmergenciaValid;
      errors['sexo'] = !sexoValid;

      errors['responsavel'] =
          int.tryParse(idade) != null && int.parse(idade) < 18
              ? !responsavelValid
              : false;
    });

    return nomeValid &&
        emailValid &&
        idadeValid &&
        telefoneValid &&
        nomeContatoEmergenciaValid &&
        telefoneContatoEmergenciaValid &&
        sexoValid &&
        responsavelValid;
  }

  void cleanFields() {
    _nomeController.clear();
    _emailController.clear();
    _idadeController.clear();
    _telefoneController.clear();
    _responsavelController.clear();
    _nomeContatoEmergenciaController.clear();
    _telfoneContatoEmergenciaController.clear();
    selectedSexo = null;
  }

  void cleanErrors() {
    setState(() {
      errors = {
        'nomeCompleto': false,
        'email': false,
        'idade': false,
        'telefone': false,
        'nomeContatoEmergencia': false,
        'telefoneContatoEmergencia': false,
        'sexo': false,
        'responsavel': false,
      };
    });
  }

  Map<String, dynamic> getPersonalFormDataforSubmit() {
    bool isValid = validateFields();

    if (isValid) {
      return {
        'nomeCompleto': _nomeController.text,
        'email': _emailController.text,
        'idade': int.parse(_idadeController.text),
        'telefone': _telefoneController.text,
        'nomeResponsavel': int.tryParse(_idadeController.text) != null &&
                int.parse(_idadeController.text) < 18
            ? _responsavelController.text
            : '',
        'nomeContatoEmergencia': _nomeContatoEmergenciaController.text,
        'telefoneContatoEmergencia': _telfoneContatoEmergenciaController.text,
        'sexo': selectedSexo?.toString(),
      };
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = widget.colorTheme;
    final enabled =
        widget.ultimaAnamnese!.status == StatusAnamneseEnum.REALIZADA
            ? false
            : true;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ObscuredTextField(
            enabled: enabled,
            colorTheme: colorTheme,
            label: 'Nome Completo',
            controller: _nomeController,
            backgroundColor: colorTheme.gray_500.withOpacity(0),
            showErrors: errors['nomeCompleto']!,
            errors: errors['nomeCompleto']!
                ? [ErrorMessage(message: 'Nome inválido', error: true)]
                : [],
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
          const SizedBox(height: 5),
          ObscuredTextField(
            label: 'E-mail',
            enabled: enabled,
            colorTheme: colorTheme,
            controller: _emailController,
            backgroundColor: colorTheme.gray_500.withOpacity(0),
            showErrors: errors['email']!,
            errors: errors['email']!
                ? [ErrorMessage(message: 'E-mail inválido', error: true)]
                : [],
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
          const SizedBox(height: 5),
          ObscuredTextField(
            label: 'Idade',
            enabled: enabled,
            colorTheme: colorTheme,
            controller: _idadeController,
            backgroundColor: colorTheme.gray_500.withOpacity(0),
            showErrors: errors['idade']!,
            errors: errors['idade']!
                ? [ErrorMessage(message: 'Idade inválida', error: true)]
                : [],
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
          // Exibe o campo de "Responsável" somente se a idade for menor que 18
          if (int.tryParse(_idadeController.text) != null &&
              int.parse(_idadeController.text) < 18)
            Column(
              children: [
                ObscuredTextField(
                  label: 'Responsável',
                  enabled: enabled,
                  colorTheme: colorTheme,
                  controller: _responsavelController,
                  backgroundColor: colorTheme.gray_500.withOpacity(0),
                  showErrors: errors['responsavel']!,
                  errors: errors['responsavel']!
                      ? [ErrorMessage(message: 'Nome inválido', error: true)]
                      : [],
                  obscureText: false,
                  paddingHorizontal: 2,
                  paddingVertical: 2,
                ),
                const SizedBox(height: 5),
              ],
            ),
          const SizedBox(height: 5),
          DropdownInput<Sexo>(
            width: double.infinity,
            enabled: enabled,
            selectedValue: selectedSexo,
            showErrors: errors['sexo']!,
            errors: errors['sexo']!
                ? [ErrorMessage(message: 'Insira um valor válido', error: true)]
                : [],
            label: 'Sexo',
            items: Sexo.values,
            backgroundColor: colorTheme.white_onPrimary_100,
            onSelected: (Sexo? newValue) {
              setState(() {
                selectedSexo = newValue;
              });
            },
            paddingHorizontal: 2,
            paddingVertical: 0,
            dropdownController: sexoDropdownController,
          ),
          ObscuredTextField(
            label: 'Telefone',
            enabled: enabled,
            colorTheme: colorTheme,
            controller: _telefoneController,
            backgroundColor: colorTheme.gray_500.withOpacity(0),
            showErrors: errors['telefone']!,
            errors: errors['telefone']!
                ? [ErrorMessage(message: 'Telefone inválido', error: true)]
                : [],
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
          const SizedBox(height: 5),
          ObscuredTextField(
            label: 'Nome Contato de emergência',
            enabled: enabled,
            colorTheme: colorTheme,
            controller: _nomeContatoEmergenciaController,
            backgroundColor: colorTheme.gray_500.withOpacity(0),
            showErrors: errors['nomeContatoEmergencia']!,
            errors: errors['nomeContatoEmergencia']!
                ? [ErrorMessage(message: 'Nome inválido', error: true)]
                : [],
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
          const SizedBox(height: 5),
          ObscuredTextField(
            label: 'Telefone Contato de emergência',
            enabled: enabled,
            colorTheme: colorTheme,
            controller: _telfoneContatoEmergenciaController,
            backgroundColor: colorTheme.gray_500.withOpacity(0),
            showErrors: errors['telefoneContatoEmergencia']!,
            errors: errors['telefoneContatoEmergencia']!
                ? [ErrorMessage(message: 'Telefone inválido', error: true)]
                : [],
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
        ],
      ),
    );
  }
}
