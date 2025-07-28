// import 'package:flutter/material.dart';

// class CheckoutPage extends StatefulWidget {
//   final double totalPrice;
//   final int apId;
//   final int userId;
//   final List<Map<String, dynamic>> selectedServices;
//   final List<Map<String, dynamic>> selectedPackages;

//   const CheckoutPage({
//     super.key,
//     required this.totalPrice,
//     required this.apId,
//     required this.userId,
//     required this.selectedServices,
//     required this.selectedPackages,
//   });

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   final _formKey = GlobalKey<FormState>();
//   String name = '', email = '', contact = '', address = '';

//   @override
//   void initState() {
//     super.initState();
//     print("Checkout Page Opened");
//     print("User ID: ${widget.userId}");
//     print("AP ID: ${widget.apId}");
//     print("Selected Services: ${widget.selectedServices}");
//     print("Selected Packages: ${widget.selectedPackages}");
//   }

//   void submitBooking() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       final bookingData = {
//         'user_id': widget.userId,
//         'ap_id': widget.apId,
//         'total_price': widget.totalPrice,
//         'name': name,
//         'email': email,
//         'contact': contact,
//         'address': address,
//         'services': widget.selectedServices,
//         'packages': widget.selectedPackages,
//       };

//       print('Booking Data: $bookingData');

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Booking submitted successfully!")),
//       );

//       // TODO: Send bookingData to your API
//     }
//   }

//   Widget buildSelectedList(String title, List<Map<String, dynamic>> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         ...items.map((item) {
//           final isService = title.contains('Service');
//           final idLabel =
//               isService
//                   ? 'Service ID: ${item['service_id'] ?? 'N/A'}'
//                   : 'Package ID: ${item['package_id'] ?? 'N/A'}';
//           final name = item['name'] ?? '';

//           return Card(
//             color: Colors.orange.shade50,
//             child: ListTile(
//               title: Text(name),
//               subtitle: Text(
//                 "$idLabel\nFrom: ${item['start_date']} → To: ${item['end_date']}",
//               ),
//               leading: const Icon(
//                 Icons.calendar_today,
//                 color: Colors.deepOrange,
//               ),
//             ),
//           );
//         }).toList(),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Checkout")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             Text(
//               "User ID: ${widget.userId}",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Your Information",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Full Name"),
//                     validator:
//                         (val) => val == null || val.isEmpty ? 'Required' : null,
//                     onSaved: (val) => name = val ?? '',
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Email"),
//                     validator: (val) {
//                       if (val == null || val.isEmpty) return 'Required';
//                       if (!val.contains('@')) return 'Enter valid email';
//                       return null;
//                     },
//                     onSaved: (val) => email = val ?? '',
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: "Contact Number",
//                     ),
//                     keyboardType: TextInputType.phone,
//                     validator: (val) {
//                       if (val == null || val.length < 10) {
//                         return 'Enter valid number';
//                       }
//                       return null;
//                     },
//                     onSaved: (val) => contact = val ?? '',
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Address"),
//                     maxLines: 2,
//                     validator:
//                         (val) => val == null || val.isEmpty ? 'Required' : null,
//                     onSaved: (val) => address = val ?? '',
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Show selected lists
//             buildSelectedList("Selected Services", widget.selectedServices),
//             buildSelectedList("Selected Packages", widget.selectedPackages),

//             Text(
//               "Total Price: ₹${widget.totalPrice.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepOrange,
//               ),
//             ),

//             const SizedBox(height: 20),

//             ElevatedButton.icon(
//               onPressed: submitBooking,
//               icon: const Icon(Icons.check),
//               label: const Text("Confirm Booking"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepOrange,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class CheckoutPage extends StatefulWidget {
//   final double totalPrice;
//   final int apId;
//   final int userId;
//   final List<Map<String, dynamic>> selectedServices;
//   final List<Map<String, dynamic>> selectedPackages;

//   const CheckoutPage({
//     super.key,
//     required this.totalPrice,
//     required this.apId,
//     required this.userId,
//     required this.selectedServices,
//     required this.selectedPackages,
//   });

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   final _formKey = GlobalKey<FormState>();
//   String name = '', email = '', contact = '', address = '';

//   late List<Map<String, dynamic>> updatedServices;
//   late List<Map<String, dynamic>> updatedPackages;

//   @override
//   void initState() {
//     super.initState();

//     // Process dates: if end_date is same as start_date or null, make it "-"
//     updatedServices =
//         widget.selectedServices.map((s) {
//           final start = s['start_date'];
//           final end = s['end_date'];
//           final processedEnd = (end == null || end == start) ? "-" : end;
//           return {...s, 'start_date': start, 'end_date': processedEnd};
//         }).toList();

//     updatedPackages =
//         widget.selectedPackages.map((p) {
//           final start = p['start_date'];
//           final end = p['end_date'];
//           final processedEnd = (end == null || end == start) ? "-" : end;
//           return {...p, 'start_date': start, 'end_date': processedEnd};
//         }).toList();

//     print("Checkout Page Opened");
//     print("User ID: ${widget.userId}");
//     print("AP ID: ${widget.apId}");
//     print("Updated Services: $updatedServices");
//     print("Updated Packages: $updatedPackages");
//   }

//   void submitBooking() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       final bookingData = {
//         'user_id': widget.userId,
//         'ap_id': widget.apId,
//         'total_price': widget.totalPrice,
//         'name': name,
//         'email': email,
//         'contact': contact,
//         'address': address,
//         'services': updatedServices,
//         'packages': updatedPackages,
//       };

//       print('Booking Data: $bookingData');

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Booking submitted successfully!")),
//       );

//       // TODO: Send bookingData to your API
//     }
//   }

//   Widget buildSelectedList(String title, List<Map<String, dynamic>> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         ...items.map((item) {
//           final isService = title.contains('Service');
//           final idLabel =
//               isService
//                   ? 'Service ID: ${item['service_id'] ?? 'N/A'}'
//                   : 'Package ID: ${item['package_id'] ?? 'N/A'}';
//           final name = item['name'] ?? '';

//           return Card(
//             color: Colors.orange.shade50,
//             child: ListTile(
//               title: Text(name),
//               subtitle: Text(
//                 "$idLabel\nFrom: ${item['start_date']} → To: ${item['end_date']}",
//               ),
//               leading: const Icon(
//                 Icons.calendar_today,
//                 color: Colors.deepOrange,
//               ),
//             ),
//           );
//         }).toList(),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Checkout")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             Text(
//               "User ID: ${widget.userId}",
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "Your Information",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),

//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Full Name"),
//                     validator:
//                         (val) => val == null || val.isEmpty ? 'Required' : null,
//                     onSaved: (val) => name = val ?? '',
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Email"),
//                     validator: (val) {
//                       if (val == null || val.isEmpty) return 'Required';
//                       if (!val.contains('@')) return 'Enter valid email';
//                       return null;
//                     },
//                     onSaved: (val) => email = val ?? '',
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       labelText: "Contact Number",
//                     ),
//                     keyboardType: TextInputType.phone,
//                     validator: (val) {
//                       if (val == null || val.length < 10) {
//                         return 'Enter valid number';
//                       }
//                       return null;
//                     },
//                     onSaved: (val) => contact = val ?? '',
//                   ),
//                   TextFormField(
//                     decoration: const InputDecoration(labelText: "Address"),
//                     maxLines: 2,
//                     validator:
//                         (val) => val == null || val.isEmpty ? 'Required' : null,
//                     onSaved: (val) => address = val ?? '',
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Show updated lists
//             buildSelectedList("Selected Services", updatedServices),
//             buildSelectedList("Selected Packages", updatedPackages),

//             Text(
//               "Total Price: ₹${widget.totalPrice.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepOrange,
//               ),
//             ),

//             const SizedBox(height: 20),

//             ElevatedButton.icon(
//               onPressed: submitBooking,
//               icon: const Icon(Icons.check),
//               label: const Text("Confirm Booking"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepOrange,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  final double totalPrice;
  final int apId;
  final int userId;
  final List<Map<String, dynamic>> selectedServices;
  final List<Map<String, dynamic>> selectedPackages;

  const CheckoutPage({
    super.key,
    required this.totalPrice,
    required this.apId,
    required this.userId,
    required this.selectedServices,
    required this.selectedPackages,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', contact = '', address = '';

  late List<Map<String, dynamic>> updatedServices;
  late List<Map<String, dynamic>> updatedPackages;

  @override
  void initState() {
    super.initState();

    updatedServices =
        widget.selectedServices.map((s) {
          final start = s['start_date'];
          final end = s['end_date'];
          final processedEnd = (end == null || end == start) ? "-" : end;
          return {...s, 'start_date': start, 'end_date': processedEnd};
        }).toList();

    updatedPackages =
        widget.selectedPackages.map((p) {
          final start = p['start_date'];
          final end = p['end_date'];
          final processedEnd = (end == null || end == start) ? "-" : end;
          return {...p, 'start_date': start, 'end_date': processedEnd};
        }).toList();
  }

  Future<void> submitBooking() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final serviceIds = updatedServices.map((e) => e['service_id']).join(',');
      final serviceStartDates = updatedServices
          .map((e) => e['start_date'])
          .join(',');
      final serviceEndDates = updatedServices
          .map((e) => e['end_date'])
          .join(',');

      final packageIds = updatedPackages.map((e) => e['package_id']).join(',');
      final packageStartDates = updatedPackages
          .map((e) => e['start_date'])
          .join(',');
      final packageEndDates = updatedPackages
          .map((e) => e['end_date'])
          .join(',');

      final bookingData = {
        'user_id': widget.userId.toString(),
        'ap_id': widget.apId.toString(),
        'service_ids': serviceIds,
        'service_startdate': serviceStartDates,
        'service_enddate': serviceEndDates,
        'package_ids': packageIds,
        'package_startdate': packageStartDates,
        'package_enddate': packageEndDates,
        'name': name,
        'email': email,
        'address': address,
        'contact': contact,
        'totalprice': widget.totalPrice.toInt().toString(),
        'payment_id': 'payment-123', // fixed for now
      };

      print("Sending Booking Data: $bookingData");

      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.4:8000/api/custompackagebooking'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(bookingData),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          print("Booking Successful: $responseData");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Booking submitted successfully!")),
          );
        } else {
          print("Booking Failed: ${response.body}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Booking failed. Please try again.")),
          );
        }
      } catch (e) {
        print("Error sending booking: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Something went wrong.")));
      }
    }
  }

  Widget buildSelectedList(String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          final isService = title.contains('Service');
          final idLabel =
              isService
                  ? 'Service ID: ${item['service_id']}'
                  : 'Package ID: ${item['package_id']}';
          final name = item['name'] ?? '';

          return Card(
            color: Colors.orange.shade50,
            child: ListTile(
              title: Text(name),
              subtitle: Text(
                "$idLabel\nFrom: ${item['start_date']} → To: ${item['end_date']}",
              ),
              leading: const Icon(
                Icons.calendar_today,
                color: Colors.deepOrange,
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "User ID: ${widget.userId}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Full Name"),
                    validator:
                        (val) => val == null || val.isEmpty ? 'Required' : null,
                    onSaved: (val) => name = val ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Required';
                      if (!val.contains('@')) return 'Enter valid email';
                      return null;
                    },
                    onSaved: (val) => email = val ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Contact Number",
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      if (val == null || val.length < 10)
                        return 'Enter valid number';
                      return null;
                    },
                    onSaved: (val) => contact = val ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Address"),
                    maxLines: 2,
                    validator:
                        (val) => val == null || val.isEmpty ? 'Required' : null,
                    onSaved: (val) => address = val ?? '',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildSelectedList("Selected Services", updatedServices),
            buildSelectedList("Selected Packages", updatedPackages),
            Text(
              "Total Price: ₹${widget.totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: submitBooking,
              icon: const Icon(Icons.check),
              label: const Text("Confirm Booking"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
