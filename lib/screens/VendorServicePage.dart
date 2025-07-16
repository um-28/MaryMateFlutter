import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/service_model.dart';

class VendorServicePage extends StatefulWidget {
  final int vendorId;

  const VendorServicePage({super.key, required this.vendorId});

  @override
  State<VendorServicePage> createState() => _VendorServicePageState();
}

class _VendorServicePageState extends State<VendorServicePage> {
  List<VendorService> services = [];
  bool isLoading = true;

  Future<void> fetchVendorServices() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              'http://192.168.1.7:8000/api/services/${widget.vendorId}',
            ),
            headers: {
              'Accept': 'application/json',
              // 'Content-Type': 'application/json',
              // 'Access-Control-Allow-Origin': '*',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          final List data = jsonData['data'];
          services = data.map((s) => VendorService.fromJson(s)).toList();
        }
      }
    } catch (e) {
      print('Error fetching services: $e');
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchVendorServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vendor Services")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : services.isEmpty
              ? const Center(child: Text("No services found."))
              : ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    margin: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.serviceType,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(service.description),
                          const SizedBox(height: 8),
                          Text(
                            "₹ ${service.price}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          service.images.isNotEmpty
                              ? SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: service.images.length,
                                  itemBuilder: (context, imgIndex) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          service.images[imgIndex],
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                              : const Text("No images available."),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
