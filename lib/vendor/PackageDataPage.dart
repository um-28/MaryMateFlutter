// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class PackageDataPage extends StatefulWidget {
//   const PackageDataPage({Key? key}) : super(key: key);

//   @override
//   State<PackageDataPage> createState() => _PackageDataPageState();
// }

// class _PackageDataPageState extends State<PackageDataPage> {
//   List<dynamic> packageData = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchPackages();
//   }

//   Future<void> fetchPackages() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? userId = prefs.getInt('user_id');
//     if (userId == null) return;

//     final response = await http.get(
//       Uri.parse('http://192.168.1.9:8000/api/PackageData?user_id=$userId'),
//     );

//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       setState(() {
//         packageData = result['packages'];
//       });
//     } else {
//       print('Failed to fetch packages');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         const Text(
//           'Packages Data',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: DataTable(
//             columns: const [
//               DataColumn(label: Text('Package Name')),
//               DataColumn(label: Text('Description')),
//               DataColumn(label: Text('Price')),
//               DataColumn(label: Text('Actions')),
//             ],
//             rows:
//                 packageData.map((package) {
//                   return DataRow(
//                     cells: [
//                       DataCell(Text(package['package_name'] ?? '')),
//                       DataCell(Text(package['package_description'] ?? '')),
//                       DataCell(Text(package['price'].toString())),
//                       DataCell(
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit, color: Colors.blue),
//                               onPressed: () {
//                                 // TODO: Navigate to edit page
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete, color: Colors.red),
//                               onPressed: () {
//                                 // TODO: Trash logic
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class PackageDataPage extends StatefulWidget {
//   const PackageDataPage({super.key});

//   @override
//   State<PackageDataPage> createState() => _PackageDataPageState();
// }

// class _PackageDataPageState extends State<PackageDataPage> {
//   List<dynamic> packages = [];
//   List<dynamic> filteredPackages = [];
//   Map<int, bool> showFullDescription = {};
//   bool isLoading = true;

//   final TextEditingController _searchController = TextEditingController();
//   final String baseUrl = 'http://192.168.1.9:8000';

//   @override
//   void initState() {
//     super.initState();
//     fetchPackageData();
//   }

//   Future<void> fetchPackageData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? userId = prefs.getInt('user_id');
//     if (userId == null) return;

//     setState(() {
//       isLoading = true;
//     });

//     final url = Uri.parse('$baseUrl/api/PackageData?user_id=$userId');

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['status'] == true && jsonData['packages'] != null) {
//           setState(() {
//             packages = jsonData['packages'];
//             filteredPackages = List.from(packages);
//             showFullDescription = {
//               for (int i = 0; i < packages.length; i++) i: false,
//             };
//           });
//         }
//       }
//     } catch (e) {
//       print("Exception during API call: $e");
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _filterPackages() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       filteredPackages =
//           packages
//               .where(
//                 (item) =>
//                     item['package_name'].toString().toLowerCase().contains(
//                       query,
//                     ) ||
//                     item['service_types'].toString().toLowerCase().contains(
//                       query,
//                     ),
//               )
//               .toList();
//     });
//   }

//   void _resetSearch() {
//     _searchController.clear();
//     setState(() {
//       filteredPackages = List.from(packages);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         /// 🔍 Search Bar
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     style: const TextStyle(fontSize: 14),
//                     decoration: InputDecoration(
//                       hintText: "Search packages...",
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 14,
//                         vertical: 10,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: _filterPackages,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text("Search"),
//               ),
//               const SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: _resetSearch,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey[400],
//                   foregroundColor: Colors.black,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text("Reset"),
//               ),
//             ],
//           ),
//         ),

//         /// 📋 Title
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text(
//                 'Packages Data',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),

//         /// ➕ Add & Trash Buttons
//         Padding(
//           padding: const EdgeInsets.only(left: 16.0, top: 6.0, bottom: 12.0),
//           child: Row(
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   // TODO: Navigate to AddPackageDataPage
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 10,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text('Add'),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   // TODO: Navigate to TrashPackagePage
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 238, 98, 98),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 10,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text('Trash Data'),
//               ),
//             ],
//           ),
//         ),

//         /// 📊 Table
//         Expanded(
//           child:
//               isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : filteredPackages.isEmpty
//                   ? const Padding(
//                     padding: EdgeInsets.all(20),
//                     child: Text("No Packages Found"),
//                   )
//                   : Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 4,
//                             spreadRadius: 1,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: SingleChildScrollView(
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: ConstrainedBox(
//                             constraints: const BoxConstraints(minWidth: 1500),
//                             child: DataTable(
//                               headingRowHeight: 56,
//                               dataRowMinHeight: 100,
//                               dataRowMaxHeight: 120,
//                               columnSpacing: 24,
//                               headingRowColor: MaterialStateProperty.all(
//                                 Colors.grey[200],
//                               ),
//                               columns: const [
//                                 DataColumn(label: Text("Actions")),
//                                 DataColumn(label: Text("Package Name")),
//                                 DataColumn(label: Text("Service Types")),
//                                 DataColumn(label: Text("Description")),
//                                 DataColumn(label: Text("Image")),
//                                 DataColumn(label: Text("Price")),
//                               ],
//                               rows: List<
//                                 DataRow
//                               >.generate(filteredPackages.length, (index) {
//                                 final item = filteredPackages[index];
//                                 final imageUrl =
//                                     item['package_image'] != null
//                                         ? item['package_image']
//                                                 .toString()
//                                                 .startsWith('http')
//                                             ? item['package_image']
//                                             : '$baseUrl/${item['package_image']}'
//                                         : null;

//                                 final fullDescription =
//                                     item['description'] ?? 'No Description';
//                                 final isExpanded =
//                                     showFullDescription[index] ?? false;
//                                 final displayText =
//                                     fullDescription.length > 50
//                                         ? isExpanded
//                                             ? fullDescription
//                                             : '${fullDescription.substring(0, 50)}...'
//                                         : fullDescription;

//                                 return DataRow(
//                                   cells: [
//                                     DataCell(
//                                       Row(
//                                         children: [
//                                           TextButton(
//                                             onPressed: () {
//                                               // TODO: Navigate to Edit
//                                             },
//                                             child: const Text(
//                                               'Edit',
//                                               style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 8),
//                                           TextButton(
//                                             onPressed: () {
//                                               // TODO: Handle Trash
//                                             },
//                                             child: const Text(
//                                               'Trash',
//                                               style: TextStyle(
//                                                 color: Colors.red,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     DataCell(
//                                       Text(item['package_name'] ?? 'No Name'),
//                                     ),
//                                     DataCell(
//                                       Text(item['service_types'] ?? 'N/A'),
//                                     ),
//                                     DataCell(
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(displayText),
//                                           if (fullDescription.length > 50)
//                                             GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   showFullDescription[index] =
//                                                       !isExpanded;
//                                                 });
//                                               },
//                                               child: Text(
//                                                 isExpanded
//                                                     ? 'Show Less'
//                                                     : 'Show More',
//                                                 style: const TextStyle(
//                                                   color: Colors.blue,
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                     ),
//                                     DataCell(
//                                       imageUrl != null
//                                           ? ClipRRect(
//                                             borderRadius: BorderRadius.circular(
//                                               8,
//                                             ),
//                                             child: Image.network(
//                                               imageUrl,
//                                               width: 100,
//                                               height: 80,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           )
//                                           : const Text('No Image'),
//                                     ),
//                                     DataCell(
//                                       Text(
//                                         item['price'].toString().replaceAll(
//                                           '.0',
//                                           '',
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               }),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                  // TODO: Navigate to AddPackageDataPage
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
                  // TODO: Navigate to TrashPackagePage
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
                            constraints: const BoxConstraints(minWidth: 1500),
                            child: DataTable(
                              headingRowHeight: 56,
                              dataRowMinHeight: 100,
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
                                DataColumn(label: Text("Images")),
                                DataColumn(label: Text("Price")),
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
                                          TextButton(
                                            onPressed: () {
                                              // TODO: Edit
                                            },
                                            child: const Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton(
                                            onPressed: () {
                                              // TODO: Trash
                                            },
                                            child: const Text(
                                              'Trash',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
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
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
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
