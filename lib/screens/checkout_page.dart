// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import '../config/api_config.dart';

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
//   late Razorpay _razorpay;

//   String name = '', email = '', contact = '', address = '';

//   late List<Map<String, dynamic>> updatedServices;
//   late List<Map<String, dynamic>> updatedPackages;

//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);

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
//   }

//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }

//   void _handleSuccess(PaymentSuccessResponse response) {
//     _submitBooking(response.paymentId!);
//   }

//   void _handleError(PaymentFailureResponse response) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text("Payment failed")));
//   }

//   void _startPayment() {
//     var options = {
//       'key': 'rzp_test_gwALiTsenyZSKW',
//       'amount': (widget.totalPrice * 100).toInt(),
//       'name': 'CareMitra',
//       'description': 'Custom Package Booking',
//       'prefill': {'contact': contact, 'email': email},
//       'currency': 'INR',
//     };

//     _razorpay.open(options);
//   }

//   void _submitBooking(String paymentId) async {
//     final serviceIds =
//         updatedServices.isNotEmpty
//             ? updatedServices.map((e) => e['service_id']).join(',')
//             : "0";
//     final serviceStartDates =
//         updatedServices.isNotEmpty
//             ? updatedServices.map((e) => e['start_date']).join(',')
//             : "-";
//     final serviceEndDates =
//         updatedServices.isNotEmpty
//             ? updatedServices.map((e) => e['end_date']).join(',')
//             : "-";

//     final packageIds =
//         updatedPackages.isNotEmpty
//             ? updatedPackages.map((e) => e['package_id']).join(',')
//             : "0";
//     final packageStartDates =
//         updatedPackages.isNotEmpty
//             ? updatedPackages.map((e) => e['start_date']).join(',')
//             : "-";
//     final packageEndDates =
//         updatedPackages.isNotEmpty
//             ? updatedPackages.map((e) => e['end_date']).join(',')
//             : "-";

//     final data = {
//       'user_id': widget.userId,
//       'ap_id': widget.apId,
//       'service_ids': serviceIds,
//       'service_startdate': serviceStartDates,
//       'service_enddate': serviceEndDates,
//       'package_ids': packageIds,
//       'package_startdate': packageStartDates,
//       'package_enddate': packageEndDates,
//       'name': name,
//       'email': email,
//       'address': address,
//       'contact': contact,
//       'totalprice': widget.totalPrice.toInt(),
//       'payment_id': paymentId,
//     };

//     try {
//       final response = await http.post(
//         Uri.parse("${ApiConfig.baseUrl}/api/custompackagebooking"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(data),
//       );

//       final res = jsonDecode(response.body);
//       if (res['status'] == true) {
//         ScaffoldMessenger.of(
//           // ignore: use_build_context_synchronously
//           context,
//         ).showSnackBar(const SnackBar(content: Text("Booking Successful!")));
//       } else {
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Booking failed: ${res['message']}")),
//         );
//       }
//     } catch (e) {
//       print("Submit error: $e");
//     }
//   }

//   void _validateAndPay() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       _startPayment();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text("Checkout"),
//         centerTitle: true,
//         backgroundColor: Colors.deepOrange,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Total Price Heading
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               alignment: Alignment.center,
//               child: Text(
//                 "Total Price: ₹${widget.totalPrice.toInt()}",
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.deepOrange,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),

//             // Form fields
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     buildTextField("Name", (val) => name = val!),
//                     buildTextField("Email", (val) => email = val!),
//                     buildTextField("Contact", (val) => contact = val!),
//                     buildTextField("Address", (val) => address = val!),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Pay Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _validateAndPay,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrange,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   "Pay ₹${widget.totalPrice.toInt()} and Book",
//                   style: const TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(String label, Function(String?) onSave) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextFormField(
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         onSaved: onSave,
//         validator: (val) => val!.isEmpty ? 'Required' : null,
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import '../config/api_config.dart';
import '../screens/bottomnavpage.dart';

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
  late Razorpay _razorpay;

  String name = '', email = '', contact = '', address = '';
  bool isLoading = false;

  late List<Map<String, dynamic>> updatedServices;
  late List<Map<String, dynamic>> updatedPackages;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);

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

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    _submitBooking(response.paymentId!);
  }

  void _handleError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Payment failed")));
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_test_gwALiTsenyZSKW',
      'amount': (widget.totalPrice * 100).toInt(),
      'name': 'CareMitra',
      'description': 'Custom Package Booking',
      'prefill': {'contact': contact, 'email': email},
      'currency': 'INR',
    };

    _razorpay.open(options);
  }

  Future<void> _submitBooking(String paymentId) async {
    setState(() => isLoading = true);

    final serviceIds =
        updatedServices.isNotEmpty
            ? updatedServices.map((e) => e['service_id']).join(',')
            : "0";
    final serviceStartDates =
        updatedServices.isNotEmpty
            ? updatedServices.map((e) => e['start_date']).join(',')
            : "-";
    final serviceEndDates =
        updatedServices.isNotEmpty
            ? updatedServices.map((e) => e['end_date']).join(',')
            : "-";

    final packageIds =
        updatedPackages.isNotEmpty
            ? updatedPackages.map((e) => e['package_id']).join(',')
            : "0";
    final packageStartDates =
        updatedPackages.isNotEmpty
            ? updatedPackages.map((e) => e['start_date']).join(',')
            : "-";
    final packageEndDates =
        updatedPackages.isNotEmpty
            ? updatedPackages.map((e) => e['end_date']).join(',')
            : "-";

    final data = {
      'user_id': widget.userId,
      'ap_id': widget.apId,
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
      'totalprice': widget.totalPrice.toInt(),
      'payment_id': paymentId,
    };

    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/api/custompackagebooking"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final res = jsonDecode(response.body);
      if (res['status'] == true) {
        // ✅ Show success Flushbar
        Flushbar(
          message: "🎉 Congratulations! Your booking is confirmed",
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(8),
          margin: const EdgeInsets.all(12),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        ).show(context);

        // Wait a moment to show Flushbar
        await Future.delayed(const Duration(seconds: 2));

        // Redirect to BottomNavPage Bookings tab
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => const BottomNavPage(initialIndex: 1), // 1 = Bookings tab
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking failed: ${res['message']}")),
        );
      }
    } catch (e) {
      print("Submit error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _validateAndPay() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _startPayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Total Price Heading
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Text(
                "Total Price: ₹${widget.totalPrice.toInt()}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Form fields
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField("Name", (val) => name = val!),
                    buildTextField("Email", (val) => email = val!),
                    buildTextField("Contact", (val) => contact = val!),
                    buildTextField("Address", (val) => address = val!),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _validateAndPay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "Pay ₹${widget.totalPrice.toInt()} and Book",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, Function(String?) onSave) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onSaved: onSave,
        validator: (val) => val!.isEmpty ? 'Required' : null,
      ),
    );
  }
}
