import 'package:flutter/material.dart';
import '../../core/utils/app_strings.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text(AppStrings.dashboard));
  }
}
