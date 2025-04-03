import 'package:SmartTrainer_Personal/app_theme.dart';
import 'package:SmartTrainer_Personal/components/inputs/dropdown_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('DropdownInput Widget Tests', () {
    testWidgets('renders DropdownInput correctly and responds to selection',
        (WidgetTester tester) async {
      String? selectedValue;
      final TextEditingController dropdownController = TextEditingController();

      // Lista de itens para o Dropdown
      final items = ['Item 1', 'Item 2', 'Item 3'];

      await tester.pumpWidget(createWidgetUnderTest(
        child: Builder(builder: (context) {
          var colorTheme = CustomTheme.colorFamilyLight;
          return DropdownInput<String>(
            width: 200,
            selectedValue: selectedValue,
            label: 'Selecione um item',
            items: items,
            onSelected: (value) {
              selectedValue = value;
            },
            dropdownController: dropdownController,
            backgroundColor: colorTheme.white_onPrimary_100,
          );
        }),
      ));

      expect(find.text('Selecione um item'), findsOneWidget);

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);

      await tester.tap(find.text('Item 2').last);
      await tester.pumpAndSettle();

      expect(selectedValue, 'Item 2');
    });
  });
}
