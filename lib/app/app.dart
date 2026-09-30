import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../screens/home_screen.dart';

class SentinelXApp extends StatelessWidget {
  const SentinelXApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'SentinelX',
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: AppColors.background, colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary)),
    home: const HomeScreen(),
  );
}
