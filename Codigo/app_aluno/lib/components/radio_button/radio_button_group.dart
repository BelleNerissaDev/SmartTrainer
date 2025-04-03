import 'package:SmartTrainer/app_theme.dart';
import 'package:SmartTrainer/fonts.dart';
import 'package:flutter/material.dart';

class CustomRadioButtonGroup extends StatefulWidget {
  final MyColorFamily colorTheme;
  final List<String> options;
  final String? groupValue;
  // Input de Qual, caso a opção "Sim" seja selecionada
  final bool hadTextField;
  final TextEditingController? controllerTextField; 
  final bool showError;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const CustomRadioButtonGroup({
    Key? key,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    required this.hadTextField,
    this.controllerTextField,
    required this.colorTheme,
    required this.showError,
    this.enabled = true,
  }) : super(key: key);

  @override
  _CustomRadioButtonGroupState createState() => _CustomRadioButtonGroupState();
}

class _CustomRadioButtonGroupState extends State<CustomRadioButtonGroup> {
  @override
  Widget build(BuildContext context) {
    // Acessando o colorTheme do widget
    final colorTheme = widget.colorTheme;
    final showError = widget.showError;
    final _controllerTextField = widget.controllerTextField;

    return Wrap(
      spacing: 5,
      runSpacing: -10,
      children: widget.options.map((option) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IgnorePointer(
                // Adiciona IgnorePointer para desabilitar interações
                ignoring: !widget.enabled,
                child: Radio<String>(
                  value: option,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  groupValue: widget.groupValue,
                  activeColor: colorTheme.indigo_primary_800,
                  onChanged:
                      widget.enabled ? widget.onChanged : null, // Condicional
                ),
              ),
              Transform.translate(
                offset: const Offset(-8, 0),
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.label10px!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorTheme.gray_700,
                      ),
                ),
              ),
              // Adiciona o TextField quando a opção "Sim" é selecionada
              if (widget.hadTextField &&
                  option == 'Sim' &&
                  widget.groupValue == 'Sim')
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: 100, // Largura do campo de texto
                    child: IgnorePointer(
                      // Desabilita o TextField se não estiver habilitado
                      ignoring: !widget.enabled,
                      child: TextField(
                        controller: _controllerTextField,
                        decoration: InputDecoration(
                          hintText: 'Qual?',
                          hintStyle: TextStyle(
                            color: colorTheme.gray_500,
                          ),
                          isDense: true, // Ajusta a densidade do campo de texto
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                        ),
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
