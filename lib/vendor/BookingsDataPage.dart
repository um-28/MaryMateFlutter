import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class BookingsDataPage extends StatefulWidget {
  final int userId;

  const BookingsDataPage({super.key, required this.userId});

  @override
  State<BookingsDataPage> createState() => _BookingsDataPageState();
}

class _BookingsDataPageState extends State<BookingsDataPage> {
  List serviceBookings = [];
  List packageBookings = [];
  List customBookings = [];
  bool isLoading = true;

  // Pagination state
  int servicePage = 1;
  int packagePage = 1;
  int customPage = 1;
  final int rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/BookingDetails?user_id=${widget.userId}',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          setState(() {
            serviceBookings = sortByNearestDate(
              data['data']['service_bookings'] ?? [],
            );
            packageBookings = sortByNearestDate(
              data['data']['package_bookings'] ?? [],
            );
            customBookings = sortByNearestDate(
              data['data']['custom_package_bookings'] ?? [],
            );
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          print('Invalid data format: $data');
        }
      } else {
        setState(() => isLoading = false);
        print('Error response: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Fetch error: $e');
    }
  }

  /// Nearest upcoming date sort
  List sortByNearestDate(List bookings) {
    try {
      DateTime now = DateTime.now();
      bookings.sort((a, b) {
        DateTime? dateA = _parseDateFromBooking(a);
        DateTime? dateB = _parseDateFromBooking(b);

        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;

        // Past dates go last, upcoming sorted nearest first
        if (dateA.isBefore(now) && dateB.isBefore(now)) {
          return dateB.compareTo(dateA); // both past, latest first
        } else if (dateA.isBefore(now)) {
          return 1; // A is past, push down
        } else if (dateB.isBefore(now)) {
          return -1; // B is past, push down
        } else {
          return dateA.compareTo(dateB); // upcoming, nearest first
        }
      });
    } catch (e) {
      print("Sort error: $e");
    }
    return bookings;
  }

  DateTime? _parseDateFromBooking(dynamic booking) {
    try {
      if (booking['datestart'] != null) {
        return DateTime.tryParse(booking['datestart'].toString());
      }
      // If inside details
      if (booking['service_details'] != null &&
          booking['service_details'].isNotEmpty) {
        return DateTime.tryParse(
          booking['service_details'][0]['datestart'].toString(),
        );
      }
      if (booking['package_details'] != null &&
          booking['package_details'].isNotEmpty) {
        return DateTime.tryParse(
          booking['package_details'][0]['datestart'].toString(),
        );
      }
    } catch (_) {}
    return null;
  }

  // Status widget with colors
  Widget statusWidget(String status) {
    if (status == "1") {
      return const Text(
        "Cancelled",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    } else if (status == "0") {
      return const Text(
        "Confirmed",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      );
    }
    return Text(status);
  }

  // Build DataTable Rows
  List<DataRow> buildRows(List bookings, String type) {
    List<DataRow> rows = [];

    for (var booking in bookings) {
      final user = booking['user'] ?? {};
      final clientName =
          user['name']?.toString() ?? booking['name']?.toString() ?? '-';
      final clientAddress = booking['address']?.toString() ?? '-';
      final status = booking['status']?.toString() ?? '-';

      List details = [];
      if (type == "service") {
        details = booking['service_details'] ?? [];
      } else if (type == "package") {
        details = booking['package_details'] ?? [];
      } else {
        details = [
          ...(booking['service_details'] ?? []),
          ...(booking['package_details'] ?? []),
        ];
      }

      for (var detail in details) {
        rows.add(
          DataRow(
            cells: [
              DataCell(statusWidget(status)), // Status first
              DataCell(Text(clientName)),
              DataCell(Text(clientAddress)),
              DataCell(
                Text(
                  type == "package" || detail['name'] != null
                      ? detail['name'].toString()
                      : detail['type']?.toString() ?? '-',
                ),
              ),
              DataCell(Text(detail['price']?.toString() ?? '-')),
              DataCell(Text(detail['days']?.toString() ?? '-')),
              DataCell(Text(detail['newprice']?.toString() ?? '-')),
              DataCell(Text(detail['datestart']?.toString() ?? '-')),
              DataCell(Text(detail['dateend']?.toString() ?? '-')),
            ],
          ),
        );
      }
    }
    return rows;
  }

  Widget buildPagination(
    int currentPage,
    int totalItems,
    Function(int) onPageChange,
  ) {
    int totalPages = (totalItems / rowsPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              currentPage > 1 ? () => onPageChange(currentPage - 1) : null,
        ),
        Text("$currentPage / $totalPages"),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed:
              currentPage < totalPages
                  ? () => onPageChange(currentPage + 1)
                  : null,
        ),
      ],
    );
  }

  Widget buildTableSection(
    String title,
    List bookings,
    String type,
    int currentPage,
    Function(int) onPageChange,
  ) {
    if (bookings.isEmpty) return const SizedBox();

    final start = (currentPage - 1) * rowsPerPage;
    final end =
        (start + rowsPerPage) > bookings.length
            ? bookings.length
            : (start + rowsPerPage);
    final currentBookings = bookings.sublist(start, end);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1000),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                  headingRowHeight: 56,
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(label: Text("Status")), // Status first
                    DataColumn(label: Text("Client Name")),
                    DataColumn(label: Text("Client Address")),
                    DataColumn(label: Text("Service/Package Name")),
                    DataColumn(label: Text("Price")),
                    DataColumn(label: Text("Days")),
                    DataColumn(label: Text("Total Price")),
                    DataColumn(label: Text("Start Date")),
                    DataColumn(label: Text("End Date")),
                  ],
                  rows: buildRows(currentBookings, type),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          buildPagination(currentPage, bookings.length, onPageChange),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'All Bookings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    buildTableSection(
                      "Service Bookings",
                      serviceBookings,
                      "service",
                      servicePage,
                      (page) => setState(() => servicePage = page),
                    ),
                    buildTableSection(
                      "Package Bookings",
                      packageBookings,
                      "package",
                      packagePage,
                      (page) => setState(() => packagePage = page),
                    ),
                    buildTableSection(
                      "Custom Bookings",
                      customBookings,
                      "custom",
                      customPage,
                      (page) => setState(() => customPage = page),
                    ),
                  ],
                ),
              ),
    );
  }
}
