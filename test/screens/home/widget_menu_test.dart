import 'package:battle/main.dart';
import 'package:battle/widgets/buttons/button_big.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Main Menu should", () {
    testWidgets("show Play text", (tester) async {
      await tester.pumpWidget(const MyApp());
      var text = find.text("Play");
      expect(text, findsOneWidget);
    });

    testWidgets("show two big buttons", (tester) async {
      await tester.pumpWidget(const MyApp());
      var buttons = find.byType(BigButton);
      expect(buttons, findsNWidgets(2));
    });
  });
}
