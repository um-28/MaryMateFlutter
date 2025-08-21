import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import '../vendor/AddAvailabilityPage.dart';
import '../config/api_config.dart';

class VendorAvailabilityPage extends StatefulWidget {
  const VendorAvailabilityPage({super.key});

  @override
  State<VendorAvailabilityPage> createState() => _VendorAvailabilityPageState();
}

class _VendorAvailabilityPageState extends State<VendorAvailabilityPage> {
  List<dynamic> availabilityList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAvailability();
  }

  Future<void> fetchAvailability() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return;

    final url = Uri.parse(
      "${ApiConfig.baseUrl}/api/VendorAvailabilityView?user_id=$userId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final resData = json.decode(response.body);
      if (resData['status'] == true) {
        setState(() {
          availabilityList = resData['data'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return;

    final url = Uri.parse(
      "${ApiConfig.baseUrl}/api/VendorAvailability/status?user_id=$userId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final resData = json.decode(response.body);
      if (resData['status'] == true) {
        await fetchAvailability();
        Flushbar(
          title: "Status Changed",
          message: resData['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blue,
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(Icons.info_outline, color: Colors.white),
        ).show(context);
      } else {
        Flushbar(
          title: "Error",
          message: resData['message'],
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          flushbarPosition: FlushbarPosition.TOP,
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(Icons.error_outline, color: Colors.white),
        ).show(context);
      }
    } else {
      Flushbar(
        title: "Failed",
        message: "Something went wrong while toggling status.",
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      ).show(context);
    }
  }

  bool checkAlreadyExists() {
    final today = DateTime.now();

    for (var item in availabilityList) {
      if (item['status'].toString() == '1') {
        final startDate = DateTime.tryParse(item['availability_startdate']);
        final endDate = DateTime.tryParse(item['availability_enddate']);

        if (startDate != null && endDate != null) {
          if (!today.isBefore(startDate) && !today.isAfter(endDate)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Add Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Availability Date',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool alreadyExists = checkAlreadyExists();

                  if (alreadyExists) {
                    Flushbar(
                      title: "Already Added",
                      message:
                          "You have already added availability. Please edit it if needed.",
                      duration: const Duration(seconds: 4),
                      backgroundColor: Colors.orange,
                      flushbarPosition: FlushbarPosition.TOP,
                      icon: const Icon(Icons.info, color: Colors.white),
                      margin: const EdgeInsets.all(8),
                      borderRadius: BorderRadius.circular(8),
                    ).show(context);
                  } else {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAvailabilityPage(),
                      ),
                    );
                    if (result == true) {
                      fetchAvailability();
                    }
                  }
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
            ],
          ),
        ),

        // Data Table
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : availabilityList.isEmpty
            ? const Center(child: Text("No availability data found"))
            : Container(
              margin: const EdgeInsets.all(12),
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
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Action',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Start Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'End Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Place to Service',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows:
                      availabilityList.map((item) {
                        final status = item['status'].toString();
                        final isAvailable = status == '1';

                        return DataRow(
                          cells: [
                            DataCell(
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => EditAvailabilityPage(
                                            startDate:
                                                item['availability_startdate'],
                                            endDate:
                                                item['availability_enddate'],
                                            place:
                                                item['placeToservice']
                                                    .toString(),
                                          ),
                                    ),
                                  );
                                  if (result == true) {
                                    fetchAvailability();
                                    Flushbar(
                                      title: "Success",
                                      message:
                                          "Vendor availability updated successfully!",
                                      duration: const Duration(seconds: 3),
                                      backgroundColor: Colors.green,
                                      flushbarPosition: FlushbarPosition.TOP,
                                      margin: const EdgeInsets.all(8),
                                      borderRadius: BorderRadius.circular(8),
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                    ).show(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Edit'),
                              ),
                            ),
                            DataCell(
                              InkWell(
                                onTap: () async {
                                  await toggleStatus();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isAvailable
                                            ? Colors.green
                                            : Colors.amber,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isAvailable ? 'Available' : 'Unavailable',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(item['availability_startdate'].toString()),
                            ),
                            DataCell(
                              Text(item['availability_enddate'].toString()),
                            ),
                            DataCell(
                              SizedBox(
                                width: 200,
                                child: Text(
                                  item['placeToservice'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
      ],
    );
  }
}

//  Edit Page Widget Below

class EditAvailabilityPage extends StatefulWidget {
  final String startDate;
  final String endDate;
  final String place;

  const EditAvailabilityPage({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.place,
  });

  @override
  State<EditAvailabilityPage> createState() => _EditAvailabilityPageState();
}

class _EditAvailabilityPageState extends State<EditAvailabilityPage> {
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController placeController;

  @override
  void initState() {
    super.initState();
    startDateController = TextEditingController(text: widget.startDate);
    endDateController = TextEditingController(text: widget.endDate);
    placeController = TextEditingController(text: widget.place);
  }

  Future<void> updateAvailability() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return;

    final url = Uri.parse("${ApiConfig.baseUrl}/api/UpdateVendorAvailability");

    final response = await http.post(
      url,
      body: {
        'user_id': userId.toString(),
        'startdate': startDateController.text,
        'enddate': endDateController.text,
        'placetoservice': placeController.text,
      },
    );

    final resData = json.decode(response.body);
    if (resData['status'] == true) {
      Navigator.pop(context, true);
    } else {
      Flushbar(
        title: "Update Failed",
        message: resData['message'] ?? "Something went wrong.",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Your Availability'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: endDateController,
                decoration: InputDecoration(
                  labelText: 'End Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: placeController,
                decoration: InputDecoration(
                  labelText: 'Place to Service',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateAvailability,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
