import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tkd_connect/screen/create_post/post_load.dart';
import 'package:tkd_connect/provider/dashboard/post_provider.dart';

void main() {
  testWidgets('PostLoadScreen renders without layout crash',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider(
              create: (_) => PostLoadProvider(),
              child: const Scaffold(
                body: PostLoadScreen(),
              ),
            ),
          ),
        );

        expect(find.byType(ListView), findsOneWidget);
      });

  testWidgets('Mic toggles start and stop',
          (WidgetTester tester) async {

        final provider = PostLoadProvider();

        await tester.pumpWidget(
          MaterialApp(
            home: ChangeNotifierProvider.value(
              value: provider,
              child: const Scaffold(body: PostLoadScreen()),
            ),
          ),
        );

        final mic = find.byIcon(Icons.mic);
        await tester.tap(mic);
        await tester.pump();

        expect(provider.isListening, true);

        await tester.tap(find.byIcon(Icons.stop));
        await tester.pump();

        expect(provider.isListening, false);
      });
}
