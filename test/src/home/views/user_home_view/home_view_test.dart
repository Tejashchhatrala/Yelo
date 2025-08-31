import 'package:YELO/src/home/models/opportunity_model.dart';
import 'package:YELO/src/home/providers/opportunity_provider.dart';
import 'package:YELO/src/home/views/user_home_view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeView displays a list of opportunities',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          opportunityProvider.overrideWith(
            (ref) => Stream.value([
              Opportunity(
                id: '1',
                authorId: '1',
                title: 'Test Opportunity',
                description: 'Test Description',
                imageUrl: 'https://via.placeholder.com/150',
                timestamp: DateTime.now(),
              ),
            ]),
          ),
        ],
        child: const MaterialApp(
          home: HomeView(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('YELO'), findsOneWidget);
    expect(find.text('Test Opportunity'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });
}
