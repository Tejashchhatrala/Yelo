import 'package:YELO/src/home/providers/user_interactions_provider.dart';
import 'package:YELO/src/home/views/user_home_view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileView displays liked and bookmarked tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          likedOpportunitiesProvider.overrideWith((ref) => Stream.value([])),
          bookmarkedOpportunitiesProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          home: ProfileView(onAppoinment: () {}),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Liked'), findsOneWidget);
    expect(find.text('Bookmarked'), findsOneWidget);

    expect(find.text('No opportunities yet.'), findsNWidgets(2));
  });
}
