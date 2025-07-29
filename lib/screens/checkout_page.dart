import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
    ).showSnackBar(SnackBar(content: Text("Payment failed")));
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_test_gwALiTsenyZSKW', // Replace with your Razorpay key
      'amount': (widget.totalPrice * 100).toInt(),
      'name': 'CareMitra',
      'description': 'Custom Package Booking',
      'prefill': {'contact': contact, 'email': email},
      'currency': 'INR',
    };

    _razorpay.open(options);
  }

  void _submitBooking(String paymentId) async {
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
        Uri.parse("http://192.168.1.4:8000/api/custompackagebooking"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final res = jsonDecode(response.body);
      if (res['status'] == true) {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text("Booking Successful!")));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking failed: ${res['message']}")),
        );
      }
    } catch (e) {
      print("Submit error: $e");
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
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Name"),
                    onSaved: (val) => name = val!,
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    onSaved: (val) => email = val!,
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Contact"),
                    onSaved: (val) => contact = val!,
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Address"),
                    onSaved: (val) => address = val!,
                    validator: (val) => val!.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateAndPay,
              child: Text("Pay ₹${widget.totalPrice.toInt()} and Book"),
            ),
          ],
        ),
      ),
    );
  }
}
