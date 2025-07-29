// import 'package:flutter/material.dart';

// class BookingPage extends StatelessWidget {
//   const BookingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Booking Page', style: TextStyle(fontSize: 24)),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
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

//   @override
//   void initState() {
//     super.initState();
//     fetchUserIdAndData();
//   }

//   Future<void> fetchUserIdAndData() async {
//     final prefs = await SharedPreferences.getInstance();
//     int? userId = prefs.getInt('user_id');

//     if (userId == null || userId == 0) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('User not logged in')));
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
//           setState(() {
//             isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         print('Error: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error fetching data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('My Bookings')),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : ListView(
//                 padding: const EdgeInsets.all(12),
//                 children: [
//                   if (regularOrders.isNotEmpty) ...[
//                     const Text(
//                       'Regular Orders:',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     ...regularOrders.map(
//                       (order) => Card(
//                         child: ListTile(
//                           title: Text(
//                             "Services: ${order['service_names']?.join(', ') ?? 'N/A'}",
//                           ),
//                           subtitle: Text(
//                             "Packages: ${order['package_names']?.join(', ') ?? 'N/A'}\n"
//                             "Vendors: ${order['vendor_names']?.join(', ') ?? 'N/A'}",
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                   if (customBookingOrders.isNotEmpty) ...[
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Custom Bookings:',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     ...customBookingOrders.map(
//                       (cb) => Card(
//                         child: ListTile(
//                           title: Text(
//                             "Services: ${cb['service_names']?.join(', ') ?? 'N/A'}",
//                           ),
//                           subtitle: Text(
//                             "Packages: ${cb['package_names']?.join(', ') ?? 'N/A'}\n"
//                             "Vendors: ${cb['vendor_names']?.join(', ') ?? 'N/A'}",
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                   if (regularOrders.isEmpty && customBookingOrders.isEmpty)
//                     const Center(child: Text("No bookings found.")),
//                 ],
//               ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
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

//   @override
//   void initState() {
//     super.initState();
//     fetchUserIdAndData();
//   }

//   Future<void> fetchUserIdAndData() async {
//     final prefs = await SharedPreferences.getInstance();
//     int? userId = prefs.getInt('user_id');

//     if (userId == null || userId == 0) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('User not logged in')));
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
//         print('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       print('Fetch error: $e');
//     }
//   }

//   Widget buildBookingCard(dynamic order) {
//     return Card(
//       color: Colors.deepOrange.shade50,
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Services: ${order['service_names']?.join(', ') ?? 'N/A'}",
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepOrange,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text("Packages: ${order['package_names']?.join(', ') ?? 'N/A'}"),
//             const SizedBox(height: 5),
//             Text("Start Date: ${order['event_date_start'] ?? 'N/A'}"),
//             Text("End Date: ${order['event_date_end'] ?? 'N/A'}"),
//             const SizedBox(height: 5),
//             Text("Vendors: ${order['vendor_names']?.join(', ') ?? 'N/A'}"),
//             const SizedBox(height: 5),
//             Text(
//               "Total Price: ₹${order['totalprice']?.toString() ?? '0'}",
//               style: const TextStyle(fontWeight: FontWeight.bold),
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
//         title: const Text('My Bookings'),
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
//                       'Regular Bookings:',
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
//                       'Custom Bookings:',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...customBookingOrders.map(
//                       (order) => buildBookingCard(order),
//                     ),
//                   ],
//                   if (regularOrders.isEmpty && customBookingOrders.isEmpty)
//                     const Center(child: Text("No bookings found.")),
//                 ],
//               ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    fetchUserIdAndData();
  }

  Future<void> fetchUserIdAndData() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null || userId == 0) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
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
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Fetch error: $e');
    }
  }

  void cancelBooking(dynamic booking) {
    // You can add actual API logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Booking cancelled for ${booking['service_names']?.join(', ') ?? 'Service'}",
        ),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  Widget buildBookingCard(dynamic order) {
    return Card(
      color: Colors.deepOrange.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Services: ${order['service_names']?.join(', ') ?? 'N/A'}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 5),
            Text("Packages: ${order['package_names']?.join(', ') ?? 'N/A'}"),
            const SizedBox(height: 5),
            Text("Start Date: ${order['event_date_start'] ?? 'N/A'}"),
            Text("End Date: ${order['event_date_end'] ?? 'N/A'}"),
            const SizedBox(height: 5),
            Text(
              "Business Name: ${order['business_name']?.join(', ') ?? 'N/A'}",
            ),
            const SizedBox(height: 5),
            Text(
              "Total Price: ₹${order['totalprice']?.toString() ?? '0'}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => cancelBooking(order),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.cancel),
                label: const Text("Cancel Booking"),
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
        title: const Text('My Bookings'),
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
                      'Regular Bookings:',
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
                      'Custom Bookings:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...customBookingOrders.map(
                      (order) => buildBookingCard(order),
                    ),
                  ],
                  if (regularOrders.isEmpty && customBookingOrders.isEmpty)
                    const Center(child: Text("No bookings found.")),
                ],
              ),
    );
  }
}
