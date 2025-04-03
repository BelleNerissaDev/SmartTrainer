import 'package:SmartTrainer/config/theme_provider.dart';
import 'package:SmartTrainer/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownInput<T> extends StatelessWidget {
  final T? selectedValue;
  final String label;
  final double width;
  final List<T> items;
  final Function(T?) onSelected;
  final TextEditingController dropdownController;
  final Color? backgroundColor;
  final double paddingVertical;
  final double paddingHorizontal;
  final bool showErrors;
  final List<ErrorMessage> errors;
  final bool enabled;

  const DropdownInput(
      {Key? key,
      required this.width,
      required this.selectedValue,
      required this.label,
      required this.items,
      required this.onSelected,
      required this.dropdownController,
      this.backgroundColor,
      this.paddingVertical = 8.0,
      this.paddingHorizontal = 8.0,
      this.showErrors = false,
      this.enabled = true,
      this.errors = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal, vertical: paddingVertical),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorTheme.white_onPrimary_100,
      ),
      child: Column(
        children: [
          IgnorePointer(
            ignoring: !enabled, // Ignora interações se não estiver habilitado
            child: DropdownButtonFormField<T>(
              value: selectedValue,
              decoration: InputDecoration(
                labelText: label,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: showErrors
                        ? colorTheme.red_error_500
                        : colorTheme.gray_500,
                    width: 2.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: showErrors
                        ? colorTheme.red_error_500
                        : colorTheme.gray_500,
                    width: 2.0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: showErrors
                        ? colorTheme.red_error_500
                        : colorTheme.indigo_primary_500,
                    width: 2.0,
                  ),
                ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                color: colorTheme.gray_700,
              ),
              dropdownColor: backgroundColor ?? colorTheme.white_onPrimary_100,
              style: TextStyle(color: colorTheme.gray_700),
              items: items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: TextStyle(color: colorTheme.gray_700),
                  ),
                );
              }).toList(),
              onChanged: (T? newValue) {
                enabled ? onSelected(newValue) : null;
              },
            ),
          ),
          if (errors.isNotEmpty && showErrors)
            for (final error in errors)
              Text(
                error.message,
                style: TextStyle(
                  color: error.error
                      ? colorTheme.red_error_500
                      : colorTheme.green_sucess_500,
                ),
              ),
        ],
      ),
    );
  }
}
