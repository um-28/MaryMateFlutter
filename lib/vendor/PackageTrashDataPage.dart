// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:another_flushbar/flushbar.dart';

// class PackageTrashDataPage extends StatefulWidget {
//   const PackageTrashDataPage({super.key});

//   @override
//   State<PackageTrashDataPage> createState() => _PackageTrashDataPageState();
// }

// class _PackageTrashDataPageState extends State<PackageTrashDataPage> {
//   List<Map<String, dynamic>> trashedPackages = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchTrashedPackages();
//   }

//   Future<void> fetchTrashedPackages() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('user_id');

//     if (userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User ID not found')),
//       );
//       return;
//     }

//     final response = await http.get(
//       Uri.parse('http://192.168.1.9:8000/api/PackageTrash?user_id=$userId'),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         trashedPackages =
//             data['status'] == true && data['packages'] != null
//                 ? List<Map<String, dynamic>>.from(data['packages'])
//                 : [];
//         isLoading = false;
//       });
//     } else {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to load trashed packages')),
//       );
//     }
//   }

//   Future<void> restorePackage(String packageId) async {
//     final response = await http.get(
//       Uri.parse('http://192.168.1.9:8000/api/PackageRestore/$packageId'),
//     );

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       if (jsonData['status'] == true) {
//         Flushbar(
//           message: jsonData['message'],
//           duration: const Duration(seconds: 2),
//           backgroundColor: Colors.green,
//           flushbarPosition: FlushbarPosition.TOP,
//           margin: const EdgeInsets.all(8),
//           borderRadius: BorderRadius.circular(8),
//         ).show(context).then((_) => Navigator.pop(context, true));
//       }
//     }
//   }

//   Future<void> forceDeletePackage(String packageId) async {
//     final response = await http.get(
//       Uri.parse('http://192.168.1.9:8000/api/PackageForceDelete/$packageId'),
//     );

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       if (jsonData['status'] == true) {
//         Flushbar(
//           message: jsonData['message'],
//           duration: const Duration(seconds: 2),
//           backgroundColor: Colors.red,
//           flushbarPosition: FlushbarPosition.TOP,
//           margin: const EdgeInsets.all(8),
//           borderRadius: BorderRadius.circular(8),
//         ).show(context);
//         fetchTrashedPackages();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trashed Packages'),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : trashedPackages.isEmpty
//               ? const Center(child: Text("No trashed packages available"))
//               : SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(12),
//                     child: DataTable(
//                       columns: const [
//                         DataColumn(label: Text('Actions')),
//                         DataColumn(label: Text('Package Name')),
//                         DataColumn(label: Text('Description')),
//                         DataColumn(label: Text('Price')),
//                       ],
//                       rows: trashedPackages.map((item) {
//                         return DataRow(cells: [
//                           DataCell(Row(
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {
//                                   restorePackage(item['package_id'].toString());
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                 ),
//                                 child: const Text("Restore"),
//                               ),
//                               const SizedBox(width: 8),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   forceDeletePackage(
//                                       item['package_id'].toString());
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                 ),
//                                 child: const Text("Delete"),
//                               ),
//                             ],
//                           )),
//                           DataCell(Text(item['package_name'] ?? '')),
//                           DataCell(Text(item['description'] ?? '')),
//                           DataCell(Text("₹${item['price'] ?? ''}")),
//                         ]);
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';

class PackageTrashDataPage extends StatefulWidget {
  const PackageTrashDataPage({super.key});

  @override
  State<PackageTrashDataPage> createState() => _PackageTrashDataPageState();
}

class _PackageTrashDataPageState extends State<PackageTrashDataPage> {
  List<Map<String, dynamic>> trashedPackages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrashedPackages();
  }

  Future<void> fetchTrashedPackages() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User ID not found')));
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.9:8000/api/PackageTrash?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        trashedPackages =
            data['status'] == true && data['packages'] != null
                ? List<Map<String, dynamic>>.from(data['packages'])
                : [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load trashed packages')),
      );
    }
  }

  Future<void> restorePackage(String packageId) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.9:8000/api/PackageRestore/$packageId'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == true) {
        Flushbar(
          message: jsonData['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
        ).show(context).then((_) => Navigator.pop(context, true));
      }
    }
  }

  Future<void> forceDeletePackage(String packageId) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.9:8000/api/PackageForceDelete/$packageId'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == true) {
        Flushbar(
          message: jsonData['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
        ).show(context);
        fetchTrashedPackages();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trashed Packages'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : trashedPackages.isEmpty
              ? const Center(child: Text("No trashed packages available"))
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: DataTable(
                    columnSpacing: 20.0,
                    headingRowColor: MaterialStateProperty.all(
                      Colors.grey.shade200,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Actions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Package Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Price',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Service Type',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Images',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows:
                        trashedPackages.map((item) {
                          final imagesString = item['images']?.toString() ?? '';
                          final imageList =
                              imagesString
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
                                        restorePackage(
                                          item['package_id'].toString(),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text("Restore"),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        forceDeletePackage(
                                          item['package_id'].toString(),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Text(
                                  item['package_name'] ?? '',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              DataCell(
                                Text(
                                  item['service_types'] ?? '',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              DataCell(
                                Text(
                                  item['description'] ?? '',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              DataCell(
                                Text(
                                  "₹${item['price'] ?? ''}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),

                              DataCell(
                                SizedBox(
                                  width: 150,
                                  height: 60,
                                  child:
                                      imageList.isNotEmpty
                                          ? ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: imageList.length,
                                            itemBuilder: (context, index) {
                                              final imageUrl =
                                                  'http://192.168.1.9:8000/package-image/${imageList[index]}';
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: Image.network(
                                                  imageUrl,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return const Icon(
                                                      Icons.broken_image,
                                                      size: 50,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          )
                                          : const Text("No Image"),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
    );
  }
}
