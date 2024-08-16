// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.



import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tkd_connect/main.dart';
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(prefs: prefs,));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  // late LoginProvider authService=LoginProvider("appState");
  // group('Login Tests', () {
  //   test('Mobile Number is valid', () async {
  //    await authService.isMobileValide("9503334903");
  //     expect(authService.isMobileNumberValid, isTrue);
  //   }
  //   );
  //
  //   test('Mobile Number is valid', () async {
  //     await authService.isMobileValide("950333490300");
  //     expect(authService.isMobileNumberValid, false);
  //   }
  //   );
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //
  //   // test('Login fails with incorrect credentials', () async {
  //   //   final result = await authService.callOtp(globalContext, '9503334903');
  //   //   expect(result, isFalse);
  //   // });
  //   //
  //   // test('Login throws exception when username is empty', () {
  //   //   expect(() => authService.login('', 'pass'), throwsException);
  //   // });
  //   //
  //   // test('Login throws exception when password is empty', () {
  //   //   expect(() => authService.login('user', ''), throwsException);
  //   // });
  // });


  // testWidgets("Login Check ", (WidgetTester tester)async{
  //
  //   tester.pumpWidget(MaterialApp(home: LoginScreen(),));
  //
  //   final mobileNumber =  find.byKey(Key('mobileNumber'));
  //   final loginButton = find.byKey(Key('LoginButton'));
  //
  //   await tester.enterText(mobileNumber, 'invalidUser');
  //
  //   await tester.tap(loginButton);
  //
  //   await tester.pump();
  //
  //   // Assert: Verify that the error message is displayed
  //   expect(find.text('Invalid username or password'), findsOneWidget);
  //
  //
  // });




}
