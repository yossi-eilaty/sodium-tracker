import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:frontend/main.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/portion_provider.dart';
import 'package:frontend/providers/intake_provider.dart';

void main() {
  testWidgets('Login screen is shown on launch', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => PortionProvider()),
          ChangeNotifierProvider(create: (_) => IntakeProvider()),
        ],
        child: const SodiumTrackerApp(),
      ),
    );

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
