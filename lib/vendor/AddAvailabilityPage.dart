// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AddAvailabilityPage extends StatefulWidget {
//   const AddAvailabilityPage({super.key});

//   @override
//   State<AddAvailabilityPage> createState() => _AddAvailabilityPageState();
// }

// class _AddAvailabilityPageState extends State<AddAvailabilityPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();
//   final TextEditingController _placeController = TextEditingController();
//   bool isLoading = false;

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? userId = prefs.getInt('user_id');
//     if (userId == null) return;

//     setState(() => isLoading = true);

//     final url = Uri.parse("http://192.168.1.3:8000/api/VendorAvailability");

//     final response = await http.post(
//       url,
//       body: {
//         'user_id': userId.toString(),
//         'startdate': _startDateController.text,
//         'enddate': _endDateController.text,
//         'placetoservice': _placeController.text,
//       },
//     );

//     setState(() => isLoading = false);

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Navigator.pop(context, true);
//     } else {
//       final error = response.body;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Failed to add availability\n$error"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Availability")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _startDateController,
//                 decoration: const InputDecoration(
//                   labelText: 'Start Date (YYYY-MM-DD)',
//                 ),
//                 validator:
//                     (value) =>
//                         value == null || value.isEmpty
//                             ? 'Enter start date'
//                             : null,
//               ),
//               TextFormField(
//                 controller: _endDateController,
//                 decoration: const InputDecoration(
//                   labelText: 'End Date (YYYY-MM-DD)',
//                 ),
//                 validator:
//                     (value) =>
//                         value == null || value.isEmpty
//                             ? 'Enter end date'
//                             : null,
//               ),
//               TextFormField(
//                 controller: _placeController,
//                 decoration: const InputDecoration(
//                   labelText: 'Place to Service (as ID)',
//                 ),
//                 validator:
//                     (value) =>
//                         value == null || value.isEmpty
//                             ? 'Enter place to service'
//                             : null,
//               ),
//               const SizedBox(height: 20),
//               isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                     onPressed: _submitForm,
//                     child: const Text("Submit"),
//                   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddAvailabilityPage extends StatefulWidget {
  const AddAvailabilityPage({super.key});

  @override
  State<AddAvailabilityPage> createState() => _AddAvailabilityPageState();
}

class _AddAvailabilityPageState extends State<AddAvailabilityPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  bool isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return;

    setState(() => isLoading = true);

    final url = Uri.parse("http://192.168.1.3:8000/api/VendorAvailability");

    final response = await http.post(
      url,
      body: {
        'user_id': userId.toString(),
        'startdate': _startDateController.text,
        'enddate': _endDateController.text,
        'placetoservice': _placeController.text,
      },
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      final error = response.body;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add availability\n$error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("Add Availability"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Add Your Availability",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Start Date
                  TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      labelText: 'Start Date (YYYY-MM-DD)',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter start date'
                                : null,
                  ),
                  const SizedBox(height: 20),

                  // End Date
                  TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      labelText: 'End Date (YYYY-MM-DD)',
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter end date'
                                : null,
                  ),
                  const SizedBox(height: 20),

                  // Place to service
                  TextFormField(
                    controller: _placeController,
                    decoration: InputDecoration(
                      labelText: 'Place to Service (as ID)',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Enter place to service'
                                : null,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
