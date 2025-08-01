import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    print("User ID from SharedPreferences: $userId"); // ✅ debug

    if (userId == null) return;

    final url = Uri.parse(
      "http://192.168.1.6:8000/api/VendorAvailabilityView?user_id=$userId",
    );

    final response = await http.get(url);

    // print("API Response Code: ${response.statusCode}");
    // print("API Body: ${response.body}");

    if (response.statusCode == 200) {
      final resData = json.decode(response.body);
      if (resData['status'] == true) {
        setState(() {
          availabilityList = resData['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Availability')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : availabilityList.isEmpty
              ? const Center(child: Text("No availability data found"))
              : ListView.builder(
                itemCount: availabilityList.length,
                itemBuilder: (context, index) {
                  final item = availabilityList[index];
                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Text("Place: ${item['placeToservice']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start: ${item['availability_startdate']}"),
                          Text("End: ${item['availability_enddate']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
