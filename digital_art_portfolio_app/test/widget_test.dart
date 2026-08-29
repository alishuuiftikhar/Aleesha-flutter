import 'package:flutter_test/flutter_test.dart';
import 'package:digital_art_portfolio_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DigitalArtPortfolioApp());
    expect(find.byType(DigitalArtPortfolioApp), findsOneWidget);
  });
}
