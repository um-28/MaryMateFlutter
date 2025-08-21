import 'package:flutter/material.dart';

import '../vendor/GenerateDataPage.dart'; // Import the new page

class ReportsDataPage extends StatelessWidget {
  final String userId;

  const ReportsDataPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reports = [
      {'title': 'Customer Booking Report'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Generate Reports',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowHeight: 70,
                  headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                    (states) => Colors.grey[200],
                  ),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  columns: const [
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows:
                      reports.map((report) {
                        return DataRow(
                          cells: [
                            DataCell(Text(report['title'])),
                            DataCell(
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              GenerateDataPage(userId: userId),
                                    ),
                                  );
                                },
                                child: const Text('View'),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
