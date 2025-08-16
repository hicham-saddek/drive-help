import 'package:flutter/material.dart';
import '../../core/utils/app_strings.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text(AppStrings.expenses));
  }
}
