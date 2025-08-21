import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../config/api_config.dart';

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

    final url =
    // Uri.parse('http://192.168.1.6:8000/api/Orderhistory?user_id=$userId',);
    Uri.parse("${ApiConfig.baseUrl}/api/Orderhistory?user_id=$userId");

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

  /// Returns true only if ALL dates in the comma-separated string
  /// are strictly before today.
  /// Treats empty or "-" as past (returns true).
  bool areAllDatesPast(String? datesStr) {
    if (datesStr == null || datesStr.trim().isEmpty || datesStr.trim() == "-") {
      return true;
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    List<String> dates = datesStr.split(',').map((e) => e.trim()).toList();

    for (var dateStr in dates) {
      if (dateStr.isEmpty) continue;
      try {
        DateTime bookingDate = DateFormat("yyyy-MM-dd").parse(dateStr);
        // If any date is today or future, return false immediately
        if (!bookingDate.isBefore(todayDate)) {
          return false;
        }
      } catch (e) {
        // Parsing failed — consider this date as past and continue checking others
        continue;
      }
    }

    // All dates are past
    return true;
  }

  Future<void> submitReview(String bookingId, {bool isCustom = false}) async {
    double? rating = ratings[bookingId];
    String reviewText = reviewControllers[bookingId]?.text ?? "";

    if (rating == null || reviewText.isEmpty) {
      showTopFlush("Please give rating & write review", Colors.red);
      return;
    }

    final url = Uri.parse(
      //   isCustom
      //       ? "http://192.168.1.6:8000/api/CustomBookingReview/$bookingId"
      //       : "http://192.168.1.6:8000/api/BookingReview/$bookingId",
      // );
      isCustom
          ? "${ApiConfig.baseUrl}/api/CustomBookingReview/$bookingId"
          : "${ApiConfig.baseUrl}/api/BookingReview/$bookingId",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "user_id": userId,
          "rating": rating,
          "feedback":
              reviewText, // Changed key here from review_text to feedback
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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

    final url = Uri.parse("${ApiConfig.baseUrl}/api/$endpoint/$bookingId");

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

  void showReviewDialog(String bookingId, {bool isCustom = false}) {
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
                          showReviewDialog(bookingId, isCustom: isCustom);
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
                  submitReview(bookingId, isCustom: isCustom);
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

    String? startDate;
    String? endDate;

    if (isCustom) {
      // Try package_startdate, fallback service_startdate
      startDate = order['package_startdate']?.toString().trim();
      if (startDate == null || startDate.isEmpty || startDate == '-') {
        startDate = order['service_startdate']?.toString().trim();
      }

      // Try package_enddate, fallback service_enddate
      endDate = order['package_enddate']?.toString().trim();
      if (endDate == null || endDate.isEmpty || endDate == '-') {
        endDate = order['service_enddate']?.toString().trim();
      }
    } else {
      // Regular bookings
      startDate = order['event_date_start']?.toString().trim();
      endDate = order['event_date_end']?.toString().trim();
    }

    // Check if review button should show by confirming both dates are all past
    bool canShowReviewButton =
        areAllDatesPast(startDate) && areAllDatesPast(endDate);

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
                            // icon: const Icon(Icons.cancel),
                            label: const Text(
                              "Cancel Booking",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (canShowReviewButton)
                            ElevatedButton.icon(
                              onPressed:
                                  () => showReviewDialog(
                                    bookingId.toString(),
                                    isCustom: isCustom,
                                  ),
                              // icon: const Icon(Icons.rate_review),
                              label: const Text(" Review"),
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
