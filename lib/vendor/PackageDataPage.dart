import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import '../vendor/AddPackageDataPage.dart';
import '../vendor/PackageTrashDataPage.dart';

class PackageDataPage extends StatefulWidget {
  const PackageDataPage({super.key});

  @override
  State<PackageDataPage> createState() => _PackageDataPageState();
}

class _PackageDataPageState extends State<PackageDataPage> {
  List<dynamic> packages = [];
  List<dynamic> filteredPackages = [];
  Map<int, bool> showFullDescription = {};
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final String baseUrl = 'http://192.168.1.9:8000';

  @override
  void initState() {
    super.initState();
    fetchPackageData();
  }

  Future<void> fetchPackageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('$baseUrl/api/PackageData?user_id=$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true && jsonData['packages'] != null) {
          setState(() {
            packages = jsonData['packages'];
            filteredPackages = List.from(packages);
            showFullDescription = {
              for (int i = 0; i < packages.length; i++) i: false,
            };
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

  void _filterPackages() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredPackages =
          packages.where((item) {
            return item['package_name'].toString().toLowerCase().contains(
                  query,
                ) ||
                item['service_types'].toString().toLowerCase().contains(query);
          }).toList();
    });
  }

  void _resetSearch() {
    _searchController.clear();
    setState(() {
      filteredPackages = List.from(packages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Search Bar
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
                      hintText: "Search packages...",
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
                onPressed: _filterPackages,
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

        /// Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Packages Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        /// Add & Trash Buttons
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 6.0, bottom: 12.0),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPackageDataPage(),
                    ),
                  ).then((value) {
                    if (value == true) {
                      fetchPackageData(); // your reload function
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
                      builder: (context) => const PackageTrashDataPage(),
                    ),
                  ).then((value) {
                    if (value == true) {
                      fetchPackageData(); // Reload after return
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 238, 98, 98),
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

        /// Data Table
        Expanded(
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredPackages.isEmpty
                  ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No Packages Found"),
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
                                DataColumn(label: Text("Actions")),
                                DataColumn(label: Text("Package Name")),
                                DataColumn(label: Text("Service Types")),
                                DataColumn(label: Text("Description")),
                                DataColumn(label: Text("Price")),
                                DataColumn(label: Text("Images")),
                              ],
                              rows: List<
                                DataRow
                              >.generate(filteredPackages.length, (index) {
                                final item = filteredPackages[index];

                                final fullDescription =
                                    item['description'] ?? 'No Description';
                                final isExpanded =
                                    showFullDescription[index] ?? false;
                                final displayText =
                                    fullDescription.length > 50
                                        ? isExpanded
                                            ? fullDescription
                                            : '${fullDescription.substring(0, 50)}...'
                                        : fullDescription;

                                final imageList =
                                    (item['images'] ?? '')
                                        .toString()
                                        .split(',')
                                        .where((img) => img.trim().isNotEmpty)
                                        .toList();

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              print(
                                                "Package ID sent: ${item['package_id']}",
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => EditPackageDataPage(
                                                        packageId:
                                                            item['package_id']
                                                                .toString(),
                                                        packageName:
                                                            item['package_name'] ??
                                                            '',
                                                        serviceTypes:
                                                            item['service_types'] ??
                                                            '',
                                                        description:
                                                            item['description'] ??
                                                            '',
                                                        price:
                                                            item['price']
                                                                .toString(),
                                                        existingImages:
                                                            imageList,
                                                      ),
                                                ),
                                              ).then((value) {
                                                if (value == true) {
                                                  fetchPackageData(); // ✅ Refresh list after update
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
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () async {
                                              final response = await http.get(
                                                Uri.parse(
                                                  'http://192.168.1.9:8000/api/PackageTrahsDelete/${item['package_id']}',
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

                                                  fetchPackageData(); // Refresh after successful trash
                                                } else {
                                                  Flushbar(
                                                    message:
                                                        'Failed to trash package',
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
                                      Text(item['package_name'] ?? 'No Name'),
                                    ),
                                    DataCell(
                                      Text(item['service_types'] ?? 'N/A'),
                                    ),
                                    DataCell(
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 300, // adjust if needed
                                            child: Text(
                                              displayText,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                          if (fullDescription.length > 50)
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  showFullDescription[index] =
                                                      !isExpanded;
                                                });
                                              },
                                              child: Text(
                                                isExpanded
                                                    ? 'Show Less'
                                                    : 'Show More',
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        item['price'].toString().replaceAll(
                                          '.0',
                                          '',
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children:
                                            imageList.map((img) {
                                              final fullUrl =
                                                  '$baseUrl/package-image/${img.trim()}';
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4.0,
                                                    ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    fullUrl,
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return const Icon(
                                                        Icons.broken_image,
                                                        size: 40,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            }).toList(),
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
