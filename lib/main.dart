import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salman_services/utilities/constants/app_color.dart';
import 'package:salman_services/views/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'خدمات عامة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
        useMaterial3: true,
      ),
     home:Home()
    );
  }
}

