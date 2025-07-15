import 'package:flutter/material.dart';

class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Detail')),
      body: const Center(child: Text('Service Detail Page')),
    );
  }
}
