// This is a basic Flutter widget test.
import 'package:flutter_test/flutter_test.dart';
import 'package:employee_managment_app/main.dart';

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EmployeeManagementApp());

    // Verify that dashboard title is present.
    expect(find.text('CORPORATE DASHBOARD'), findsOneWidget);
  });
}
