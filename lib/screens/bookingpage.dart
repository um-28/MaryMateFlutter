// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:another_flushbar/flushbar.dart';
// import 'dart:convert';

// class BookingPage extends StatefulWidget {
//   const BookingPage({super.key});

//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   bool isLoading = true;
//   List<dynamic> regularOrders = [];
//   List<dynamic> customBookingOrders = [];
//   Set<String> cancelledBookingIds = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchUserIdAndData();
//   }

//   Future<void> fetchUserIdAndData() async {
//     final prefs = await SharedPreferences.getInstance();
//     int? userId = prefs.getInt('user_id');

//     if (userId == null || userId == 0) {
//       setState(() => isLoading = false);
//       showTopFlush("User not logged in", Colors.red);
//       return;
//     }

//     final url = Uri.parse(
//       'http://192.168.1.4:8000/api/Orderhistory?user_id=$userId',
//     );

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['status'] == true) {
//           setState(() {
//             regularOrders = jsonData['regularorders'] ?? [];
//             customBookingOrders = jsonData['custombookingorders'] ?? [];
//             isLoading = false;
//           });
//         } else {
//           setState(() => isLoading = false);
//         }
//       } else {
//         setState(() => isLoading = false);
//         showTopFlush("Server Error: ${response.statusCode}", Colors.red);
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       showTopFlush("Error: $e", Colors.red);
//     }
//   }

//   void showTopFlush(String message, Color color) {
//     Flushbar(
//       message: message,
//       backgroundColor: color,
//       duration: const Duration(seconds: 3),
//       flushbarPosition: FlushbarPosition.TOP,
//       margin: const EdgeInsets.all(8),
//       borderRadius: BorderRadius.circular(8),
//     ).show(context);
//   }

//   void cancelBooking(dynamic booking) async {
//     final bookingId = booking['bookingId'] ?? booking['cdbookingId'];
//     final isCustom = booking['cdbookingId'] != null;
//     final endpoint =
//         isCustom
//             ? "check-customcancel-eligibility"
//             : "check-regularcancel-eligibility";

//     final url = Uri.parse("http://192.168.1.4:8000/api/$endpoint/$bookingId");

//     try {
//       final response = await http.get(url);
//       final data = json.decode(response.body);

//       if (response.statusCode == 200 && data['can_cancel'] == true) {
//         setState(() {
//           cancelledBookingIds.add(bookingId.toString());

//           if (isCustom) {
//             int index = customBookingOrders.indexWhere(
//               (b) => b['cdbookingId'].toString() == bookingId.toString(),
//             );
//             if (index != -1) {
//               customBookingOrders[index] = {
//                 ...customBookingOrders[index],
//                 'status': '1',
//               };
//               customBookingOrders = List.from(customBookingOrders);
//             }
//           } else {
//             int index = regularOrders.indexWhere(
//               (b) => b['bookingId'].toString() == bookingId.toString(),
//             );
//             if (index != -1) {
//               regularOrders[index] = {...regularOrders[index], 'status': '1'};
//               regularOrders = List.from(regularOrders);
//             }
//           }
//         });

//         showTopFlush("Your booking is cancelled.", Colors.green);
//       } else {
//         showTopFlush(
//           data['message'] ??
//               "Booking not eligible to cancel. Less than 7 days remaining.",
//           Colors.red,
//         );
//       }
//     } catch (e) {
//       showTopFlush("⚠️ Error checking cancellation", Colors.orange);
//     }
//   }

//   Widget buildBookingCard(dynamic order, {bool isCustom = false}) {
//     final bookingId = order['bookingId'] ?? order['cdbookingId'] ?? 'N/A';
//     final bookingStatus = (order['status'] ?? '0').toString();
//     final isCanceledFinal =
//         bookingStatus == '1' ||
//         cancelledBookingIds.contains(bookingId.toString());

//     return Card(
//       color: isCanceledFinal ? Colors.red[50] : Colors.white,
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.deepOrange.shade100),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Booking ID: $bookingId",
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Services: ${order['service_names']?.join(', ') ?? 'N/A'}",
//               style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Packages: ${order['package_names']?.join(', ') ?? 'N/A'}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),

//             if (!isCustom) ...[
//               Text("Start Date: ${order['event_date_start'] ?? 'N/A'}"),
//               Text("End Date: ${order['event_date_end'] ?? 'N/A'}"),
//             ],
//             if (isCustom &&
//                 (order['event_date_start']?.toString().trim().isNotEmpty ??
//                     false))
//               Text("Start Date: ${order['event_date_start']}"),
//             if (isCustom &&
//                 (order['event_date_end']?.toString().trim().isNotEmpty ??
//                     false))
//               Text("End Date: ${order['event_date_end']}"),

//             const SizedBox(height: 6),
//             Text(
//               "Business Name: ${order['business_name']?.join(', ') ?? 'N/A'}",
//               style: const TextStyle(color: Colors.black87),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Total Price: ₹${order['totalprice']?.toString() ?? '0'}",
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Booking Status: $bookingStatus",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             if (isCustom) ...[
//               if ((order['service_startdate'] ?? '')
//                   .toString()
//                   .trim()
//                   .isNotEmpty)
//                 Text("Service Start Date: ${order['service_startdate']}"),
//               if ((order['service_enddate'] ?? '').toString().trim().isNotEmpty)
//                 Text("Service End Date: ${order['service_enddate']}"),
//               if ((order['package_startdate'] ?? '')
//                   .toString()
//                   .trim()
//                   .isNotEmpty)
//                 Text("Package Start Date: ${order['package_startdate']}"),
//               if ((order['package_enddate'] ?? '').toString().trim().isNotEmpty)
//                 Text("Package End Date: ${order['package_enddate']}"),
//             ],

//             const SizedBox(height: 12),
//             Center(
//               child:
//                   isCanceledFinal
//                       ? Column(
//                         children: const [
//                           Icon(Icons.cancel, color: Colors.red, size: 30),
//                           SizedBox(height: 6),
//                           Text(
//                             "Your booking is cancelled.",
//                             style: TextStyle(
//                               color: Colors.red,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       )
//                       : ElevatedButton.icon(
//                         onPressed: () => cancelBooking(order),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepOrange,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 12,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 4,
//                         ),
//                         icon: const Icon(Icons.cancel),
//                         label: const Text(
//                           "Cancel Booking",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Bookings"),
//         backgroundColor: Colors.deepOrange,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : ListView(
//                 padding: const EdgeInsets.all(12),
//                 children: [
//                   if (regularOrders.isNotEmpty) ...[
//                     const Text(
//                       "Regular Bookings:",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...regularOrders.map((order) => buildBookingCard(order)),
//                   ],
//                   if (customBookingOrders.isNotEmpty) ...[
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Custom Bookings:",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...customBookingOrders.map(
//                       (order) => buildBookingCard(order, isCustom: true),
//                     ),
//                   ],
//                   if (regularOrders.isEmpty && customBookingOrders.isEmpty)
//                     const Center(
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 50),
//                         child: Text("No bookings found."),
//                       ),
//                     ),
//                 ],
//               ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:another_flushbar/flushbar.dart';
// import 'dart:convert';
// import 'package:intl/intl.dart';

// class BookingPage extends StatefulWidget {
//   const BookingPage({super.key});

//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   bool isLoading = true;
//   List<dynamic> regularOrders = [];
//   List<dynamic> customBookingOrders = [];
//   Set<String> cancelledBookingIds = {};

//   int? userId;
//   Map<String, double> ratings = {};
//   Map<String, TextEditingController> reviewControllers = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchUserIdAndData();
//   }

//   Future<void> fetchUserIdAndData() async {
//     final prefs = await SharedPreferences.getInstance();
//     userId = prefs.getInt('user_id');

//     if (userId == null || userId == 0) {
//       setState(() => isLoading = false);
//       showTopFlush("User not logged in", Colors.red);
//       return;
//     }

//     final url = Uri.parse(
//       'http://192.168.1.4:8000/api/Orderhistory?user_id=$userId',
//     );

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['status'] == true) {
//           setState(() {
//             regularOrders = jsonData['regularorders'] ?? [];
//             customBookingOrders = jsonData['custombookingorders'] ?? [];
//             isLoading = false;
//           });
//         } else {
//           setState(() => isLoading = false);
//         }
//       } else {
//         setState(() => isLoading = false);
//         showTopFlush("Server Error: ${response.statusCode}", Colors.red);
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       showTopFlush("Error: $e", Colors.red);
//     }
//   }

//   void showTopFlush(String message, Color color) {
//     Flushbar(
//       message: message,
//       backgroundColor: color,
//       duration: const Duration(seconds: 3),
//       flushbarPosition: FlushbarPosition.TOP,
//       margin: const EdgeInsets.all(8),
//       borderRadius: BorderRadius.circular(8),
//     ).show(context);
//   }

//   bool isPastBooking(String? dateStr) {
//     if (dateStr == null || dateStr.trim().isEmpty) return false;
//     try {
//       DateTime date = DateFormat("yyyy-MM-dd").parse(dateStr);
//       return date.isBefore(DateTime.now());
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> submitReview(String bookingId) async {
//     double? rating = ratings[bookingId];
//     String reviewText = reviewControllers[bookingId]?.text ?? "";

//     if (rating == null || reviewText.isEmpty) {
//       showTopFlush("Please give rating & write review", Colors.red);
//       return;
//     }

//     final url = Uri.parse("http://192.168.1.4:8000/api/BookingReview");
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: json.encode({
//           "user_id": userId,
//           "booking_id": bookingId,
//           "rating": rating,
//           "review_text": reviewText,
//         }),
//       );

//       if (response.statusCode == 200) {
//         showTopFlush("Review submitted successfully", Colors.green);
//         setState(() {
//           ratings.remove(bookingId);
//           reviewControllers[bookingId]?.clear();
//         });
//       } else {
//         showTopFlush("Failed to submit review", Colors.red);
//       }
//     } catch (e) {
//       showTopFlush("Error submitting review", Colors.red);
//     }
//   }

//   void cancelBooking(dynamic booking) async {
//     final bookingId = booking['bookingId'] ?? booking['cdbookingId'];
//     final isCustom = booking['cdbookingId'] != null;
//     final endpoint =
//         isCustom
//             ? "check-customcancel-eligibility"
//             : "check-regularcancel-eligibility";

//     final url = Uri.parse("http://192.168.1.4:8000/api/$endpoint/$bookingId");

//     try {
//       final response = await http.get(url);
//       final data = json.decode(response.body);

//       if (response.statusCode == 200 && data['can_cancel'] == true) {
//         setState(() {
//           cancelledBookingIds.add(bookingId.toString());

//           if (isCustom) {
//             int index = customBookingOrders.indexWhere(
//               (b) => b['cdbookingId'].toString() == bookingId.toString(),
//             );
//             if (index != -1) {
//               customBookingOrders[index] = {
//                 ...customBookingOrders[index],
//                 'status': '1',
//               };
//               customBookingOrders = List.from(customBookingOrders);
//             }
//           } else {
//             int index = regularOrders.indexWhere(
//               (b) => b['bookingId'].toString() == bookingId.toString(),
//             );
//             if (index != -1) {
//               regularOrders[index] = {...regularOrders[index], 'status': '1'};
//               regularOrders = List.from(regularOrders);
//             }
//           }
//         });

//         showTopFlush("Your booking is cancelled.", Colors.green);
//       } else {
//         showTopFlush(
//           data['message'] ??
//               "Booking not eligible to cancel. Less than 7 days remaining.",
//           Colors.red,
//         );
//       }
//     } catch (e) {
//       showTopFlush("⚠️ Error checking cancellation", Colors.orange);
//     }
//   }

//   Widget buildBookingCard(dynamic order, {bool isCustom = false}) {
//     final bookingId = order['bookingId'] ?? order['cdbookingId'] ?? 'N/A';
//     final bookingStatus = (order['status'] ?? '0').toString();
//     final isCanceledFinal =
//         bookingStatus == '1' ||
//         cancelledBookingIds.contains(bookingId.toString());

//     String? endDate = order['event_date_end'];
//     if (isCustom &&
//         (order['package_enddate'] ?? '').toString().trim().isNotEmpty) {
//       endDate = order['package_enddate'];
//     }

//     reviewControllers.putIfAbsent(
//       bookingId.toString(),
//       () => TextEditingController(),
//     );

//     return Card(
//       color: isCanceledFinal ? Colors.red[50] : Colors.white,
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.deepOrange.shade100),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Booking ID: $bookingId",
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Services: ${order['service_names']?.join(', ') ?? 'N/A'}",
//               style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Packages: ${order['package_names']?.join(', ') ?? 'N/A'}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),

//             if (!isCustom) ...[
//               Text("Start Date: ${order['event_date_start'] ?? 'N/A'}"),
//               Text("End Date: ${order['event_date_end'] ?? 'N/A'}"),
//             ],
//             if (isCustom &&
//                 (order['event_date_start']?.toString().trim().isNotEmpty ??
//                     false))
//               Text("Start Date: ${order['event_date_start']}"),
//             if (isCustom &&
//                 (order['event_date_end']?.toString().trim().isNotEmpty ??
//                     false))
//               Text("End Date: ${order['event_date_end']}"),

//             const SizedBox(height: 6),
//             Text(
//               "Business Name: ${order['business_name']?.join(', ') ?? 'N/A'}",
//               style: const TextStyle(color: Colors.black87),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Total Price: ₹${order['totalprice']?.toString() ?? '0'}",
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Booking Status: $bookingStatus",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             if (isCustom) ...[
//               if ((order['service_startdate'] ?? '')
//                   .toString()
//                   .trim()
//                   .isNotEmpty)
//                 Text("Service Start Date: ${order['service_startdate']}"),
//               if ((order['service_enddate'] ?? '').toString().trim().isNotEmpty)
//                 Text("Service End Date: ${order['service_enddate']}"),
//               if ((order['package_startdate'] ?? '')
//                   .toString()
//                   .trim()
//                   .isNotEmpty)
//                 Text("Package Start Date: ${order['package_startdate']}"),
//               if ((order['package_enddate'] ?? '').toString().trim().isNotEmpty)
//                 Text("Package End Date: ${order['package_enddate']}"),
//             ],

//             const SizedBox(height: 12),
//             Center(
//               child:
//                   isCanceledFinal
//                       ? Column(
//                         children: const [
//                           Icon(Icons.cancel, color: Colors.red, size: 30),
//                           SizedBox(height: 6),
//                           Text(
//                             "Your booking is cancelled.",
//                             style: TextStyle(
//                               color: Colors.red,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       )
//                       : ElevatedButton.icon(
//                         onPressed: () => cancelBooking(order),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepOrange,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 12,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 4,
//                         ),
//                         icon: const Icon(Icons.cancel),
//                         label: const Text(
//                           "Cancel Booking",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//             ),

//             /// REVIEW SECTION (only if past booking date)
//             if (isPastBooking(endDate)) ...[
//               const Divider(height: 30, thickness: 1),
//               const Text(
//                 "Your Rating:",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Row(
//                 children: List.generate(5, (i) {
//                   double starValue = i + 1.0;
//                   return IconButton(
//                     icon: Icon(
//                       ratings[bookingId.toString()] != null &&
//                               ratings[bookingId.toString()]! >= starValue
//                           ? Icons.star
//                           : Icons.star_border,
//                       color: Colors.amber,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         ratings[bookingId.toString()] = starValue;
//                       });
//                     },
//                   );
//                 }),
//               ),
//               TextField(
//                 controller: reviewControllers[bookingId.toString()],
//                 decoration: const InputDecoration(
//                   labelText: "Your experience booking service",
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 8),
//               ElevatedButton(
//                 onPressed: () => submitReview(bookingId.toString()),
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                 child: const Text("Submit Review"),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Bookings"),
//         backgroundColor: Colors.deepOrange,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : ListView(
//                 padding: const EdgeInsets.all(12),
//                 children: [
//                   if (regularOrders.isNotEmpty) ...[
//                     const Text(
//                       "Regular Bookings:",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...regularOrders.map((order) => buildBookingCard(order)),
//                   ],
//                   if (customBookingOrders.isNotEmpty) ...[
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Custom Bookings:",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...customBookingOrders.map(
//                       (order) => buildBookingCard(order, isCustom: true),
//                     ),
//                   ],
//                   if (regularOrders.isEmpty && customBookingOrders.isEmpty)
//                     const Center(
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 50),
//                         child: Text("No bookings found."),
//                       ),
//                     ),
//                 ],
//               ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:another_flushbar/flushbar.dart';
// import 'dart:convert';
// import 'package:intl/intl.dart';

// class BookingPage extends StatefulWidget {
//   const BookingPage({super.key});

//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   bool isLoading = true;
//   List<dynamic> regularOrders = [];
//   List<dynamic> customBookingOrders = [];
//   Set<String> cancelledBookingIds = {};

//   int? userId;
//   Map<String, double> ratings = {};
//   Map<String, TextEditingController> reviewControllers = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchUserIdAndData();
//   }

//   Future<void> fetchUserIdAndData() async {
//     final prefs = await SharedPreferences.getInstance();
//     userId = prefs.getInt('user_id');

//     if (userId == null || userId == 0) {
//       setState(() => isLoading = false);
//       showTopFlush("User not logged in", Colors.red);
//       return;
//     }

//     final url = Uri.parse(
//       'http://192.168.1.4:8000/api/Orderhistory?user_id=$userId',
//     );

//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['status'] == true) {
//           setState(() {
//             regularOrders = jsonData['regularorders'] ?? [];
//             customBookingOrders = jsonData['custombookingorders'] ?? [];
//             isLoading = false;
//           });
//         } else {
//           setState(() => isLoading = false);
//         }
//       } else {
//         setState(() => isLoading = false);
//         showTopFlush("Server Error: ${response.statusCode}", Colors.red);
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       showTopFlush("Error: $e", Colors.red);
//     }
//   }

//   void showTopFlush(String message, Color color) {
//     Flushbar(
//       message: message,
//       backgroundColor: color,
//       duration: const Duration(seconds: 3),
//       flushbarPosition: FlushbarPosition.TOP,
//       margin: const EdgeInsets.all(8),
//       borderRadius: BorderRadius.circular(8),
//     ).show(context);
//   }

//   bool isPastBooking(String? dateStr) {
//     if (dateStr == null || dateStr.trim().isEmpty || dateStr.trim() == "-") {
//       // No date or invalid date -> allow review
//       return true;
//     }
//     try {
//       DateTime date = DateFormat("yyyy-MM-dd").parse(dateStr);
//       return date.isBefore(DateTime.now());
//     } catch (e) {
//       // Invalid format -> allow review
//       return true;
//     }
//   }

//   Future<void> submitReview(String bookingId) async {
//     double? rating = ratings[bookingId];
//     String reviewText = reviewControllers[bookingId]?.text ?? "";

//     if (rating == null || reviewText.isEmpty) {
//       showTopFlush("Please give rating & write review", Colors.red);
//       return;
//     }

//     final url = Uri.parse("http://192.168.1.4:8000/api/BookingReview");
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: json.encode({
//           "user_id": userId,
//           "booking_id": bookingId,
//           "rating": rating,
//           "review_text": reviewText,
//         }),
//       );

//       if (response.statusCode == 200) {
//         showTopFlush("Review submitted successfully", Colors.green);
//         setState(() {
//           ratings.remove(bookingId);
//           reviewControllers[bookingId]?.clear();
//         });
//       } else {
//         showTopFlush("Failed to submit review", Colors.red);
//       }
//     } catch (e) {
//       showTopFlush("Error submitting review", Colors.red);
//     }
//   }

//   void cancelBooking(dynamic booking) async {
//     final bookingId = booking['bookingId'] ?? booking['cdbookingId'];
//     final isCustom = booking['cdbookingId'] != null;
//     final endpoint =
//         isCustom
//             ? "check-customcancel-eligibility"
//             : "check-regularcancel-eligibility";

//     final url = Uri.parse("http://192.168.1.4:8000/api/$endpoint/$bookingId");

//     try {
//       final response = await http.get(url);
//       final data = json.decode(response.body);

//       if (response.statusCode == 200 && data['can_cancel'] == true) {
//         setState(() {
//           cancelledBookingIds.add(bookingId.toString());

//           if (isCustom) {
//             int index = customBookingOrders.indexWhere(
//               (b) => b['cdbookingId'].toString() == bookingId.toString(),
//             );
//             if (index != -1) {
//               customBookingOrders[index] = {
//                 ...customBookingOrders[index],
//                 'status': '1',
//               };
//               customBookingOrders = List.from(customBookingOrders);
//             }
//           } else {
//             int index = regularOrders.indexWhere(
//               (b) => b['bookingId'].toString() == bookingId.toString(),
//             );
//             if (index != -1) {
//               regularOrders[index] = {...regularOrders[index], 'status': '1'};
//               regularOrders = List.from(regularOrders);
//             }
//           }
//         });

//         showTopFlush("Your booking is cancelled.", Colors.green);
//       } else {
//         showTopFlush(
//           data['message'] ??
//               "Booking not eligible to cancel. Less than 7 days remaining.",
//           Colors.red,
//         );
//       }
//     } catch (e) {
//       showTopFlush("⚠️ Error checking cancellation", Colors.orange);
//     }
//   }

//   void showReviewDialog(String bookingId) {
//     reviewControllers.putIfAbsent(bookingId, () => TextEditingController());
//     double currentRating = ratings[bookingId] ?? 0.0;

//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Write a Review'),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text("Booking ID: $bookingId"),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (i) {
//                       double starValue = i + 1.0;
//                       return IconButton(
//                         icon: Icon(
//                           currentRating >= starValue
//                               ? Icons.star
//                               : Icons.star_border,
//                           color: Colors.amber,
//                           size: 30,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             ratings[bookingId] = starValue;
//                           });
//                           Navigator.of(context).pop();
//                           showReviewDialog(bookingId);
//                         },
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: reviewControllers[bookingId],
//                     maxLines: 4,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'Write your experience booking service',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   submitReview(bookingId);
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//     );
//   }

//   Widget buildBookingCard(dynamic order, {bool isCustom = false}) {
//     final bookingId = order['bookingId'] ?? order['cdbookingId'] ?? 'N/A';
//     final bookingStatus = (order['status'] ?? '0').toString();
//     final isCanceledFinal =
//         bookingStatus == '1' ||
//         cancelledBookingIds.contains(bookingId.toString());

//     // Fix: Ensure "-" or empty handled correctly
//     String? endDate = (order['event_date_end'] ?? '').toString().trim();
//     if (endDate.isEmpty || endDate == "-") {
//       endDate =
//           (isCustom ? order['package_enddate'] : order['event_date_end'])
//               ?.toString()
//               .trim();
//     }

//     reviewControllers.putIfAbsent(
//       bookingId.toString(),
//       () => TextEditingController(),
//     );

//     return Card(
//       color: isCanceledFinal ? Colors.red[50] : Colors.white,
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.deepOrange.shade100),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Booking ID: $bookingId",
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Services: ${order['service_names']?.join(', ') ?? 'N/A'}",
//               style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Packages: ${order['package_names']?.join(', ') ?? 'N/A'}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),

//             // Regular Booking Dates
//             if (!isCustom) ...[
//               Text("Start Date: ${order['event_date_start'] ?? 'N/A'}"),
//               Text("End Date: ${order['event_date_end'] ?? 'N/A'}"),
//             ],

//             // Custom Booking Dates - old logic retained:
//             if (isCustom) ...[
//               if (order['package_startdate'] != null &&
//                   order['package_startdate'].toString().trim().isNotEmpty)
//                 Text("Package Start Date: ${order['package_startdate']}"),
//               if (order['package_enddate'] != null &&
//                   order['package_enddate'].toString().trim().isNotEmpty)
//                 Text("Package End Date: ${order['package_enddate']}"),
//               if (order['service_startdate'] != null &&
//                   order['service_startdate'].toString().trim().isNotEmpty)
//                 Text("Service Start Date: ${order['service_startdate']}"),
//               if (order['service_enddate'] != null &&
//                   order['service_enddate'].toString().trim().isNotEmpty)
//                 Text("Service End Date: ${order['service_enddate']}"),
//             ],

//             const SizedBox(height: 6),
//             Text(
//               "Business Name: ${order['business_name']?.join(', ') ?? 'N/A'}",
//               style: const TextStyle(color: Colors.black87),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Total Price: ₹${order['totalprice']?.toString() ?? '0'}",
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               "Booking Status: $bookingStatus",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             Center(
//               child:
//                   isCanceledFinal
//                       ? Column(
//                         children: const [
//                           Icon(Icons.cancel, color: Colors.red, size: 30),
//                           SizedBox(height: 6),
//                           Text(
//                             "Your booking is cancelled.",
//                             style: TextStyle(
//                               color: Colors.red,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       )
//                       : Column(
//                         children: [
//                           ElevatedButton.icon(
//                             onPressed: () => cancelBooking(order),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.deepOrange,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 12,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 4,
//                             ),
//                             icon: const Icon(Icons.cancel),
//                             label: const Text(
//                               "Cancel Booking",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           if (isPastBooking(endDate))
//                             ElevatedButton.icon(
//                               onPressed:
//                                   () => showReviewDialog(bookingId.toString()),
//                               icon: const Icon(Icons.rate_review),
//                               label: const Text("Write Review"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.green,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 elevation: 4,
//                               ),
//                             ),
//                         ],
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Bookings"),
//         backgroundColor: Colors.deepOrange,
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : ListView(
//                 padding: const EdgeInsets.all(12),
//                 children: [
//                   if (regularOrders.isNotEmpty) ...[
//                     const Text(
//                       "Regular Bookings:",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...regularOrders.map((order) => buildBookingCard(order)),
//                   ],
//                   if (customBookingOrders.isNotEmpty) ...[
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Custom Bookings:",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...customBookingOrders.map(
//                       (order) => buildBookingCard(order, isCustom: true),
//                     ),
//                   ],
//                   if (regularOrders.isEmpty && customBookingOrders.isEmpty)
//                     const Center(
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 50),
//                         child: Text("No bookings found."),
//                       ),
//                     ),
//                 ],
//               ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool isLoading = true;
  List<dynamic> regularOrders = [];
  List<dynamic> customBookingOrders = [];
  Set<String> cancelledBookingIds = {};

  int? userId;
  Map<String, double> ratings = {};
  Map<String, TextEditingController> reviewControllers = {};

  @override
  void initState() {
    super.initState();
    fetchUserIdAndData();
  }

  Future<void> fetchUserIdAndData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId == null || userId == 0) {
      setState(() => isLoading = false);
      showTopFlush("User not logged in", Colors.red);
      return;
    }

    final url = Uri.parse(
      'http://192.168.1.4:8000/api/Orderhistory?user_id=$userId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          setState(() {
            regularOrders = jsonData['regularorders'] ?? [];
            customBookingOrders = jsonData['custombookingorders'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
        showTopFlush("Server Error: ${response.statusCode}", Colors.red);
      }
    } catch (e) {
      setState(() => isLoading = false);
      showTopFlush("Error: $e", Colors.red);
    }
  }

  void showTopFlush(String message, Color color) {
    Flushbar(
      message: message,
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  /// Sirf past date ya invalid date par true return karega,
  /// future date (aaj ya aage) pe false karega
  bool isPastBooking(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty || dateStr.trim() == "-") {
      // Agar date null ya empty ya "-" ho toh consider karo past (allow review)
      return true;
    }
    try {
      DateTime bookingDate = DateFormat("yyyy-MM-dd").parse(dateStr);
      DateTime today = DateTime.now();
      // Aaj ya aage ki date ko future samjho, past nahi
      return bookingDate.isBefore(DateTime(today.year, today.month, today.day));
    } catch (e) {
      // Agar parsing fail ho toh review allow kar lo
      return true;
    }
  }

  Future<void> submitReview(String bookingId) async {
    double? rating = ratings[bookingId];
    String reviewText = reviewControllers[bookingId]?.text ?? "";

    if (rating == null || reviewText.isEmpty) {
      showTopFlush("Please give rating & write review", Colors.red);
      return;
    }

    final url = Uri.parse("http://192.168.1.4:8000/api/BookingReview");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_id": userId,
          "booking_id": bookingId,
          "rating": rating,
          "review_text": reviewText,
        }),
      );

      if (response.statusCode == 200) {
        showTopFlush("Review submitted successfully", Colors.green);
        setState(() {
          ratings.remove(bookingId);
          reviewControllers[bookingId]?.clear();
        });
      } else {
        showTopFlush("Failed to submit review", Colors.red);
      }
    } catch (e) {
      showTopFlush("Error submitting review", Colors.red);
    }
  }

  void cancelBooking(dynamic booking) async {
    final bookingId = booking['bookingId'] ?? booking['cdbookingId'];
    final isCustom = booking['cdbookingId'] != null;
    final endpoint =
        isCustom
            ? "check-customcancel-eligibility"
            : "check-regularcancel-eligibility";

    final url = Uri.parse("http://192.168.1.4:8000/api/$endpoint/$bookingId");

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['can_cancel'] == true) {
        setState(() {
          cancelledBookingIds.add(bookingId.toString());

          if (isCustom) {
            int index = customBookingOrders.indexWhere(
              (b) => b['cdbookingId'].toString() == bookingId.toString(),
            );
            if (index != -1) {
              customBookingOrders[index] = {
                ...customBookingOrders[index],
                'status': '1',
              };
              customBookingOrders = List.from(customBookingOrders);
            }
          } else {
            int index = regularOrders.indexWhere(
              (b) => b['bookingId'].toString() == bookingId.toString(),
            );
            if (index != -1) {
              regularOrders[index] = {...regularOrders[index], 'status': '1'};
              regularOrders = List.from(regularOrders);
            }
          }
        });

        showTopFlush("Your booking is cancelled.", Colors.green);
      } else {
        showTopFlush(
          data['message'] ??
              "Booking not eligible to cancel. Less than 7 days remaining.",
          Colors.red,
        );
      }
    } catch (e) {
      showTopFlush("⚠️ Error checking cancellation", Colors.orange);
    }
  }

  void showReviewDialog(String bookingId) {
    reviewControllers.putIfAbsent(bookingId, () => TextEditingController());
    double currentRating = ratings[bookingId] ?? 0.0;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Write a Review'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Booking ID: $bookingId"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      double starValue = i + 1.0;
                      return IconButton(
                        icon: Icon(
                          currentRating >= starValue
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            ratings[bookingId] = starValue;
                          });
                          Navigator.of(context).pop();
                          showReviewDialog(bookingId);
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: reviewControllers[bookingId],
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write your experience booking service',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  submitReview(bookingId);
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }

  Widget buildBookingCard(dynamic order, {bool isCustom = false}) {
    final bookingId = order['bookingId'] ?? order['cdbookingId'] ?? 'N/A';
    final bookingStatus = (order['status'] ?? '0').toString();
    final isCanceledFinal =
        bookingStatus == '1' ||
        cancelledBookingIds.contains(bookingId.toString());

    String? endDate = (order['event_date_end'] ?? '').toString().trim();
    if (endDate.isEmpty || endDate == "-") {
      endDate =
          (isCustom ? order['package_enddate'] : order['event_date_end'])
              ?.toString()
              .trim();
    }

    reviewControllers.putIfAbsent(
      bookingId.toString(),
      () => TextEditingController(),
    );

    return Card(
      color: isCanceledFinal ? Colors.red[50] : Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.deepOrange.shade100),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking ID: $bookingId",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "Services: ${order['service_names']?.join(', ') ?? 'N/A'}",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Packages: ${order['package_names']?.join(', ') ?? 'N/A'}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            if (!isCustom) ...[
              Text("Start Date: ${order['event_date_start'] ?? 'N/A'}"),
              Text("End Date: ${order['event_date_end'] ?? 'N/A'}"),
            ],

            if (isCustom) ...[
              if (order['package_startdate'] != null &&
                  order['package_startdate'].toString().trim().isNotEmpty)
                Text("Package Start Date: ${order['package_startdate']}"),
              if (order['package_enddate'] != null &&
                  order['package_enddate'].toString().trim().isNotEmpty)
                Text("Package End Date: ${order['package_enddate']}"),
              if (order['service_startdate'] != null &&
                  order['service_startdate'].toString().trim().isNotEmpty)
                Text("Service Start Date: ${order['service_startdate']}"),
              if (order['service_enddate'] != null &&
                  order['service_enddate'].toString().trim().isNotEmpty)
                Text("Service End Date: ${order['service_enddate']}"),
            ],

            const SizedBox(height: 6),
            Text(
              "Business Name: ${order['business_name']?.join(', ') ?? 'N/A'}",
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(
              "Total Price: ₹${order['totalprice']?.toString() ?? '0'}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Text(
              "Booking Status: $bookingStatus",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Center(
              child:
                  isCanceledFinal
                      ? Column(
                        children: const [
                          Icon(Icons.cancel, color: Colors.red, size: 30),
                          SizedBox(height: 6),
                          Text(
                            "Your booking is cancelled.",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => cancelBooking(order),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            icon: const Icon(Icons.cancel),
                            label: const Text(
                              "Cancel Booking",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (isPastBooking(endDate))
                            ElevatedButton.icon(
                              onPressed:
                                  () => showReviewDialog(bookingId.toString()),
                              icon: const Icon(Icons.rate_review),
                              label: const Text("Write Review"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                            ),
                        ],
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
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: Colors.deepOrange,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  if (regularOrders.isNotEmpty) ...[
                    const Text(
                      "Regular Bookings:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...regularOrders.map((order) => buildBookingCard(order)),
                  ],
                  if (customBookingOrders.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      "Custom Bookings:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...customBookingOrders.map(
                      (order) => buildBookingCard(order, isCustom: true),
                    ),
                  ],
                  if (regularOrders.isEmpty && customBookingOrders.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text("No bookings found."),
                      ),
                    ),
                ],
              ),
    );
  }
}
