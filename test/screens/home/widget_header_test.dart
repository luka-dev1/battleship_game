import 'package:battle/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Header should show text BATTLESHIPS!", (tester) async {
    await tester.pumpWidget(const MyApp());
    var text = find.text("BATTLESHIPS!");
    expect(text, findsOneWidget);
  });
}
