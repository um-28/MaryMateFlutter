import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/checkout_page.dart';
import '../screens/loginpage.dart';
import '../config/api_config.dart';

// your StatefulWidget class
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

  Map<String, bool> isOneDaySelectedMap = {};
  Map<String, DateTime?> selectedDateMap = {};
  Map<String, DateTimeRange?> selectedRangeMap = {};
  Map<String, bool> userHasSelectedDateMap = {};

  @override
  void initState() {
    super.initState();
    fetchPackageDetails();
  }

  Future<void> fetchPackageDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/api/showCustomPackageData/${widget.packageId}",
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

  Future<void> checkDateAvailability(
    String uniqueKey,
    int vendorId,
    String itemName,
  ) async {
    final bool isOneDaySelected = isOneDaySelectedMap[uniqueKey] ?? true;
    final DateTime? selectedDate = selectedDateMap[uniqueKey];
    final DateTimeRange? selectedRange = selectedRangeMap[uniqueKey];

    if ((isOneDaySelected && selectedDate == null) ||
        (!isOneDaySelected && selectedRange == null)) {
      return;
    }

    final String startDate =
        isOneDaySelected
            ? selectedDate!.toIso8601String().split('T')[0]
            : selectedRange!.start.toIso8601String().split('T')[0];
    final String? endDate =
        isOneDaySelected
            ? null
            : selectedRange!.end.toIso8601String().split('T')[0];

    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/checkdate"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "vendor_id": vendorId,
          "start_date": startDate,
          "end_date": endDate,
        }),
      );

      final data = json.decode(response.body);
      final message =
          isOneDaySelected
              ? "$itemName booked on $startDate"
              : "$itemName booked from $startDate to $endDate";

      Flushbar(
        title: data['status'] == 'available' ? "Available" : "Not Available",
        message: message,
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor:
            data['status'] == 'available' ? Colors.green : Colors.redAccent,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(10),
        // ignore: use_build_context_synchronously
      ).show(context);
    } catch (e) {
      print("API error: $e");
    }
  }

  // 🔁 Add this to your _CustomPackageDetailPageState class
  double calculateTotalDynamicPrice() {
    double total = 0.0;
    final combinedList = [...services, ...predefinedPackages];

    for (var item in combinedList) {
      final vendorId = item['vendor_id'];
      final id = item['id'] ?? item['sp_id'];
      final type = item.containsKey('service_type') ? 'service' : 'package';
      final uniqueKey = "$type-$vendorId-$id";

      if (userHasSelectedDateMap[uniqueKey] == true) {
        final isOneDay = isOneDaySelectedMap[uniqueKey] ?? true;
        final startDate =
            isOneDay
                ? selectedDateMap[uniqueKey]
                : selectedRangeMap[uniqueKey]?.start;
        final endDate =
            isOneDay
                ? selectedDateMap[uniqueKey]
                : selectedRangeMap[uniqueKey]?.end;

        int dayCount = 1;
        if (!isOneDay && startDate != null && endDate != null) {
          dayCount = endDate.difference(startDate).inDays + 1;
        }

        final price = double.tryParse(item['price'].toString()) ?? 0.0;
        total += price * dayCount;
      }
    }

    return total;
  }

  void showDatePickerModal(String uniqueKey, int vendorId, String itemName) {
    bool tempIsOneDay = isOneDaySelectedMap[uniqueKey] ?? true;
    DateTime? tempDate = selectedDateMap[uniqueKey];
    DateTimeRange? tempRange = selectedRangeMap[uniqueKey];
    DateTime? tempStart;
    DateTime? tempEnd;
    bool isSelectingRangeStart = true;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Select Booking Type",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: const Text("One Day"),
                            selected: tempIsOneDay,
                            onSelected: (_) {
                              setModalState(() {
                                tempIsOneDay = true;
                                tempDate = null;
                              });
                            },
                            selectedColor: Colors.orange.shade200,
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text("Date Range"),
                            selected: !tempIsOneDay,
                            onSelected: (_) {
                              setModalState(() {
                                tempIsOneDay = false;
                                tempStart = null;
                                tempEnd = null;
                                isSelectingRangeStart = true;
                              });
                            },
                            selectedColor: Colors.orange.shade200,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (tempIsOneDay && tempDate != null)
                        Text(
                          "Selected: ${tempDate!.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else if (!tempIsOneDay && tempStart != null)
                        Text(
                          tempEnd == null
                              ? "Start: ${tempStart!.toLocal().toString().split(' ')[0]}"
                              : "Selected: ${tempStart!.toLocal().toString().split(' ')[0]} → ${tempEnd!.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 16),
                      CalendarDatePicker(
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) {
                          setModalState(() {
                            if (tempIsOneDay) {
                              tempDate = date;
                            } else {
                              if (isSelectingRangeStart) {
                                tempStart = date;
                                tempEnd = null;
                                isSelectingRangeStart = false;
                              } else {
                                if (tempStart != null &&
                                    date.isAfter(tempStart!)) {
                                  tempEnd = date;
                                  tempRange = DateTimeRange(
                                    start: tempStart!,
                                    end: tempEnd!,
                                  );
                                } else {
                                  tempStart = date;
                                  tempEnd = null;
                                  tempRange = null;
                                  isSelectingRangeStart = false;
                                }
                              }
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final isOneDay = tempIsOneDay;
                          final oneDayDate = tempDate;
                          final range = tempRange;

                          if ((isOneDay && oneDayDate == null) ||
                              (!isOneDay && range == null)) {
                            return;
                          }

                          final startDate =
                              isOneDay
                                  ? oneDayDate!.toIso8601String().split('T')[0]
                                  : range!.start.toIso8601String().split(
                                    'T',
                                  )[0];
                          final endDate =
                              isOneDay
                                  ? null
                                  : range!.end.toIso8601String().split('T')[0];

                          try {
                            final response = await http.post(
                              Uri.parse("${ApiConfig.baseUrl}/api/checkdate"),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({
                                "vendor_id": vendorId,
                                "start_date": startDate,
                                "end_date": endDate,
                              }),
                            );
                            final data = json.decode(response.body);
                            if (data['status'] == 'unavailable') {
                              Flushbar(
                                title: "Not Available",
                                message:
                                    isOneDay
                                        ? "$itemName is already booked on $startDate"
                                        : "$itemName is already booked from $startDate to $endDate",
                                duration: const Duration(seconds: 3),
                                flushbarPosition: FlushbarPosition.TOP,
                                backgroundColor: Colors.redAccent,
                                margin: const EdgeInsets.all(8),
                                borderRadius: BorderRadius.circular(10),
                                // ignore: use_build_context_synchronously
                              ).show(context);
                              return;
                            }

                            setState(() {
                              isOneDaySelectedMap[uniqueKey] = tempIsOneDay;
                              selectedDateMap[uniqueKey] = tempDate;
                              selectedRangeMap[uniqueKey] = tempRange;
                              userHasSelectedDateMap[uniqueKey] = true;
                            });

                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            checkDateAvailability(
                              uniqueKey,
                              vendorId,
                              itemName,
                            );
                          } catch (e) {
                            print("API error: $e");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                        ),
                        child: const Text("OK"),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget displaySelectedDate(String uniqueKey) {
    if (userHasSelectedDateMap[uniqueKey] != true) {
      return const SizedBox.shrink();
    }

    final isOneDaySelected = isOneDaySelectedMap[uniqueKey] ?? true;
    final selectedDate = selectedDateMap[uniqueKey];
    final selectedRange = selectedRangeMap[uniqueKey];

    if (isOneDaySelected && selectedDate != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          "Selected: ${selectedDate.toLocal().toString().split(' ')[0]}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
      );
    } else if (!isOneDaySelected && selectedRange != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          "Selected: ${selectedRange.start.toLocal().toString().split(' ')[0]} → ${selectedRange.end.toLocal().toString().split(' ')[0]}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
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
          final imageUrl =
              "${ApiConfig.baseUrl}/$folder/${imageList[index].trim()}";
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
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildServiceOrPackageCard(dynamic item, String imageFolder) {
    final vendorId = item['vendor_id'];
    final id = item['id'] ?? item['sp_id'];
    final type = imageFolder == 'service-image' ? 'service' : 'package';
    final uniqueKey = "$type-$vendorId-$id";
    final itemName = item['service_type'] ?? item['package_name'] ?? 'Item';

    // service and package id variables
    final idLabel =
        type == 'service'
            ? 'Service ID: ${item['service_id'] ?? 'N/A'}'
            : 'Package ID: ${item['package_id'] ?? 'N/A'}';

    return Card(
      color: const Color(0xFFFFF3E0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            // Service and package ids
            Text(
              idLabel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            Text(item['description'] ?? "No Description"),
            // Text(item['service_id']),
            const SizedBox(height: 6),
            Text(
              "₹${item['price']}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            buildImageSlider(item['images'], imageFolder),
            displaySelectedDate(uniqueKey),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final userId = prefs.getInt('user_id') ?? 0;

                  if (userId == 0) {
                    // 🔁 Redirect to LoginPage if not logged in
                    Navigator.pushReplacement(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                    return;
                  }

                  // ✅ Old logic runs if logged in
                  showDatePickerModal(uniqueKey, vendorId, itemName);
                },
                child: const Text("Select"),
              ),
            ),
          ],
        ),
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
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Included Services",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...services.map(
                      (s) => buildServiceOrPackageCard(s, 'service-image'),
                    ),
                    const Divider(height: 30),

                    if (predefinedPackages.isNotEmpty) ...[
                      const Text(
                        "Predefined Packages",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...predefinedPackages.map(
                        (p) => buildServiceOrPackageCard(p, 'package-image'),
                      ),
                      const SizedBox(height: 100), // Extra space for bottom bar
                    ],
                  ],
                ),
              ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF3E0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "₹${calculateTotalDynamicPrice()}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),

              // Book Now Button
              ElevatedButton.icon(
                onPressed: () async {
                  final selectedServices = <Map<String, dynamic>>[];
                  final selectedPackages = <Map<String, dynamic>>[];

                  final combinedList = [...services, ...predefinedPackages];

                  bool allSelectedItemsHaveDates = true;

                  for (var item in combinedList) {
                    final vendorId = item['vendor_id'];
                    final id = item['id'] ?? item['ap_id'];
                    final type =
                        item.containsKey('service_type')
                            ? 'service'
                            : 'package';
                    final name =
                        item['service_type'] ??
                        item['package_name'] ??
                        'Unnamed';
                    final uniqueKey = "$type-$vendorId-$id";

                    final isSelected =
                        userHasSelectedDateMap[uniqueKey] == true;
                    final isOneDay = isOneDaySelectedMap[uniqueKey] ?? true;

                    final startDate =
                        isOneDay
                            ? selectedDateMap[uniqueKey]
                            : selectedRangeMap[uniqueKey]?.start;
                    final endDate =
                        isOneDay
                            ? selectedDateMap[uniqueKey]
                            : selectedRangeMap[uniqueKey]?.end;

                    if (!isSelected || startDate == null || endDate == null) {
                      allSelectedItemsHaveDates = false;
                      break;
                    }

                    final data = {
                      'name': name,
                      'start_date': startDate.toString().split(' ')[0],
                      'end_date': endDate.toString().split(' ')[0],
                      if (type == 'service') 'service_id': item['service_id'],
                      if (type == 'package') 'package_id': item['package_id'],
                    };

                    if (type == 'service') {
                      selectedServices.add(data);
                    } else {
                      selectedPackages.add(data);
                    }
                  }

                  if (!allSelectedItemsHaveDates) {
                    Flushbar(
                      message:
                          "Please select dates for all services and packages.",
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                      flushbarPosition: FlushbarPosition.TOP,
                      margin: const EdgeInsets.all(12),
                      borderRadius: BorderRadius.circular(8),
                      icon: const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                      ),
                    ).show(context);
                    return;
                  }

                  final apId =
                      customPackage != null && customPackage?['ap_id'] != null
                          ? int.tryParse(customPackage!['ap_id'].toString()) ??
                              0
                          : 0;

                  final prefs = await SharedPreferences.getInstance();
                  final userId = prefs.getInt('user_id') ?? 0;

                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => CheckoutPage(
                            totalPrice: calculateTotalDynamicPrice(),
                            apId: apId,
                            userId: userId,
                            selectedServices: selectedServices,
                            selectedPackages: selectedPackages,
                          ),
                    ),
                  );
                },

                // icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                label: const Text(
                  "Book Now",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
