import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import '../screens/bookingpage.dart';
import '../data/cart_data.dart';

class Checkout2Page extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final int userId;

  const Checkout2Page({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.userId,
  });

  @override
  State<Checkout2Page> createState() => _Checkout2PageState();
}

class _Checkout2PageState extends State<Checkout2Page> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  late Razorpay _razorpay;
  bool isLoading = false;
  bool showBookingSummary = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("✅ Razorpay Payment Success: ${response.paymentId}");
    submitBooking(response.paymentId ?? "");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("❌ Razorpay Payment Failed: ${response.message}");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("❌ Payment failed")));
  }

  void _startPayment() {
    if (!_formKey.currentState!.validate()) return;

    var options = {
      'key': 'rzp_test_gwALiTsenyZSKW',
      'amount': (widget.totalPrice * 100).toInt(),
      'name': 'CareMitra',
      'description': 'Service Booking',
      'prefill': {
        'contact': phoneController.text,
        'email': emailController.text,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("❌ Error opening Razorpay: $e");
    }
  }

  Future<void> submitBooking(String paymentId) async {
    setState(() => isLoading = true);

    List<String> serviceIds = [];
    List<String> packageIds = [];
    List<String> vendorIds = [];
    List<String> startDates = [];
    List<String> endDates = [];

    for (var item in widget.cartItems) {
      serviceIds.add((item['service_id'] ?? "-").toString());
      vendorIds.add((item['vendor_id'] ?? "-").toString());
      packageIds.add((item['package_id'] ?? "-").toString());

      DateTime start = DateTime.parse(item['start_date']);
      DateTime end = DateTime.parse(item['end_date']);

      String formattedStart =
          "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
      String formattedEnd =
          "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";

      startDates.add(formattedStart);
      endDates.add(formattedStart == formattedEnd ? "-" : formattedEnd);
    }

    final fullData = {
      "user_id": widget.userId,
      "name": nameController.text,
      "email": emailController.text,
      "contact": phoneController.text,
      "address": addressController.text,
      "totalprice": widget.totalPrice.toInt(),
      "payment_id": paymentId,
      "vendor_id": vendorIds.join(","),
      "service_id": serviceIds.join(","),
      "package_id": packageIds.join(","),
      "event_date_start": startDates.join(","),
      "event_date_end": endDates.join(","),
    };

    print("📦 Sending to backend: $fullData");

    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.4:8000/api/regularbooking"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(fullData),
      );

      if (response.statusCode == 200) {
        Flushbar(
          message: "🎉 Congratulations! Your booking is confirmed",
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(8),
          margin: const EdgeInsets.all(12),
          icon: const Icon(Icons.check_circle, color: Colors.white),
           // ignore: use_build_context_synchronously
        ).show(context);

        // Clear the cart from memory and SharedPreferences
        globalCartItems.clear();
        await saveCartToPrefs();


        await Future.delayed(const Duration(seconds: 2));

        Navigator.pushReplacement(
           // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (_) => const BookingPage()),
        );

        ///  RELOAD Checkout2Page after success
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder:
        //         (context) => Checkout2Page(
        //           cartItems: widget.cartItems,
        //           totalPrice: widget.totalPrice,
        //           userId: widget.userId,
        //         ),
        //   ),
        // );
      } else {
        print(" Booking failed: ${response.body}");
        ScaffoldMessenger.of(
           // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text(" Booking failed")));
      }
    } catch (e) {
      print(" Error submitting booking: $e");
      ScaffoldMessenger.of(
         // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text(" Something went wrong")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Text(
                  "Total Price: ₹${widget.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter your details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? "Please enter your name"
                                    : null,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? "Please enter your email"
                                    : null,
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                        ),
                        keyboardType: TextInputType.phone,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? "Please enter phone number"
                                    : null,
                      ),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: "Address"),
                        validator:
                            (value) =>
                                value!.isEmpty ? "Please enter address" : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isLoading ? null : _startPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Pay & Book",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
