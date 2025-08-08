// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';

// class GenerateDataPage extends StatefulWidget {
//   final String userId;

//   const GenerateDataPage({Key? key, required this.userId}) : super(key: key);

//   @override
//   _GenerateDataPageState createState() => _GenerateDataPageState();
// }

// class _GenerateDataPageState extends State<GenerateDataPage> {
//   DateTime? startDate;
//   DateTime? endDate;
//   bool loading = false;
//   String? errorMessage;
//   String? pdfUrl; // URL or file path to the generated PDF

//   final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

//   Future<void> pickStartDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: startDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         startDate = picked;
//         if (endDate != null && endDate!.isBefore(startDate!)) {
//           endDate = null; // reset endDate if before startDate
//         }
//       });
//     }
//   }

//   Future<void> pickEndDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: endDate ?? (startDate ?? DateTime.now()),
//       firstDate: startDate ?? DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         endDate = picked;
//       });
//     }
//   }

//   Future<void> generateReport() async {
//     if (startDate == null || endDate == null) {
//       setState(() {
//         errorMessage = 'Please select both start and end dates.';
//       });
//       return;
//     }

//     if (startDate!.isAfter(endDate!)) {
//       setState(() {
//         errorMessage = 'Start date cannot be after end date.';
//       });
//       return;
//     }

//     setState(() {
//       loading = true;
//       errorMessage = null;
//       pdfUrl = null;
//     });

//     final url = Uri.parse('http://192.168.1.9:8000/api/ClientsBookingReports');

//     final body = {
//       'user_id': widget.userId,
//       'start_date': dateFormatter.format(startDate!),
//       'end_date': dateFormatter.format(endDate!),
//     };

//     try {
//       final response = await http.post(url, body: body);

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         // Assuming API returns URL or path to PDF in jsonResponse['pdf_url'] or similar
//         if (jsonResponse['status'] == true && jsonResponse['pdf_url'] != null) {
//           setState(() {
//             pdfUrl = jsonResponse['pdf_url'];
//           });
//           // Open PDF in browser or PDF viewer
//           if (await canLaunch(pdfUrl!)) {
//             await launch(pdfUrl!);
//           } else {
//             setState(() {
//               errorMessage = 'Could not open the PDF report.';
//             });
//           }
//         } else {
//           setState(() {
//             errorMessage =
//                 jsonResponse['message'] ?? 'Failed to generate report.';
//           });
//         }
//       } else {
//         setState(() {
//           errorMessage = 'Server error: ${response.statusCode}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: $e';
//       });
//     } finally {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   Widget buildDatePicker(String label, DateTime? date, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade400),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             date != null ? dateFormatter.format(date) : 'Select $label',
//             style: TextStyle(
//               fontSize: 16,
//               color: date != null ? Colors.black87 : Colors.grey.shade600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Generate Report'),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         foregroundColor: Colors.black87,
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 buildDatePicker('Start Date', startDate, pickStartDate),
//                 const SizedBox(width: 16),
//                 buildDatePicker('End Date', endDate, pickEndDate),
//               ],
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 14,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: loading ? null : generateReport,
//               child:
//                   loading
//                       ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                       : const Text('Generate'),
//             ),
//             if (errorMessage != null) ...[
//               const SizedBox(height: 20),
//               Text(errorMessage!, style: const TextStyle(color: Colors.red)),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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
    });

    final queryParameters = {
      'user_id': widget.userId,
      'start_date': dateFormatter.format(startDate!),
      'end_date': dateFormatter.format(endDate!),
    };

    final uri = Uri.http(
      '192.168.1.9:8000',
      '/api/ClientsBookingReports',
      queryParameters,
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Save PDF bytes to a file
        final bytes = response.bodyBytes;

        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/clientsbooking_report.pdf');
        await file.writeAsBytes(bytes);

        // Open PDF file with default PDF viewer app
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
      body: Padding(
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
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
