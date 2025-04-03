import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/titles/headline_titles.dart';
import 'package:SmartTrainer_Personal/models/entity/sexo.dart';
import 'package:SmartTrainer_Personal/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:SmartTrainer_Personal/components/inputs/text_input.dart';
import 'package:SmartTrainer_Personal/components/inputs/dropdown_input.dart';

class AnamnesePersonalDataForm extends StatelessWidget {
  final ColorFamily colorTheme;
  final TextEditingController emailController;
  final TextEditingController telefoneController;
  final TextEditingController nomeController;
  final TextEditingController idadeController;
  final TextEditingController responsavelController;
  final TextEditingController nomeContatoEmergenciaController;
  final TextEditingController telfoneContatoEmergenciaController;
  final Sexo? selectedSexo;
  final Function(Sexo?) onSexoChanged;
  final bool Function() validatePersonalData;
  final TextEditingController sexoDropdownController;
  final Map<String, bool> errors;

  AnamnesePersonalDataForm({
    Key? key,
    required this.colorTheme,
    required this.emailController,
    required this.telefoneController,
    required this.nomeController,
    required this.idadeController,
    required this.responsavelController,
    required this.nomeContatoEmergenciaController,
    required this.telfoneContatoEmergenciaController,
    required this.selectedSexo,
    required this.onSexoChanged,
    required this.validatePersonalData,
    required this.sexoDropdownController,
    required this.errors,
  }) : super(key: key);

  Map<String, dynamic> getPersonalFormDataforSubmit() {
    // bool isValid = validateFields();

    // if (isValid) {
    return {
      'nomeCompleto': nomeController.text,
      'email': emailController.text,
      'idade': int.parse(idadeController.text),
      'telefone': telefoneController.text,
      'nomeResponsavel': int.tryParse(idadeController.text) != null &&
              int.parse(idadeController.text) < 18
          ? responsavelController.text
          : '',
      'nomeContatoEmergencia': nomeContatoEmergenciaController.text,
      'telefoneContatoEmergencia': telfoneContatoEmergenciaController.text,
      'sexo': selectedSexo?.toString(),
    };
    // } else {
    //   return {};
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          const HeadlineTitles(title: 'Dados Pessoais'),
          const SizedBox(height: 10),
          // Campo: Nome Completo
          ObscuredTextField(
            colorTheme: colorTheme,
            label: 'Nome Completo',
            controller: nomeController,
            showErrors: errors['nomeCompleto']!,
            errors: errors['nomeCompleto']!
                ? [ErrorMessage(message: 'Nome inválido', error: true)]
                : [],
            backgroundColor: colorTheme.grey_font_500.withOpacity(0),
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
          const SizedBox(height: 5),

          // Campo: E-mail
          ObscuredTextField(
            label: 'E-mail',
            colorTheme: colorTheme,
            controller: emailController,
            showErrors: errors['email']!,
            errors: errors['email']!
                ? [ErrorMessage(message: 'E-mail inválido', error: true)]
                : [],
            backgroundColor: colorTheme.grey_font_500.withOpacity(0),
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
          const SizedBox(height: 5),

          // Campo: Idade
          ObscuredTextField(
            colorTheme: colorTheme,
            label: 'Idade',
            controller: idadeController,
            backgroundColor: colorTheme.grey_font_500.withOpacity(0),
            showErrors: errors['idade']!,
            errors: errors['idade']!
                ? [ErrorMessage(message: 'Idade inválida', error: true)]
                : [],
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
          // Exibe o campo de "Responsável" somente se a idade for menor que 18
          if (int.tryParse(idadeController.text) != null &&
              int.parse(idadeController.text) < 18)
            ObscuredTextField(
              colorTheme: colorTheme,
              label: 'Responsável',
              controller: responsavelController,
              showErrors: errors['responsavel']!,
              errors: errors['responsavel']!
                  ? [ErrorMessage(message: 'Nome inválido', error: true)]
                  : [],
              backgroundColor: colorTheme.grey_font_500.withOpacity(0),
              obscureText: false,
              paddingHorizontal: 2,
              paddingVertical: 2,
            ),

          // Dropdown: Sexo
          DropdownInput<Sexo>(
            width: double.infinity,
            selectedValue: selectedSexo,
            label: 'Sexo',
            items: Sexo.values,
            backgroundColor: colorTheme.white_onPrimary_100,
            showErrors: errors['sexo']!,
            errors: errors['sexo']!
                ? [ErrorMessage(message: 'Insira um valor válido', error: true)]
                : [],
            onSelected: (Sexo? newValue) {
              onSexoChanged(newValue);
            },
            paddingHorizontal: 2,
            paddingVertical: 0,
            dropdownController: sexoDropdownController,
          ),

          const SizedBox(height: 5),

          // Campo: Telefone
          ObscuredTextField(
            label: 'Telefone',
            colorTheme: colorTheme,
            controller: telefoneController,
            showErrors: errors['telefone']!,
            errors: errors['telefone']!
                ? [ErrorMessage(message: 'Telefone inválido', error: true)]
                : [],
            backgroundColor: colorTheme.grey_font_500.withOpacity(0),
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
          const SizedBox(height: 5),

          // Campo: Nome Contato de Emergência
          ObscuredTextField(
            label: 'Nome Contato de emergência',
            colorTheme: colorTheme,
            controller: nomeContatoEmergenciaController,
            showErrors: errors['nomeContatoEmergencia']!,
            errors: errors['nomeContatoEmergencia']!
                ? [ErrorMessage(message: 'Nome inválido', error: true)]
                : [],
            backgroundColor: colorTheme.grey_font_500.withOpacity(0),
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
          const SizedBox(height: 5),

          // Campo: Telefone Contato de Emergência
          ObscuredTextField(
            colorTheme: colorTheme,
            label: 'Telefone Contato de emergência',
            controller: telfoneContatoEmergenciaController,
            showErrors: errors['telefoneContatoEmergencia']!,
            errors: errors['telefoneContatoEmergencia']!
                ? [ErrorMessage(message: 'Telefone inválido', error: true)]
                : [],
            backgroundColor: colorTheme.grey_font_500.withOpacity(0),
            obscureText: false,
            paddingHorizontal: 2,
            paddingVertical: 2,
          ),
        ],
      ),
    );
  }
}
