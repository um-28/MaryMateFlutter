import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MarryMateApp());
}

class MarryMateApp extends StatelessWidget {
  const MarryMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marry Mate',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
