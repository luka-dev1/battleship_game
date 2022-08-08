import 'package:battle/main.dart';
import 'package:battle/screens/home/widget_header.dart';
import 'package:battle/screens/home/widget_menu.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Home Screen should", () {
    testWidgets("show header", (tester) async {
      await tester.pumpWidget(const MyApp());
      var header = find.byType(Header);
      expect(header, findsOneWidget);
    });

    testWidgets("show main menu", (tester) async {
      await tester.pumpWidget(const MyApp());
      var menu = find.byType(MainMenu);
      expect(menu, findsOneWidget);
    });
  });
}
