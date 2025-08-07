import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import '../vendor/AddServiceDatePage.dart';
import '../vendor/TrashDataPage.dart';

class ServiceDataPage extends StatefulWidget {
  const ServiceDataPage({super.key});

  @override
  State<ServiceDataPage> createState() => _ServiceDataPageState();
}

class _ServiceDataPageState extends State<ServiceDataPage> {
  List<dynamic> services = [];
  List<dynamic> filteredServices = [];
  bool isLoading = true;
  Map<int, bool> expandedDescriptions = {};

  final TextEditingController _searchController = TextEditingController();
  final String baseUrl = 'http://192.168.1.9:8000';
  final String imageRoute = 'service-image';

  @override
  void initState() {
    super.initState();
    // fetchServicesFromApi();
    fetchServiceData();
  }

  Future<void> fetchServiceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('$baseUrl/api/ServiceData?user_id=$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true && jsonData['services'] != null) {
          setState(() {
            services = jsonData['services'];
            filteredServices = List.from(services);
          });
        }
      }
    } catch (e) {
      print("Exception during API call: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterServices() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredServices =
          services
              .where(
                (item) => item['service_type']
                    .toString()
                    .toLowerCase()
                    .contains(query),
              )
              .toList();
    });
  }

  void _resetSearch() {
    _searchController.clear();
    setState(() {
      filteredServices = List.from(services);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Search services...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _filterServices,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Search"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _resetSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Reset"),
              ),
            ],
          ),
        ),

        // 📋 Title and Action Buttons Below
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Services Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // ⬇ Add & Trash Buttons
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 6.0, bottom: 12.0),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddServiceDataPage(),
                    ),
                  ).then((value) {
                    if (value == true) {
                      fetchServiceData(); // your function to reload data
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrashDataPage(),
                    ),
                  ).then((value) {
                    if (value == true) {
                      fetchServiceData();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 238, 98, 98),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Trash Data'),
              ),
            ],
          ),
        ),

        // 🧾 Table
        Expanded(
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredServices.isEmpty
                  ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No Services Found"),
                  )
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 1300),
                            child: DataTable(
                              headingRowHeight: 56,
                              dataRowMinHeight: 120,
                              dataRowMaxHeight: 120,
                              columnSpacing: 24,
                              headingRowColor: MaterialStateProperty.all(
                                Colors.grey[200],
                              ),
                              columns: const [
                                DataColumn(label: Text("Action")),
                                DataColumn(label: Text("Service Name")),
                                DataColumn(label: Text("Description")),
                                DataColumn(label: Text("Price")),
                                DataColumn(label: Text("Images")),
                              ],
                              rows: List<
                                DataRow
                              >.generate(filteredServices.length, (index) {
                                final item = filteredServices[index];
                                final imagesString =
                                    (item['images'] ?? '').toString();
                                final imageList =
                                    imagesString
                                        .split(',')
                                        .where((img) => img.trim().isNotEmpty)
                                        .toList();
                                final description =
                                    item['description'] ?? 'No Description';
                                final isExpanded =
                                    expandedDescriptions[index] ?? false;

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => EditServiceDataPage(
                                                        serviceId:
                                                            item['service_id']
                                                                .toString(),
                                                        serviceName:
                                                            item['service_type'] ??
                                                            '',
                                                        description:
                                                            item['description'] ??
                                                            '',
                                                        price:
                                                            item['price']
                                                                .toString(),
                                                        existingImages:
                                                            (item['images']
                                                                    as String)
                                                                .split(','),
                                                      ),
                                                ),
                                              ).then((value) {
                                                if (value == true) {
                                                  fetchServiceData(); // ✅ Reload updated table
                                                }
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.deepPurple,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text("Edit"),
                                          ),

                                          const SizedBox(width: 6),

                                          ElevatedButton(
                                            onPressed: () async {
                                              final response = await http.get(
                                                Uri.parse(
                                                  'http://192.168.1.9:8000/api/ServiceTrashDelete/${item['service_id']}',
                                                ),
                                              );

                                              if (response.statusCode == 200) {
                                                final jsonData = jsonDecode(
                                                  response.body,
                                                );
                                                if (jsonData['status'] ==
                                                    true) {
                                                  Flushbar(
                                                    message:
                                                        jsonData['message'],
                                                    duration: const Duration(
                                                      seconds: 3,
                                                    ),
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    backgroundColor:
                                                        Colors.green.shade600,
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                  ).show(context);
                                                  fetchServiceData(); // Reload list after trash
                                                } else {
                                                  Flushbar(
                                                    message:
                                                        'Failed to trash service',
                                                    duration: const Duration(
                                                      seconds: 3,
                                                    ),
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    backgroundColor:
                                                        Colors.red.shade600,
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                  ).show(context);
                                                }
                                              } else {
                                                Flushbar(
                                                  message: 'Server error',
                                                  duration: const Duration(
                                                    seconds: 3,
                                                  ),
                                                  margin: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  backgroundColor:
                                                      Colors.red.shade600,
                                                  flushbarPosition:
                                                      FlushbarPosition.TOP,
                                                ).show(context);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                    255,
                                                    238,
                                                    98,
                                                    98,
                                                  ),
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text("Trash"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          item['service_type'] ?? 'No Type',
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 250,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              isExpanded
                                                  ? Text(description)
                                                  : Text(
                                                    description,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                              if (description.length > 50)
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      expandedDescriptions[index] =
                                                          !isExpanded;
                                                    });
                                                  },
                                                  child: Text(
                                                    isExpanded
                                                        ? "Less"
                                                        : "More",
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text("₹${item['price'] ?? 'N/A'}"),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 250,
                                        height: 100,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: imageList.length,
                                          itemBuilder: (context, imgIndex) {
                                            final imageFile =
                                                imageList[imgIndex].trim();
                                            final imageUrl =
                                                "$baseUrl/$imageRoute/$imageFile";
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 6,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Image.network(
                                                  imageUrl,
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => const Icon(
                                                        Icons.broken_image,
                                                        size: 40,
                                                      ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
        ),
      ],
    );
  }
}
