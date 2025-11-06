import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:my_awesome_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('Full Sign Up and Sign In flow', (WidgetTester tester) async {
      print('Starting app...');
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final String email =
          'test${DateTime.now().millisecondsSinceEpoch}@test.com';
      const String password = 'password123';

      print('Using email: $email');

      final Finder emailField = find.byKey(const Key('usernameField'));
      final Finder passwordField = find.byKey(const Key('passwordField'));
      final Finder signUpButton = find.byKey(const Key('signUpButton'));
      final Finder signInButton = find.byKey(const Key('signInButton'));

      print('Finding widgets for Sign Up...');
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(signUpButton, findsOneWidget);

      print('Entering credentials for Sign Up...');
      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);

      print('Tapping Sign Up button...');
      await tester.tap(signUpButton);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      print('Entering credentials for Sign In...');
      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);

      print('Tapping Sign In button...');
      await tester.tap(signInButton);

      await tester.pumpAndSettle(const Duration(seconds: 5));

      print('Verifying navigation to home screen...');

      final Finder newWordButton = find.byKey(const Key('newWordButton'));
      expect(newWordButton, findsOneWidget);

      expect(signInButton, findsNothing);

      print('Auth flow test passed!');
    });
  });
}
