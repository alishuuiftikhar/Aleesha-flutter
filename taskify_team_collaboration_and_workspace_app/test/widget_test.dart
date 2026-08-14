import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskify_team_collaboration_and_workspace_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskifyApp());
    expect(find.text('TASKIFY'), findsOneWidget);
  });
}
