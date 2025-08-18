import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';

class TrashDataPage extends StatefulWidget {
  const TrashDataPage({super.key});

  @override
  State<TrashDataPage> createState() => _TrashDataPageState();
}

class _TrashDataPageState extends State<TrashDataPage> {
  List<Map<String, dynamic>> trashedServices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrashedServices();
  }

  Future<void> fetchTrashedServices() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User ID not found')));
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.1.6:8000/api/ServiceTrash?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        trashedServices =
            data['status'] == true && data['services'] != null
                ? List<Map<String, dynamic>>.from(data['services'])
                : [];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load trashed data')),
      );
    }
  }

  Future<void> restoreService(String serviceId) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.6:8000/api/ServiceRestore/$serviceId'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == true) {
        Flushbar(
          message: jsonData['message'] ?? 'Service restored',
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        ).show(context).then((_) {
          Navigator.pop(context, true);
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Restore failed")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error during restore")),
      );
    }
  }

  Future<void> forceDeleteService(String serviceId) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.6:8000/api/ServiceForceDelete/$serviceId'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == true) {
        Flushbar(
          message: jsonData['message'] ?? 'Service permanently deleted',
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 239, 84, 73),
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          // icon: const Icon(Icons.delete_forever, color: Colors.white),
        ).show(context);
        fetchTrashedServices();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Delete failed")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server error during delete")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trashed Services'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : trashedServices.isEmpty
              ? const Center(child: Text("No trashed data available"))
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
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
                          'Service Name',
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
                          'Images',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows:
                        trashedServices.map((item) {
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
                                        restoreService(
                                          item['service_id'].toString(),
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
                                        forceDeleteService(
                                          item['service_id'].toString(),
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
                                  item['service_type'] ?? '',
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
                                                  'http://192.168.1.6:8000/service-image/${imageList[index]}';
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
