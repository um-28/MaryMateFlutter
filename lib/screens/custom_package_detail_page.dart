// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class CustomPackageDetailPage extends StatefulWidget {
//   final int packageId;

//   const CustomPackageDetailPage({super.key, required this.packageId});

//   @override
//   State<CustomPackageDetailPage> createState() => _CustomPackageDetailPageState();
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
//         Uri.parse("http://192.168.1.6:8000/api/showCustomPackageData/${widget.packageId}"),
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         setState(() {
//           customPackage = jsonData['custom_package'];
//           services = jsonData['services'];
//           predefinedPackages = jsonData['predefined_packages'];
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load package details');
//       }
//     } catch (e) {
//       print("Error: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Package Details")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : customPackage == null
//               ? const Center(child: Text("No data found"))
//               : SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Package Name: ${customPackage!['package_name']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Text("Description: ${customPackage!['description']}"),
//                       const SizedBox(height: 8),
//                       Text("Total Cost: ₹${customPackage!['total_cost']}"),
//                       const Divider(height: 24),
//                       Text("Services", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       ...services.map((service) => ListTile(
//                             title: Text(service['service_type'] ?? 'Unnamed'),
//                             subtitle: Text("Vendor: ${service['vendor']['name'] ?? 'N/A'}"),
//                           )),
//                       const Divider(height: 24),
//                       Text("Predefined Packages", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       ...predefinedPackages.map((pkg) => ListTile(
//                             title: Text(pkg['package_name'] ?? 'Unnamed'),
//                             subtitle: Text("Vendor: ${pkg['vendor']['name'] ?? 'N/A'}"),
//                           )),
//                     ],
//                   ),
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomPackageDetailPage extends StatefulWidget {
  final int packageId;

  const CustomPackageDetailPage({super.key, required this.packageId});

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
          customPackage = jsonData['data']; // Custom Package Info
          services = jsonData['0'] ?? []; // Services List
          predefinedPackages = jsonData['1'] ?? []; // Predefined Packages
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
                      "📦 Package Name: ${customPackage!['package_name']}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("📝 Description: ${customPackage!['description']}"),
                    const SizedBox(height: 8),
                    Text("💰 Total Cost: ₹${customPackage!['totalcost']}"),
                    const SizedBox(height: 8),
                    Text("🧾 Service IDs: ${customPackage!['service_ids']}"),
                    Text("🧾 Package IDs: ${customPackage!['package_ids']}"),
                    const Divider(height: 30),

                    // 🔹 Services Section
                    Text(
                      "🛠️ Included Services",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...services.map(
                      (service) => Card(
                        elevation: 3,
                        child: ListTile(
                          title: Text(
                            service['service_type'] ?? 'No Service Name',
                          ),
                          subtitle: Text(
                            "Vendor: ${service['vendor']['business_name'] ?? 'N/A'}\n"
                            "City: ${service['vendor']['city']}, State: ${service['vendor']['state']}",
                          ),
                          trailing: Text("₹${service['price']}"),
                        ),
                      ),
                    ),

                    const Divider(height: 30),

                    // 🔹 Predefined Packages Section
                    if (predefinedPackages.isNotEmpty) ...[
                      Text(
                        "🎁 Predefined Packages",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...predefinedPackages.map(
                        (pkg) => Card(
                          elevation: 3,
                          child: ListTile(
                            title: Text(pkg['package_name'] ?? 'No Name'),
                            subtitle: Text(
                              "Vendor: ${pkg['vendor']['business_name'] ?? 'N/A'}\n"
                              "Description: ${pkg['description']}",
                            ),
                            trailing: Text("₹${pkg['price']}"),
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
