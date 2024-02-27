// This is a basic Flutter widget test.

// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uber_eats/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget( SplashScreen());

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
}

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uber_eats/Auth/UI/Login_UI.dart';
// import 'package:uber_eats/main.dart';
// import 'package:uber_eats/onboarding/onboarding.dart';

// // Mock classes
// class MockSharedPreferences extends Mock implements SharedPreferences {}
// class MockFirebaseAuth extends Mock implements FirebaseAuth {}
// // class MockPermissionHandler extends Mock implements PermissionHandler {}
// class MockUser extends Mock implements User {}
// void main() {
//   // Test for SplashScreen widget
//   group('SplashScreen Widget', () {
//     // Mock objects
//     late MockSharedPreferences mockSharedPreferences;
//     late MockFirebaseAuth mockFirebaseAuth;
//     // late MockPermissionHandler mockPermissionHandler;

//     setUp(() {
//       mockSharedPreferences = MockSharedPreferences();
//       mockFirebaseAuth = MockFirebaseAuth();
//       // mockPermissionHandler = MockPermissionHandler();
//     });

//     testWidgets('First install redirects to OnboardingOverview', (WidgetTester tester) async {
//       when(mockSharedPreferences.getBool('isFirstInstall')).thenReturn(true);
//       when(mockFirebaseAuth.currentUser).thenReturn(null);
//       // when(mockPermissionHandler.location).thenAnswer((_) async => PermissionStatus.denied);

//       await tester.pumpWidget(
//         MaterialApp(
//           home: SplashScreen(),
//         ),
//       );

//       // Wait for the animations and delays to complete
//       await tester.pumpAndSettle(Duration(seconds: 4));

//       // Verify that OnboardingOverview page is pushed
//       expect(find.byType(OnboardingOverview), findsOneWidget);
//     });

//     testWidgets('User logged in redirects to Hometest', (WidgetTester tester) async {
//       when(mockSharedPreferences.getBool('isFirstInstall')).thenReturn(false);
//       when(mockFirebaseAuth.currentUser).thenReturn(MockUser());
//       // when(mockPermissionHandler.location).thenAnswer((_) async => PermissionStatus.granted);

//       await tester.pumpWidget(
//         MaterialApp(
//           home: SplashScreen(),
//         ),
//       );

//       // Wait for the animations and delays to complete
//       await tester.pumpAndSettle(Duration(seconds: 4));

//       // Verify that Hometest page is pushed
//       expect(find.byType(Hometest), findsOneWidget);
//     });

//     testWidgets('Permission granted redirects to login_page', (WidgetTester tester) async {
//       when(mockSharedPreferences.getBool('isFirstInstall')).thenReturn(false);
//       when(mockFirebaseAuth.currentUser).thenReturn(null);
//       // when(mockPermissionHandler.location).thenAnswer((_) async => PermissionStatus.granted);

//       await tester.pumpWidget(
//         MaterialApp(
//           home: SplashScreen(),
//         ),
//       );

//       // Wait for the animations and delays to complete
//       await tester.pumpAndSettle(Duration(seconds: 4));

//       // Verify that login_page is pushed
//       expect(find.byType(login_page), findsOneWidget);
//     });

//     // Add more test cases as needed
//   });
// }
