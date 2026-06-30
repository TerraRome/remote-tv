import 'package:flutter_test/flutter_test.dart';
import 'package:remote/app/bootstrap/app_bootstrap.dart';

void main() {
  testWidgets('App boots without error', (WidgetTester tester) async {
    await tester.pumpWidget(const AppBootstrap());
    expect(find.byType(AppBootstrap), findsOneWidget);
  });
}
