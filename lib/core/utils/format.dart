import 'package:intl/intl.dart';

String formatCurrency(num value) {
  final formatter = NumberFormat.currency(symbol: '\$');
  return formatter.format(value);
}
