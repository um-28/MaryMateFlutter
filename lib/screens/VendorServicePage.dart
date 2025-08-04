import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/service_model.dart';
import '../data/cart_data.dart';

class VendorServicePage extends StatefulWidget {
  final int vendorId;

  const VendorServicePage({super.key, required this.vendorId});

  @override
  State<VendorServicePage> createState() => _VendorServicePageState();
}

class _VendorServicePageState extends State<VendorServicePage> {
  List<VendorService> allItems = [];
  bool isLoading = true;
  bool isLoggedIn = false;
  String serviceTypeTitle = "";

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchVendorData();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.containsKey('user_id');
    });
  }

  Future<void> fetchVendorData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.3:8000/api/services/${widget.vendorId}'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          final serviceList = jsonData['services'] ?? [];
          final packageList = jsonData['packages'] ?? [];

          allItems = [
            ...serviceList
                .map<VendorService>(
                  (s) => VendorService.fromJson(s, isPackage: false),
                )
                .toList(),
            ...packageList
                .map<VendorService>(
                  (p) => VendorService.fromJson(p, isPackage: true),
                )
                .toList(),
          ];

          // ✅ Set title dynamically based on first item
          if (allItems.isNotEmpty) {
            serviceTypeTitle = allItems.first.serviceType;
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    setState(() => isLoading = false);
  }

  void showImagePopup(List<String> images, int initialIndex) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white,
            child: SizedBox(
              height: 350,
              width: MediaQuery.of(context).size.width * 0.9,
              child: PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.8,
                    maxScale: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
    );
  }

  Future<void> selectDate(BuildContext context, int index) async {
    DateTime? startDate;
    DateTime? endDate;
    bool isOneDay = true;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Booking Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text("One Day"),
                        selected: isOneDay,
                        onSelected: (val) {
                          setModalState(() {
                            isOneDay = true;
                            endDate = null;
                          });
                        },
                        selectedColor: Colors.orange.shade200,
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("Date Range"),
                        selected: !isOneDay,
                        onSelected: (val) {
                          setModalState(() {
                            isOneDay = false;
                          });
                        },
                        selectedColor: Colors.orange.shade200,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    onDateChanged: (picked) {
                      setModalState(() {
                        if (isOneDay) {
                          startDate = picked;
                          endDate = picked;
                        } else {
                          if (startDate == null || endDate != null) {
                            startDate = picked;
                            endDate = null;
                          } else {
                            if (picked.isAfter(startDate!)) {
                              endDate = picked;
                            } else {
                              startDate = picked;
                              endDate = null;
                            }
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  if (startDate != null)
                    Text(
                      isOneDay
                          ? "Selected: ${startDate!.toLocal().toString().split(' ')[0]}"
                          : endDate == null
                          ? "Start Date: ${startDate!.toLocal().toString().split(' ')[0]}"
                          : "From: ${startDate!.toLocal().toString().split(' ')[0]} to ${endDate!.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        (isOneDay && startDate != null) ||
                                (!isOneDay &&
                                    startDate != null &&
                                    endDate != null)
                            ? () async {
                              final res = await http.post(
                                Uri.parse(
                                  "http://192.168.1.3:8000/api/checkdate",
                                ),
                                headers: {'Accept': 'application/json'},
                                body: {
                                  'vendor_id': widget.vendorId.toString(),
                                  'start_date':
                                      startDate.toString().split(" ")[0],
                                  'end_date':
                                      (endDate ?? startDate).toString().split(
                                        " ",
                                      )[0],
                                },
                              );

                              final responseJson = jsonDecode(res.body);

                              if (responseJson['status'] == 'available') {
                                setState(() {
                                  allItems[index].startDate = startDate;
                                  allItems[index].endDate =
                                      endDate ?? startDate;
                                  allItems[index].isAddedToCart = true;
                                  if (!globalCartItems.contains(
                                    allItems[index],
                                  )) {
                                    globalCartItems.add(allItems[index]);
                                  }
                                });
                                saveCartToPrefs();
                                
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                Flushbar(
                                  message:
                                      '${allItems[index].serviceType} added to cart!',
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.deepOrange,
                                  flushbarPosition: FlushbarPosition.TOP,
                                  margin: const EdgeInsets.all(12),
                                  borderRadius: BorderRadius.circular(8),
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                ).show(context);
                              } else {
                                Flushbar(
                                  message:
                                      responseJson['message'] ??
                                      "Date unavailable",
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                  flushbarPosition: FlushbarPosition.TOP,
                                  margin: const EdgeInsets.all(12),
                                  borderRadius: BorderRadius.circular(8),
                                  icon: const Icon(
                                    Icons.error_outline,
                                    color: Colors.white,
                                  ),
                                ).show(context);
                              }
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Done"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          serviceTypeTitle.isNotEmpty
              ? "Vendor Services - $serviceTypeTitle"
              : "Vendor Services",
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : allItems.isEmpty
              ? const Center(child: Text("No services or packages found."))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allItems.length,
                itemBuilder: (context, index) {
                  final item = allItems[index];
                  return buildServiceItem(item, index);
                },
              ),
    );
  }

  Widget buildServiceItem(VendorService item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF8F2), Color(0xFFFDEDDC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.serviceType + (item.isPackage ? " (Package)" : ""),
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade900,
              ),
            ),
            if (item.isPackage)
              Text(
                "Services: ${item.categoryType}",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepOrange,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: GoogleFonts.roboto(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              "₹ ${item.price}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 6),

            // ✅ SHOW vendor_id, service_id, package_id
            Text(
              "Vendor ID: ${item.vendorId} | Service ID: ${item.serviceId}" +
                  (item.isPackage && item.packageId != null
                      ? " | Package ID: ${item.packageId}"
                      : ""),
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 12),
            item.images.isNotEmpty
                ? SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.images.length,
                    itemBuilder: (context, imgIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => showImagePopup(item.images, imgIndex),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.images[imgIndex],
                              width: 140,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                : const Text("No images available."),
            const SizedBox(height: 12),
            if (item.isAddedToCart &&
                item.startDate != null &&
                item.endDate != null)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF3E7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepOrange.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.date_range, color: Colors.deepOrange),
                    const SizedBox(width: 8),
                    Text(
                      "${item.startDate!.toLocal().toString().split(' ')[0]} → ${item.endDate!.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (!isLoggedIn) {
                      Navigator.pushReplacementNamed(context, '/login');
                      return;
                    }
                    selectDate(context, index);
                  },
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    item.isAddedToCart ? "Update Date" : "Add to Cart",
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        item.isAddedToCart ? Colors.teal : Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                if (item.isAddedToCart) const SizedBox(width: 16),
                if (item.isAddedToCart)
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        item.startDate = null;
                        item.endDate = null;
                        item.isAddedToCart = false;
                        globalCartItems.remove(item);
                        saveCartToPrefs();
                      });
                    },
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
