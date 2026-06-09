import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(const DayFlowApp());
    await tester.pump();
    expect(find.text('DayFlow'), findsOneWidget);
  });
}
