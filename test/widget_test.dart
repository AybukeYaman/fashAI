import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fashai/main.dart';

void main() {
  testWidgets('shows onboarding screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    expect(find.text('Your AI Stylist'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
