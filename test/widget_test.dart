import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_app/main.dart';

void main() {
  testWidgets(
    'Tela de configurações abre corretamente',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const SharedPreferencesApp(),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Configurações'),
        findsOneWidget,
      );

      expect(
        find.text('Tamanho da fonte'),
        findsOneWidget,
      );

      expect(
        find.text('Receber Notificações'),
        findsOneWidget,
      );

      expect(
        find.text('Limpar Configurações'),
        findsOneWidget,
      );
    },
  );
}
