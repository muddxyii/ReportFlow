import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(MaterialApp(
    theme: AppTheme.theme,
    home: const HomePage(),
  ));
}