import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/fonts.dart';
import 'package:flutter/material.dart';

class CustomRadioButtonGroup extends StatelessWidget {
  final ColorFamily colorTheme;
  final List<String> options;
  final String? groupValue;
  // Input de Qual, caso a opção "Sim" seja selecionada
  final bool hadTextField;
  final TextEditingController? controllerTextField;
  final bool showError;
  final ValueChanged<String?> onChanged;
  final String textFieldOption;
  final String textFieldLabel;
  final bool readOnly;
  final double fieldWidth;

  const CustomRadioButtonGroup({
    Key? key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    required this.hadTextField,
    this.controllerTextField,
    required this.colorTheme,
    required this.showError,
    this.textFieldOption = 'Sim',
    this.textFieldLabel = 'Qual?',
    this.readOnly = true,
    this.fieldWidth = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: -10,
      children: options.map((option) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: option,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                groupValue: groupValue,
                activeColor: readOnly
                    ? colorTheme.indigo_primary_800
                    : colorTheme.grey_font_500,
                onChanged: onChanged,
              ),

              Transform.translate(
                offset: const Offset(-8, 0),
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.label10px!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorTheme.grey_font_700,
                      ),
                ),
              ),
              // Adiciona o TextField quando a opção "Sim" é selecionada
              if (hadTextField &&
                  option == textFieldOption &&
                  groupValue == textFieldOption)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: fieldWidth, // Largura do campo de texto
                    child: readOnly
                        ? IgnorePointer(
                            child: TextField(
                              controller: controllerTextField,
                              decoration: InputDecoration(
                                hintText: textFieldLabel,
                                hintStyle: TextStyle(
                                  color: colorTheme.grey_font_500,
                                ),
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                              ),
                            ),
                          )
                        : TextField(
                            controller: controllerTextField,
                            decoration: InputDecoration(
                              hintText: textFieldLabel,
                              hintStyle: TextStyle(
                                color: colorTheme.grey_font_500,
                              ),
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                            ),
                          ),
                  ),
                ),
              if (showError)
                Text(
                  'Campo obrigatório',
                  style: TextStyle(color: colorTheme.red_error_500),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
