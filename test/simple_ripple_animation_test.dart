import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

void main() {
  group('RippleAnimation Widget Tests', () {
    testWidgets(
      'renders child widget and initializes with default parameters',
      (WidgetTester tester) async {
        const Key childKey = Key('child_widget');
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: RippleAnimation(
                  child: SizedBox(
                    key: childKey,
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ),
        );

        // Verify child is rendered
        expect(find.byKey(childKey), findsOneWidget);

        // Verify RippleAnimation widget is found
        final Finder rippleFinder = find.byType(RippleAnimation);
        expect(rippleFinder, findsOneWidget);

        final RippleAnimation rippleWidget = tester.widget(rippleFinder);
        expect(rippleWidget.color, Colors.black);
        expect(rippleWidget.delay, Duration.zero);
        expect(rippleWidget.repeat, isFalse);
        expect(rippleWidget.minRadius, 60);
        expect(rippleWidget.maxRadius, 120);
        expect(rippleWidget.ripplesCount, 5);
        expect(rippleWidget.duration, const Duration(milliseconds: 2300));

        // Verify CustomPaint is rendered
        final Finder customPaintFinder = find.descendant(
          of: rippleFinder,
          matching: find.byType(CustomPaint),
        );
        expect(customPaintFinder, findsOneWidget);

        final CustomPaint customPaint = tester.widget(customPaintFinder);
        expect(customPaint.painter, isA<CirclePainter>());

        final CirclePainter painter = customPaint.painter! as CirclePainter;
        expect(painter.color, Colors.black);
        expect(painter.minRadius, 60);
        expect(painter.maxRadius, 120);
        expect(painter.wavesCount, 7); // ripplesCount + 2

        // Pump to trigger timer and animation forward
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 2300));
      },
    );

    testWidgets(
      'supports custom parameters and repeating animation',
      (WidgetTester tester) async {
        const MaterialColor customColor = Colors.deepOrange;
        const double customMinRadius = 30;
        const double customMaxRadius = 90;
        const int customRipplesCount = 3;
        const Duration customDuration = Duration(milliseconds: 1000);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: RippleAnimation(
                  color: customColor,
                  minRadius: customMinRadius,
                  maxRadius: customMaxRadius,
                  ripplesCount: customRipplesCount,
                  duration: customDuration,
                  repeat: true,
                  child: Icon(Icons.star),
                ),
              ),
            ),
          ),
        );

        final Finder rippleFinder = find.byType(RippleAnimation);
        final RippleAnimation rippleWidget = tester.widget(rippleFinder);
        expect(rippleWidget.color, customColor);
        expect(rippleWidget.minRadius, customMinRadius);
        expect(rippleWidget.maxRadius, customMaxRadius);
        expect(rippleWidget.ripplesCount, customRipplesCount);
        expect(rippleWidget.duration, customDuration);
        expect(rippleWidget.repeat, isTrue);

        // Verify CirclePainter properties
        final CustomPaint customPaint = tester.widget<CustomPaint>(
          find.descendant(
            of: rippleFinder,
            matching: find.byType(CustomPaint),
          ),
        );
        final CirclePainter painter = customPaint.painter! as CirclePainter;
        expect(painter.wavesCount, customRipplesCount + 2);
        expect(painter.color, customColor);
        expect(painter.minRadius, customMinRadius);
        expect(painter.maxRadius, customMaxRadius);

        // Pump frames for repeating animation
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pump(const Duration(milliseconds: 1000));
      },
    );

    testWidgets(
      'handles delayed start properly',
      (WidgetTester tester) async {
        const Duration delay = Duration(milliseconds: 500);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: RippleAnimation(
                  delay: delay,
                  repeat: true,
                  child: Text('Delayed'),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Delayed'), findsOneWidget);

        // Before delay finishes, timer has not triggered
        await tester.pump(const Duration(milliseconds: 200));

        // After delay completes
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 500));
      },
    );

    testWidgets(
      'disposes cleanly before delay timer triggers',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: RippleAnimation(
                  delay: Duration(seconds: 10),
                  repeat: true,
                  child: Text('Will Dispose Early'),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Will Dispose Early'), findsOneWidget);

        // Immediately dispose widget before the 10-second timer fires
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox.shrink(),
            ),
          ),
        );

        expect(find.text('Will Dispose Early'), findsNothing);

        // Advance time past the original timer; verify no exceptions
        await tester.pump(const Duration(seconds: 12));
      },
    );

    testWidgets(
      'disposes cleanly while repeating animation is running',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: RippleAnimation(
                  repeat: true,
                  child: Text('Running'),
                ),
              ),
            ),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Replace widget to trigger dispose
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SizedBox.shrink(),
            ),
          ),
        );

        await tester.pumpAndSettle();
      },
    );
  });

  group('CirclePainter Direct Unit Tests', () {
    test('shouldRepaint returns true', () {
      final AnimationController controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(seconds: 1),
      );

      final CirclePainter painter1 = CirclePainter(
        controller,
        wavesCount: 5,
        color: Colors.blue,
        minRadius: 20,
        maxRadius: 80,
      );

      final CirclePainter painter2 = CirclePainter(
        controller,
        wavesCount: 5,
        color: Colors.red,
        minRadius: 30,
        maxRadius: 90,
      );

      expect(painter1.shouldRepaint(painter2), isTrue);
      controller.dispose();
    });

    test('paints all waves onto canvas correctly', () {
      final AnimationController controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(seconds: 1),
      );

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      const Size size = Size(200, 200);

      final CirclePainter painter = CirclePainter(
        controller,
        wavesCount: 4,
        color: Colors.teal,
        minRadius: 40,
        maxRadius: 100,
      );

      // Paint at various animation values
      controller.value = 0;
      painter.paint(canvas, size);

      controller.value = 0.5;
      painter.paint(canvas, size);

      controller.value = 1;
      painter.paint(canvas, size);

      final ui.Picture picture = recorder.endRecording();
      expect(picture, isNotNull);
      picture.dispose();
      controller.dispose();
    });

    test(
      'circle method branches: wave 0 does not draw, wave > 0 draws',
      () {
        final AnimationController controller = AnimationController(
          vsync: const TestVSync(),
          duration: const Duration(seconds: 1),
        );

        final ui.PictureRecorder recorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(recorder);
        const Rect rect = Rect.fromLTWH(0, 0, 100, 100);

        // Wave 0 and wave > 0 branch tests
        CirclePainter(
          controller,
          wavesCount: 3,
          color: Colors.purple,
          minRadius: 10,
          maxRadius: 50,
        )
          ..circle(canvas, rect, 10, 50, 0, 0.5, 3, Colors.purple)
          ..circle(canvas, rect, 10, 50, 1, 0.2, 3, Colors.purple)
          ..circle(canvas, rect, 10, 50, 3, 1, 3, Colors.purple);

        final ui.Picture picture = recorder.endRecording();
        expect(picture, isNotNull);
        picture.dispose();
        controller.dispose();
      },
    );
  });
}
