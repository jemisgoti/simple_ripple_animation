import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

void main() {
  testWidgets(
    'Demo app loads, renders ripple animation, and switches presets',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      // Verify title and ripple animation presence
      expect(find.text('Simple Ripple Animation'), findsOneWidget);
      expect(find.byType(RippleAnimation), findsOneWidget);

      // Verify preset chips exist
      expect(find.text('Avatar'), findsOneWidget);
      expect(find.text('Call'), findsOneWidget);
      expect(find.text('Voice'), findsOneWidget);
      expect(find.text('Radar'), findsOneWidget);
      expect(find.text('Alert'), findsOneWidget);

      // Tap Call preset
      await tester.tap(find.text('Call'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify Call icon appears
      expect(find.byIcon(Icons.phone_in_talk_rounded), findsOneWidget);

      // Tap Voice preset
      await tester.tap(find.text('Voice'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);

      // Tap theme toggle icon
      final Finder themeToggleFinder = find.byTooltip('Toggle Theme');
      expect(themeToggleFinder, findsOneWidget);
      await tester.tap(themeToggleFinder);
      await tester.pump();

      // Tap Copy button
      final Finder copyButtonFinder = find.text('Copy');
      expect(copyButtonFinder, findsOneWidget);
      await tester.tap(copyButtonFinder, warnIfMissed: false);
      await tester.pump();

      // Advance animation smoothly
      await tester.pump(const Duration(milliseconds: 500));
    },
  );
}
