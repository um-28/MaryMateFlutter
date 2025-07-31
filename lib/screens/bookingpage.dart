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
//             final index = customBookingOrders.indexWhere(
//               (b) => b['cdbookingId'] == bookingId,
//             );
//             if (index != -1) {
//               customBookingOrders[index]['status'] = "1";
//             }
//           } else {
//             final index = regularOrders.indexWhere(
//               (b) => b['bookingId'] == bookingId,
//             );
//             if (index != -1) {
//               regularOrders[index]['status'] = "1";
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
//       showTopFlush("\u26a0\ufe0f Error checking cancellation", Colors.orange);
//     }
//   }

//   Widget buildBookingCard(dynamic order, {bool isCustom = false}) {
//     final bookingId = order['bookingId'] ?? order['cdbookingId'] ?? 'N/A';
//     final isCancelled = cancelledBookingIds.contains(bookingId.toString());
//     final bookingStatus = order['status'].toString();

//     return Card(
//       color:
//           bookingStatus == '1' || isCancelled ? Colors.red[50] : Colors.white,
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
//                   (bookingStatus == '1' || isCancelled)
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    fetchUserIdAndData();
  }

  Future<void> fetchUserIdAndData() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

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

  Widget buildBookingCard(dynamic order, {bool isCustom = false}) {
    final bookingId = order['bookingId'] ?? order['cdbookingId'] ?? 'N/A';
    final bookingStatus = (order['status'] ?? '0').toString();
    final isCanceledFinal =
        bookingStatus == '1' ||
        cancelledBookingIds.contains(bookingId.toString());

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
            if (isCustom &&
                (order['event_date_start']?.toString().trim().isNotEmpty ??
                    false))
              Text("Start Date: ${order['event_date_start']}"),
            if (isCustom &&
                (order['event_date_end']?.toString().trim().isNotEmpty ??
                    false))
              Text("End Date: ${order['event_date_end']}"),

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

            if (isCustom) ...[
              if ((order['service_startdate'] ?? '')
                  .toString()
                  .trim()
                  .isNotEmpty)
                Text("Service Start Date: ${order['service_startdate']}"),
              if ((order['service_enddate'] ?? '').toString().trim().isNotEmpty)
                Text("Service End Date: ${order['service_enddate']}"),
              if ((order['package_startdate'] ?? '')
                  .toString()
                  .trim()
                  .isNotEmpty)
                Text("Package Start Date: ${order['package_startdate']}"),
              if ((order['package_enddate'] ?? '').toString().trim().isNotEmpty)
                Text("Package End Date: ${order['package_enddate']}"),
            ],

            const SizedBox(height: 12),
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
                      : ElevatedButton.icon(
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
