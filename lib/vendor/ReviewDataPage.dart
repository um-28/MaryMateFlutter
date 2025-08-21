import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Reviews')),
        body: ReviewWrapper(userId: '1'), // pass your userId here
      ),
    );
  }
}

class ReviewWrapper extends StatelessWidget {
  final String? userId;
  final bool showReviews;

  const ReviewWrapper({super.key, this.userId, this.showReviews = true});

  @override
  Widget build(BuildContext context) {
    if (!showReviews || userId == null) {
      return const Center(child: Text('No reviews to show.'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [Expanded(child: ReviewDataPage(userId: userId!))],
      ),
    );
  }
}

class ReviewDataPage extends StatefulWidget {
  final String userId;

  const ReviewDataPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ReviewDataPageState createState() => _ReviewDataPageState();
}

class _ReviewDataPageState extends State<ReviewDataPage> {
  bool loading = true;
  List reviews = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/ClientReviews?user_id=${widget.userId}',
    );

    print('Fetching reviews from: $url');

    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == true) {
          setState(() {
            reviews = jsonData['data'] ?? [];
            loading = false;
          });
        } else {
          setState(() {
            errorMessage = jsonData['message'] ?? 'Failed to load reviews';
            loading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    if (reviews.isEmpty) {
      return const Center(child: Text('No reviews found.'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Review',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowHeight: 110, // Increased row height for vertical space
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (states) => Colors.grey[200],
              ),
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              columns: const [
                DataColumn(label: Text('Client Name')),
                DataColumn(label: Text('Rating')),
                DataColumn(label: Text('Review')),
              ],
              rows:
                  reviews.map<DataRow>((review) {
                    final user = review['user'];
                    final clientName =
                        user != null ? (user['name'] ?? 'Unknown') : 'Unknown';
                    final rating = review['rating']?.toString() ?? '-';
                    final fullDescription = review['review'] ?? '-';

                    return DataRow(
                      cells: [
                        DataCell(Text(clientName)),
                        DataCell(Text(rating)),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Text(
                              fullDescription,
                              style: const TextStyle(fontSize: 14),
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
