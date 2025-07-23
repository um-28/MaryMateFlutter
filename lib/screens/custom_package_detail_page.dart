// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class CustomPackageDetailPage extends StatefulWidget {
//   final int packageId;

//   const CustomPackageDetailPage({
//     super.key,
//     required this.packageId,
//     required packageData,
//   });

//   @override
//   State<CustomPackageDetailPage> createState() =>
//       _CustomPackageDetailPageState();
// }

// class _CustomPackageDetailPageState extends State<CustomPackageDetailPage> {
//   Map<String, dynamic>? customPackage;
//   List<dynamic> services = [];
//   List<dynamic> predefinedPackages = [];
//   bool isLoading = true;

//   bool isOneDaySelected = true;
//   DateTime? selectedDate;
//   DateTimeRange? selectedRange;

//   bool isSelectingRangeStart = true;
//   DateTime? tempStart;
//   DateTime? tempEnd;

//   @override
//   void initState() {
//     super.initState();
//     fetchPackageDetails();
//   }

//   Future<void> fetchPackageDetails() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "http://192.168.1.6:8000/api/showCustomPackageData/${widget.packageId}",
//         ),
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         setState(() {
//           customPackage = jsonData['data'];
//           services = jsonData['0'] ?? [];
//           predefinedPackages = jsonData['1'] ?? [];
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load package details');
//       }
//     } catch (e) {
//       print("Error fetching package: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> checkDateAvailability() async {
//     if (customPackage == null) return;

//     final vendorId = customPackage!['vendor_id'];
//     final String startDate =
//         isOneDaySelected
//             ? selectedDate!.toIso8601String().split('T')[0]
//             : selectedRange!.start.toIso8601String().split('T')[0];
//     final String? endDate =
//         isOneDaySelected
//             ? null
//             : selectedRange!.end.toIso8601String().split('T')[0];

//     print("Vendor ID: $vendorId");
//     print("Start Date: $startDate");
//     print("End Date: ${endDate ?? 'N/A'}");

//     try {
//       final response = await http.post(
//         Uri.parse("http://192.168.1.6:8000/api/checkdate"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "vendor_id": vendorId,
//           "start_date": startDate,
//           "end_date": endDate,
//         }),
//       );

//       final data = json.decode(response.body);
//       showDialog(
//         context: context,
//         builder:
//             (_) => AlertDialog(
//               title: Text(
//                 data['status'] == 'available' ? "Available" : "Not Available",
//               ),
//               content: Text(data['message']),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("OK"),
//                 ),
//               ],
//             ),
//       );
//     } catch (e) {
//       print("API error: $e");
//     }
//   }

//   void showDatePickerModal() {
//     DateTime? tempDate = selectedDate;
//     DateTimeRange? tempRange = selectedRange;
//     bool tempIsOneDay = isOneDaySelected;

//     tempStart = null;
//     tempEnd = null;
//     isSelectingRangeStart = true;

//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: StatefulBuilder(
//               builder: (context, setModalState) {
//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         "Select Booking Type",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ChoiceChip(
//                             label: const Text("One Day"),
//                             selected: tempIsOneDay,
//                             onSelected: (_) {
//                               setModalState(() {
//                                 tempIsOneDay = true;
//                                 tempDate = null;
//                               });
//                             },
//                             selectedColor: Colors.orange.shade200,
//                           ),
//                           const SizedBox(width: 10),
//                           ChoiceChip(
//                             label: const Text("Date Range"),
//                             selected: !tempIsOneDay,
//                             onSelected: (_) {
//                               setModalState(() {
//                                 tempIsOneDay = false;
//                                 tempStart = null;
//                                 tempEnd = null;
//                                 isSelectingRangeStart = true;
//                               });
//                             },
//                             selectedColor: Colors.orange.shade200,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),

//                       if (tempIsOneDay && tempDate != null)
//                         Text(
//                           "Selected: ${tempDate!.toLocal().toString().split(' ')[0]}",
//                           style: const TextStyle(
//                             color: Colors.deepOrange,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         )
//                       else if (!tempIsOneDay && tempStart != null)
//                         Text(
//                           tempEnd == null
//                               ? "Start: ${tempStart!.toLocal().toString().split(' ')[0]}"
//                               : "Selected: ${tempStart!.toLocal().toString().split(' ')[0]} → ${tempEnd!.toLocal().toString().split(' ')[0]}",
//                           style: const TextStyle(
//                             color: Colors.deepOrange,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       const SizedBox(height: 16),

//                       CalendarDatePicker(
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime(2100),
//                         onDateChanged: (date) {
//                           setModalState(() {
//                             if (tempIsOneDay) {
//                               tempDate = date;
//                             } else {
//                               if (isSelectingRangeStart) {
//                                 tempStart = date;
//                                 tempEnd = null;
//                                 isSelectingRangeStart = false;
//                               } else {
//                                 if (tempStart != null &&
//                                     date.isAfter(tempStart!)) {
//                                   tempEnd = date;
//                                   tempRange = DateTimeRange(
//                                     start: tempStart!,
//                                     end: tempEnd!,
//                                   );
//                                 } else {
//                                   tempStart = date;
//                                   tempEnd = null;
//                                   tempRange = null;
//                                   isSelectingRangeStart = false;
//                                 }
//                               }
//                             }
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20),

//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             isOneDaySelected = tempIsOneDay;
//                             selectedDate = tempDate;
//                             selectedRange = tempRange;
//                           });

//                           Navigator.pop(context);
//                           checkDateAvailability();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepOrange,
//                         ),
//                         child: const Text("OK"),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget displaySelectedDate() {
//     if (isOneDaySelected && selectedDate != null) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 10),
//         child: Text(
//           "Selected: ${selectedDate!.toLocal().toString().split(' ')[0]}",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.deepOrange,
//           ),
//         ),
//       );
//     } else if (!isOneDaySelected && selectedRange != null) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 10),
//         child: Text(
//           "Selected: ${selectedRange!.start.toLocal().toString().split(' ')[0]} → ${selectedRange!.end.toLocal().toString().split(' ')[0]}",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.deepOrange,
//           ),
//         ),
//       );
//     }
//     return const SizedBox.shrink();
//   }

//   Widget buildImageSlider(String? imagesString, String folder) {
//     if (imagesString == null || imagesString.isEmpty) {
//       return const Icon(Icons.image_not_supported, size: 100);
//     }

//     List<String> imageList = imagesString.split(',');

//     return SizedBox(
//       height: 200,
//       child: PageView.builder(
//         itemCount: imageList.length,
//         itemBuilder: (context, index) {
//           final imageName = imageList[index].trim();
//           final imageUrl = "http://192.168.1.6:8000/$folder/$imageName";
//           return GestureDetector(
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder:
//                     (_) => Dialog(
//                       child: InteractiveViewer(
//                         child: Image.network(imageUrl, fit: BoxFit.contain),
//                       ),
//                     ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder:
//                       (context, error, stackTrace) =>
//                           const Icon(Icons.broken_image, size: 100),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Custom Package Details")),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : customPackage == null
//               ? const Center(child: Text("No data found"))
//               : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Package Name: ${customPackage!['package_name']}",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text("Description: ${customPackage!['description']}"),
//                     const SizedBox(height: 20),
//                     Center(
//                       child: Text(
//                         "Total Cost: ₹${customPackage!['totalcost']}",
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Color.fromARGB(255, 10, 10, 10),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       "Included Services",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ...services.map(
//                       (service) => Card(
//                         color: const Color(0xFFFFF3E0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 4,
//                         margin: const EdgeInsets.symmetric(vertical: 10),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 service['service_type'] ?? 'No Service Name',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(service['description'] ?? "No Description"),
//                               const SizedBox(height: 6),
//                               Text(
//                                 "₹${service['price']}",
//                                 style: const TextStyle(
//                                   color: Colors.green,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               buildImageSlider(
//                                 service['images'],
//                                 'service-image',
//                               ),
//                               displaySelectedDate(),
//                               const SizedBox(height: 10),
//                               Center(
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.deepOrange,
//                                   ),
//                                   onPressed: showDatePickerModal,
//                                   child: const Text("Select"),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const Divider(height: 30),
//                     if (predefinedPackages.isNotEmpty) ...[
//                       Text(
//                         "Predefined Packages",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       ...predefinedPackages.map(
//                         (pkg) => Card(
//                           color: const Color(0xFFFFF3E0),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 4,
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   pkg['package_name'] ?? 'No Name',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 6),
//                                 Text(pkg['description'] ?? 'No Description'),
//                                 const SizedBox(height: 6),
//                                 Text(
//                                   "₹${pkg['price']}",
//                                   style: const TextStyle(
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 buildImageSlider(
//                                   pkg['images'],
//                                   'package-image',
//                                 ),
//                                 displaySelectedDate(),
//                                 const SizedBox(height: 10),
//                                 Center(
//                                   child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.deepOrange,
//                                     ),
//                                     onPressed: showDatePickerModal,
//                                     child: const Text("Select"),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class CustomPackageDetailPage extends StatefulWidget {
//   final int packageId;

//   const CustomPackageDetailPage({
//     super.key,
//     required this.packageId,
//     required packageData,
//   });

//   @override
//   State<CustomPackageDetailPage> createState() =>
//       _CustomPackageDetailPageState();
// }

// class _CustomPackageDetailPageState extends State<CustomPackageDetailPage> {

//   Map<String, dynamic>? customPackage;
//   List<dynamic> services = [];
//   List<dynamic> predefinedPackages = [];
//   bool isLoading = true;

//   bool isOneDaySelected = true;
//   DateTime? selectedDate;
//   DateTimeRange? selectedRange;

//   int? currentVendorId; // <-- Track vendor_id for currently selected item

//   @override
//   void initState() {
//     super.initState();
//     fetchPackageDetails();
//   }

//   Future<void> fetchPackageDetails() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           "http://192.168.1.6:8000/api/showCustomPackageData/${widget.packageId}",
//         ),
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         setState(() {
//           customPackage = jsonData['data'];
//           services = jsonData['0'] ?? [];
//           predefinedPackages = jsonData['1'] ?? [];
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load package details');
//       }
//     } catch (e) {
//       print("Error fetching package: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> checkDateAvailability(int vendorId) async {
//     if ((isOneDaySelected && selectedDate == null) ||
//         (!isOneDaySelected && selectedRange == null)) {
//       return;
//     }

//     final String startDate =
//         isOneDaySelected
//             ? selectedDate!.toIso8601String().split('T')[0]
//             : selectedRange!.start.toIso8601String().split('T')[0];
//     final String? endDate =
//         isOneDaySelected
//             ? null
//             : selectedRange!.end.toIso8601String().split('T')[0];

//     print("Vendor ID: $vendorId");
//     print("Start Date: $startDate");
//     print("End Date: ${endDate ?? 'N/A'}");

//     try {
//       final response = await http.post(
//         Uri.parse("http://192.168.1.6:8000/api/checkdate"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           "vendor_id": vendorId,
//           "start_date": startDate,
//           "end_date": endDate,
//         }),
//       );

//       final data = json.decode(response.body);
//       showDialog(
//         context: context,
//         builder:
//             (_) => AlertDialog(
//               title: Text(
//                 data['status'] == 'available' ? "Available" : "Not Available",
//               ),
//               content: Text(data['message']),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("OK"),
//                 ),
//               ],
//             ),
//       );
//     } catch (e) {
//       print("API error: $e");
//     }
//   }

//   void showDatePickerModal(int vendorId) {
//     DateTime? tempDate = selectedDate;
//     DateTimeRange? tempRange = selectedRange;
//     bool tempIsOneDay = isOneDaySelected;
//     bool isSelectingRangeStart = true;
//     DateTime? tempStart;
//     DateTime? tempEnd;

//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: StatefulBuilder(
//               builder: (context, setModalState) {
//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         "Select Booking Type",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ChoiceChip(
//                             label: const Text("One Day"),
//                             selected: tempIsOneDay,
//                             onSelected: (_) {
//                               setModalState(() {
//                                 tempIsOneDay = true;
//                                 tempDate = null;
//                               });
//                             },
//                             selectedColor: Colors.orange.shade200,
//                           ),
//                           const SizedBox(width: 10),
//                           ChoiceChip(
//                             label: const Text("Date Range"),
//                             selected: !tempIsOneDay,
//                             onSelected: (_) {
//                               setModalState(() {
//                                 tempIsOneDay = false;
//                                 tempStart = null;
//                                 tempEnd = null;
//                                 isSelectingRangeStart = true;
//                               });
//                             },
//                             selectedColor: Colors.orange.shade200,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       if (tempIsOneDay && tempDate != null)
//                         Text(
//                           "Selected: ${tempDate!.toLocal().toString().split(' ')[0]}",
//                           style: const TextStyle(
//                             color: Colors.deepOrange,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         )
//                       else if (!tempIsOneDay && tempStart != null)
//                         Text(
//                           tempEnd == null
//                               ? "Start: ${tempStart!.toLocal().toString().split(' ')[0]}"
//                               : "Selected: ${tempStart!.toLocal().toString().split(' ')[0]} → ${tempEnd!.toLocal().toString().split(' ')[0]}",
//                           style: const TextStyle(
//                             color: Colors.deepOrange,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       const SizedBox(height: 16),
//                       CalendarDatePicker(
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime(2100),
//                         onDateChanged: (date) {
//                           setModalState(() {
//                             if (tempIsOneDay) {
//                               tempDate = date;
//                             } else {
//                               if (isSelectingRangeStart) {
//                                 tempStart = date;
//                                 tempEnd = null;
//                                 isSelectingRangeStart = false;
//                               } else {
//                                 if (tempStart != null &&
//                                     date.isAfter(tempStart!)) {
//                                   tempEnd = date;
//                                   tempRange = DateTimeRange(
//                                     start: tempStart!,
//                                     end: tempEnd!,
//                                   );
//                                 } else {
//                                   tempStart = date;
//                                   tempEnd = null;
//                                   tempRange = null;
//                                   isSelectingRangeStart = false;
//                                 }
//                               }
//                             }
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             isOneDaySelected = tempIsOneDay;
//                             selectedDate = tempDate;
//                             selectedRange = tempRange;
//                           });
//                           Navigator.pop(context);
//                           checkDateAvailability(
//                             vendorId,
//                           ); // pass correct vendorId
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepOrange,
//                         ),
//                         child: const Text("OK"),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget displaySelectedDate() {
//     if (isOneDaySelected && selectedDate != null) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 10),
//         child: Text(
//           "Selected: ${selectedDate!.toLocal().toString().split(' ')[0]}",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.deepOrange,
//           ),
//         ),
//       );
//     } else if (!isOneDaySelected && selectedRange != null) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 10),
//         child: Text(
//           "Selected: ${selectedRange!.start.toLocal().toString().split(' ')[0]} → ${selectedRange!.end.toLocal().toString().split(' ')[0]}",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.deepOrange,
//           ),
//         ),
//       );
//     }
//     return const SizedBox.shrink();
//   }

//   Widget buildImageSlider(String? imagesString, String folder) {
//     if (imagesString == null || imagesString.isEmpty) {
//       return const Icon(Icons.image_not_supported, size: 100);
//     }

//     List<String> imageList = imagesString.split(',');

//     return SizedBox(
//       height: 200,
//       child: PageView.builder(
//         itemCount: imageList.length,
//         itemBuilder: (context, index) {
//           final imageUrl =
//               "http://192.168.1.6:8000/$folder/${imageList[index].trim()}";
//           return GestureDetector(
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder:
//                     (_) => Dialog(
//                       child: InteractiveViewer(
//                         child: Image.network(imageUrl, fit: BoxFit.contain),
//                       ),
//                     ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder:
//                       (_, __, ___) => const Icon(Icons.broken_image, size: 100),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Custom Package Details")),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : customPackage == null
//               ? const Center(child: Text("No data found"))
//               : SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Package Name: ${customPackage!['package_name']}",
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text("Description: ${customPackage!['description']}"),
//                     const SizedBox(height: 20),
//                     Center(
//                       child: Text(
//                         "Total Cost: ₹${customPackage!['totalcost']}",
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       "Included Services",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ...services.map(
//                       (service) =>
//                           buildServiceOrPackageCard(service, 'service-image'),
//                     ),
//                     const Divider(height: 30),
//                     if (predefinedPackages.isNotEmpty) ...[
//                       Text(
//                         "Predefined Packages",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       ...predefinedPackages.map(
//                         (pkg) =>
//                             buildServiceOrPackageCard(pkg, 'package-image'),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//     );
//   }

//   Widget buildServiceOrPackageCard(dynamic item, String imageFolder) {
//     return Card(
//       color: const Color(0xFFFFF3E0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               item['service_type'] ?? item['package_name'] ?? 'No Name',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Text(item['description'] ?? "No Description"),
//             const SizedBox(height: 6),
//             Text(
//               "₹${item['price']}",
//               style: const TextStyle(
//                 color: Colors.green,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 12),
//             buildImageSlider(item['images'], imageFolder),
//             displaySelectedDate(),
//             const SizedBox(height: 10),
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrange,
//                 ),
//                 onPressed: () => showDatePickerModal(item['vendor_id']),
//                 child: const Text("Select"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // New maps for tracking selection per vendor
  Map<int, bool> isOneDaySelectedMap = {};
  Map<int, DateTime?> selectedDateMap = {};
  Map<int, DateTimeRange?> selectedRangeMap = {};

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

  Future<void> checkDateAvailability(int vendorId) async {
    final bool isOneDaySelected = isOneDaySelectedMap[vendorId] ?? true;
    final DateTime? selectedDate = selectedDateMap[vendorId];
    final DateTimeRange? selectedRange = selectedRangeMap[vendorId];

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
        Uri.parse("http://192.168.1.6:8000/api/checkdate"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "vendor_id": vendorId,
          "start_date": startDate,
          "end_date": endDate,
        }),
      );

      final data = json.decode(response.body);
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(
                data['status'] == 'available' ? "Available" : "Not Available",
              ),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    } catch (e) {
      print("API error: $e");
    }
  }

  void showDatePickerModal(int vendorId) {
    bool tempIsOneDay = isOneDaySelectedMap[vendorId] ?? true;
    DateTime? tempDate = selectedDateMap[vendorId];
    DateTimeRange? tempRange = selectedRangeMap[vendorId];

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
                        onPressed: () {
                          setState(() {
                            isOneDaySelectedMap[vendorId] = tempIsOneDay;
                            selectedDateMap[vendorId] = tempDate;
                            selectedRangeMap[vendorId] = tempRange;
                          });
                          Navigator.pop(context);
                          checkDateAvailability(vendorId);
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

  Widget displaySelectedDate(int vendorId) {
    final bool isOneDaySelected = isOneDaySelectedMap[vendorId] ?? true;
    final DateTime? selectedDate = selectedDateMap[vendorId];
    final DateTimeRange? selectedRange = selectedRangeMap[vendorId];

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
              "http://192.168.1.6:8000/$folder/${imageList[index].trim()}";
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
              item['service_type'] ?? item['package_name'] ?? 'No Name',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(item['description'] ?? "No Description"),
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
            displaySelectedDate(vendorId),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                onPressed: () => showDatePickerModal(vendorId),
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
                    ],
                  ],
                ),
              ),
    );
  }
}
