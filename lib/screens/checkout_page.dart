// import 'package:flutter/material.dart';

// class CheckoutPage extends StatefulWidget {
//   final double totalPrice;
//   final int apId;
//   final List<Map<String, dynamic>> selectedServices;
//   final List<Map<String, dynamic>> selectedPackages;

//   const CheckoutPage({
//     super.key,
//     required this.totalPrice,
//     required this.apId,
//     required this.selectedServices,
//     required this.selectedPackages,
//   });

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   final _formKey = GlobalKey<FormState>();
//   String name = '', email = '', contact = '', address = '';

//   void submitBooking() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       final bookingData = {
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

//       // TODO: Send this bookingData to API
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Checkout")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
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

//             const SizedBox(height: 30),

//             Text(
//               "Total Price: ₹${widget.totalPrice.toStringAsFixed(2)}",
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
//   final List<Map<String, dynamic>> selectedServices;
//   final List<Map<String, dynamic>> selectedPackages;

//   const CheckoutPage({
//     super.key,
//     required this.totalPrice,
//     required this.apId,
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
//     print("AP ID: ${widget.apId}");
//     print("Selected Services: ${widget.selectedServices}");
//     print("Selected Packages: ${widget.selectedPackages}");
//   }

//   void submitBooking() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       final bookingData = {
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

//       // TODO: Send this bookingData to your API
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
//           return Card(
//             color: Colors.orange.shade50,
//             child: ListTile(
//               title: Text("ID: ${item['id']}"),
//               subtitle: Text(
//                 "From: ${item['start_date']}  →  To: ${item['end_date']}",
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
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final double totalPrice;
  final int apId;
  final List<Map<String, dynamic>> selectedServices;
  final List<Map<String, dynamic>> selectedPackages;

  const CheckoutPage({
    super.key,
    required this.totalPrice,
    required this.apId,
    required this.selectedServices,
    required this.selectedPackages,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', contact = '', address = '';

  @override
  void initState() {
    super.initState();
    print("Checkout Page Opened");
    print("AP ID: ${widget.apId}");
    print("Selected Services: ${widget.selectedServices}");
    print("Selected Packages: ${widget.selectedPackages}");
  }

  void submitBooking() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final bookingData = {
        'ap_id': widget.apId,
        'total_price': widget.totalPrice,
        'name': name,
        'email': email,
        'contact': contact,
        'address': address,
        'services': widget.selectedServices,
        'packages': widget.selectedPackages,
      };

      print('Booking Data: $bookingData');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking submitted successfully!")),
      );

      // TODO: Send bookingData to your API
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

          return Card(
            color: Colors.orange.shade50,
            child: ListTile(
              title: Text(idLabel),
              subtitle: Text(
                "From: ${item['start_date']}  →  To: ${item['end_date']}",
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
                      if (val == null || val.length < 10) {
                        return 'Enter valid number';
                      }
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

            // Show selected service/package list with IDs
            buildSelectedList("Selected Services", widget.selectedServices),
            buildSelectedList("Selected Packages", widget.selectedPackages),

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
