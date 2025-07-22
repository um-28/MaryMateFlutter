// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class CustomPackageDetailPage extends StatefulWidget {
//   final int packageId;

//   const CustomPackageDetailPage({super.key, required this.packageId});

//   @override
//   State<CustomPackageDetailPage> createState() =>
//       _CustomPackageDetailPageState();
// }

// class _CustomPackageDetailPageState extends State<CustomPackageDetailPage> {
//   Map<String, dynamic>? customPackage;
//   List<dynamic> services = [];
//   List<dynamic> predefinedPackages = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchPackageDetails();
//   }

//   Future<void> fetchPackageDetails() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "http://192.168.1.6:8000/api/showCustomPackageData/${widget.packageId}",
//         ),
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         setState(() {
//           customPackage = jsonData['data']; // Custom Package Info
//           services = jsonData['0'] ?? []; // Services List
//           predefinedPackages = jsonData['1'] ?? []; // Predefined Packages
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load package details');
//       }
//     } catch (e) {
//       print("Error fetching package: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Custom Package Details")),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : customPackage == null
//               ? const Center(child: Text("No data found"))
//               : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "📦 Package Name: ${customPackage!['package_name']}",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text("📝 Description: ${customPackage!['description']}"),
//                     const SizedBox(height: 8),
//                     Text("💰 Total Cost: ₹${customPackage!['totalcost']}"),
//                     const SizedBox(height: 8),
//                     Text("🧾 Service IDs: ${customPackage!['service_ids']}"),
//                     Text("🧾 Package IDs: ${customPackage!['package_ids']}"),
//                     const Divider(height: 30),

//                     // 🔹 Services Section
//                     Text(
//                       "🛠️ Included Services",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ...services.map(
//                       (service) => Card(
//                         elevation: 3,
//                         child: ListTile(
//                           title: Text(
//                             service['service_type'] ?? 'No Service Name',
//                           ),
//                           subtitle: Text(
//                             "Vendor: ${service['vendor']['business_name'] ?? 'N/A'}\n"
//                             "City: ${service['vendor']['city']}, State: ${service['vendor']['state']}",
//                           ),
//                           trailing: Text("₹${service['price']}"),
//                         ),
//                       ),
//                     ),

//                     const Divider(height: 30),

//                     // 🔹 Predefined Packages Section
//                     if (predefinedPackages.isNotEmpty) ...[
//                       Text(
//                         "🎁 Predefined Packages",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       ...predefinedPackages.map(
//                         (pkg) => Card(
//                           elevation: 3,
//                           child: ListTile(
//                             title: Text(pkg['package_name'] ?? 'No Name'),
//                             subtitle: Text(
//                               "Vendor: ${pkg['vendor']['business_name'] ?? 'N/A'}\n"
//                               "Description: ${pkg['description']}",
//                             ),
//                             trailing: Text("₹${pkg['price']}"),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomPackageDetailPage extends StatefulWidget {
  final int packageId;

  const CustomPackageDetailPage({
    super.key,
    required this.packageId,
    required packageData,
  });

  @override
  State<CustomPackageDetailPage> createState() =>
      _CustomPackageDetailPageState();
}

class _CustomPackageDetailPageState extends State<CustomPackageDetailPage> {
  Map<String, dynamic>? customPackage;
  List<dynamic> services = [];
  List<dynamic> predefinedPackages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPackageDetails();
  }

  Future<void> fetchPackageDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://192.168.1.6:8000/api/showCustomPackageData/${widget.packageId}",
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          customPackage = jsonData['data'];
          services = jsonData['0'] ?? [];
          predefinedPackages = jsonData['1'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load package details');
      }
    } catch (e) {
      print("Error fetching package: $e");
      setState(() => isLoading = false);
    }
  }

  Widget buildImageSlider(String? imagesString, String folder) {
    if (imagesString == null || imagesString.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 100);
    }

    List<String> imageList = imagesString.split(',');

    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          final imageName = imageList[index].trim();
          final imageUrl = "http://192.168.1.6:8000/$folder/$imageName";
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (_) => Dialog(
                      child: InteractiveViewer(
                        child: Image.network(imageUrl, fit: BoxFit.contain),
                      ),
                    ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom Package Details")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : customPackage == null
              ? const Center(child: Text("No data found"))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Package Name: ${customPackage!['package_name']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Description: ${customPackage!['description']}"),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Total Cost: ₹${customPackage!['totalcost']}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 10, 10, 10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔸 Included Services
                    Text(
                      "Included Services",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...services.map(
                      (service) => Card(
                        color: const Color(0xFFFFF3E0), // light orange tone
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service['service_type'] ?? 'No Service Name',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(service['description'] ?? "No Description"),
                              const SizedBox(height: 6),
                              Text(
                                "₹${service['price']}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              buildImageSlider(
                                service['images'],
                                'service-image',
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange,
                                  ),
                                  onPressed: () {},
                                  child: const Text("Select"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const Divider(height: 30),

                    // 🔸 Predefined Packages
                    if (predefinedPackages.isNotEmpty) ...[
                      Text(
                        "Predefined Packages",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...predefinedPackages.map(
                        (pkg) => Card(
                          color: const Color(0xFFFFF3E0), // same background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pkg['package_name'] ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(pkg['description'] ?? 'No Description'),
                                const SizedBox(height: 6),
                                Text(
                                  "₹${pkg['price']}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                buildImageSlider(
                                  pkg['images'],
                                  'package-image',
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrange,
                                    ),
                                    onPressed: () {},
                                    child: const Text("Select"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }
}
