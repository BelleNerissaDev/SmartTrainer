import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:SmartTrainer_Personal/pages/widgets/loading_page.dart';

void main() {
  testWidgets('displays CircularProgressIndicator while authenticating',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoadingPage(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
