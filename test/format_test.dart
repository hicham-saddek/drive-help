import 'package:flutter_test/flutter_test.dart';
import 'package:roadtrip_sidekick/core/utils/format.dart';

void main() {
  test('formatCurrency formats USD correctly', () {
    expect(formatCurrency(12.5), '\$12.50');
  });
}
