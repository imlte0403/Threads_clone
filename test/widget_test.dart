import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thread_clone/features/auth/repository/auth_repository.dart';
import 'package:thread_clone/main.dart';

void main() {
  testWidgets('App initializes without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(AuthenticationRepository()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
