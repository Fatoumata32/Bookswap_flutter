// Basic Flutter widget tests for BookSwap app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bookswap/main.dart';

void main() {
  testWidgets('BookSwap app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: BookSwapApp()));

    // Verify that the app builds without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
