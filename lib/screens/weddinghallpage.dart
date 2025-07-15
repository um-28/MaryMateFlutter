import 'package:flutter/material.dart';
import '../screens/wedding_service_api.dart';
import '../screens/wedding_service_model.dart';

class WeddingHallPage extends StatefulWidget {
  const WeddingHallPage({super.key});

  @override
  State<WeddingHallPage> createState() => _WeddingHallPageState();
}

class _WeddingHallPageState extends State<WeddingHallPage> {
  late Future<List<WeddingService>> _futureServices;

  @override
  void initState() {
    super.initState();
    _futureServices = WeddingServiceApi.fetchWeddingHalls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wedding Halls"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<WeddingService>>(
        future: _futureServices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Wedding Halls Available"));
          } else {
            final services = snapshot.data!;
            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final item = services[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "assets/images/${item.images}", // local asset
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item.serviceType,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(item.description),
                    trailing: Text(
                      "₹${item.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
