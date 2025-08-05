import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceDataPage extends StatefulWidget {
  const ServiceDataPage({super.key});

  @override
  State<ServiceDataPage> createState() => _ServiceDataPageState();
}

class _ServiceDataPageState extends State<ServiceDataPage> {
  List<dynamic> services = [];

  final String baseUrl = 'http://192.168.1.3:8000'; // Your Laravel API base URL
  final String imageRoute = 'service-image'; // Laravel image route

  @override
  void initState() {
    super.initState();
    fetchServicesFromApi();
  }

  Future<void> fetchServicesFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    print("🟡 SharedPreferences user_id: $userId");

    if (userId == null) {
      print("❌ user_id not found in SharedPreferences");
      return;
    }

    final url = Uri.parse('$baseUrl/api/ServiceData?user_id=$userId');

    try {
      final response = await http.get(url);
      print("📡 API Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("✅ Response JSON: $jsonData");

        if (jsonData['status'] == true && jsonData['services'] != null) {
          setState(() {
            services = jsonData['services'];
          });
        } else {
          print("⚠️ No services found");
        }
      } else {
        print("❌ API error: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception during API call: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return services.isEmpty
        ? const Center(child: Text("No Services Found"))
        : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final item = services[index];

            // ✅ Safely get images string and convert to list
            final imagesString = (item['images'] ?? '').toString();
            List<String> imageList =
                imagesString
                    .split(',')
                    .where((img) => img.trim().isNotEmpty)
                    .toList();

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔳 Horizontal Scroll of Images
                    SizedBox(
                      height: 70,
                      child:
                          imageList.isNotEmpty
                              ? ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imageList.length,
                                itemBuilder: (context, i) {
                                  final imageFile = imageList[i].trim();
                                  final imageUrl =
                                      "$baseUrl/$imageRoute/$imageFile";

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imageUrl,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 70,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )
                              : const Text("No Images"),
                    ),

                    const SizedBox(height: 12),

                    // 📝 Title
                    Text(
                      item['service_type'] ?? 'No Type',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // 📄 Description
                    Text(item['description'] ?? 'No Description'),

                    const SizedBox(height: 4),

                    // 💰 Price
                    Text("Price: ₹${item['price'] ?? 'N/A'}"),
                  ],
                ),
              ),
            );
          },
        );
  }
}
