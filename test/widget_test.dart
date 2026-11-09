import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_wise/main.dart';
import 'package:route_wise/models/route_models.dart';
import 'package:route_wise/services/spk_calculator.dart';

void main() {
  testWidgets('WelcomeScreen renders LOGIN and SIGN UP actions',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('SIGN UP'), findsOneWidget);
    expect(
      find.text(
        "Maximize your fleet's productivity with our optimized route selection!",
      ),
      findsOneWidget,
    );
  });

  testWidgets('Tapping LOGIN navigates to Login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember Me'), findsOneWidget);
  });

  test('SpkCalculator ranks alternatives accurately using SAW method', () {
    const candidates = [
      SpkAlternative(
        id: '1',
        storeName: 'Toko Jauh Mahal',
        destination: 'Lokasi A',
        distanceKm: 10.0,
        itemCount: 100,
        estimatedCostRp: 100000,
        travelTimeMinutes: 45,
      ),
      SpkAlternative(
        id: '2',
        storeName: 'Toko Dekat Banyak Permintaan',
        destination: 'Lokasi B',
        distanceKm: 2.0,
        itemCount: 500,
        estimatedCostRp: 30000,
        travelTimeMinutes: 10,
      ),
    ];

    final ranked = SpkCalculator.rankBySaw(candidates);
    expect(ranked.length, 2);
    expect(ranked.first.storeName, 'Toko Dekat Banyak Permintaan');
    expect(ranked.first.sawScore, closeTo(1.0, 0.001));
    expect(ranked.last.sawScore, lessThan(ranked.first.sawScore));
  });
}
