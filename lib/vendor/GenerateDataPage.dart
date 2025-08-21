import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'dart:ui' as ui;
import '../config/api_config.dart';

import 'dart:html' as html; // for web iframe

import 'package:path_provider/path_provider.dart';

class GenerateDataPage extends StatefulWidget {
  final String userId;

  const GenerateDataPage({Key? key, required this.userId}) : super(key: key);

  @override
  _GenerateDataPageState createState() => _GenerateDataPageState();
}

class _GenerateDataPageState extends State<GenerateDataPage> {
  DateTime? startDate;
  DateTime? endDate;
  bool loading = false;
  String? errorMessage;

  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

  // For web: track iframe visibility & url
  String? pdfUrl;

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = null;
        }
      });
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? (startDate ?? DateTime.now()),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future<void> generateReport() async {
    if (startDate == null || endDate == null) {
      setState(() {
        errorMessage = 'Please select both start and end dates.';
      });
      return;
    }

    if (startDate!.isAfter(endDate!)) {
      setState(() {
        errorMessage = 'Start date cannot be after end date.';
      });
      return;
    }

    setState(() {
      loading = true;
      errorMessage = null;
      pdfUrl = null; // reset pdf url for web
    });

    final queryParameters = {
      'user_id': widget.userId,
      'start_date': dateFormatter.format(startDate!),
      'end_date': dateFormatter.format(endDate!),
    };

    final uri = Uri.http(
      '${ApiConfig.baseUrl}/api',
      '/ClientsBookingReports',
      queryParameters,
    );

    try {
      if (kIsWeb) {
        // For web: embed PDF inside the page using iframe
        setState(() {
          pdfUrl = uri.toString();
        });
      } else {
        // For mobile: download file then open
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/clientsbooking_report.pdf');
          await file.writeAsBytes(bytes);

          final result = await OpenFile.open(file.path);
          if (result.type != ResultType.done) {
            setState(() {
              errorMessage = 'Could not open PDF file.';
            });
          }
        } else {
          setState(() {
            errorMessage = 'Server error: ${response.statusCode}';
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Widget buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            date != null ? dateFormatter.format(date) : 'Select $label',
            style: TextStyle(
              fontSize: 16,
              color: date != null ? Colors.black87 : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Report'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    buildDatePicker('Start Date', startDate, pickStartDate),
                    const SizedBox(width: 16),
                    buildDatePicker('End Date', endDate, pickEndDate),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: loading ? null : generateReport,
                  child:
                      loading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text('Generate'),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
          // Show PDF iframe on web if pdfUrl is set
          if (kIsWeb && pdfUrl != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: HtmlElementView(viewType: 'pdf-viewer'),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Register iframe factory only once
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory('pdf-viewer', (int viewId) {
        final iframe = html.IFrameElement();
        iframe.src = pdfUrl ?? '';
        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        return iframe;
      });
    }
  }
}
