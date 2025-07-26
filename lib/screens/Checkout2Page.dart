// import 'package:flutter/material.dart';

// class Checkout2Page extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final double totalPrice;

//   const Checkout2Page({
//     super.key,
//     required this.cartItems,
//     required this.totalPrice,
//     required int userId,
//   });

//   @override
//   State<Checkout2Page> createState() => _Checkout2PageState();
// }

// class _Checkout2PageState extends State<Checkout2Page> {
//   final _formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Checkout Details"),
//         backgroundColor: Colors.deepOrangeAccent,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const Text(
//                 "Enter your details",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: "Full Name"),
//                 validator:
//                     (value) => value!.isEmpty ? "Please enter your name" : null,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: "Email"),
//                 validator:
//                     (value) =>
//                         value!.isEmpty ? "Please enter your email" : null,
//               ),
//               TextFormField(
//                 controller: phoneController,
//                 decoration: const InputDecoration(labelText: "Phone Number"),
//                 validator:
//                     (value) =>
//                         value!.isEmpty ? "Please enter phone number" : null,
//               ),
//               TextFormField(
//                 controller: addressController,
//                 decoration: const InputDecoration(labelText: "Address"),
//                 validator:
//                     (value) => value!.isEmpty ? "Please enter address" : null,
//               ),
//               const SizedBox(height: 30),

//               const Divider(),
//               const Text(
//                 "Cart Summary",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               ...widget.cartItems.map((item) {
//                 return
//                 // ListTile(
//                 //   title: Text("Service ID: ${item['service_id']}"),
//                 //   subtitle: Text(
//                 //     "Vendor ID: ${item['vendor_id']}\nPackage ID: ${item['package_id']}\nStart: ${item['start_date']}\nEnd: ${item['end_date']}",
//                 //   ),
//                 //   trailing: Text("₹${item['price']}"),
//                 // );
//                 ListTile(
//                   title: Text("Service ID: ${item['service_id']}"),
//                   subtitle: Text(
//                     "Vendor ID: ${item['vendor_id']}\n"
//                     "Package ID: ${item['package_id']}\n"
//                     "Start: ${item['start_date']}\n"
//                     "End: ${item['end_date']}",
//                   ),
//                   trailing: Text("₹${item['price']}"),
//                 );
//               }),
//               const Divider(),

//               const SizedBox(height: 20),
//               Text(
//                 "Total: ₹${widget.totalPrice.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.green,
//                 ),
//               ),

//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     final fullData = {
//                       "name": nameController.text,
//                       "email": emailController.text,
//                       "phone": phoneController.text,
//                       "address": addressController.text,
//                       "total": widget.totalPrice,
//                       "items": widget.cartItems,
//                     };

//                     print("Final Checkout Payload:");
//                     print(fullData); // 🔥 This is where you send to API

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("✅ Data ready to send to backend"),
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrangeAccent,
//                   minimumSize: const Size.fromHeight(50),
//                 ),
//                 child: const Text(
//                   "Submit Booking",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class Checkout2Page extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final double totalPrice;
//   final int userId;

//   const Checkout2Page({
//     super.key,
//     required this.cartItems,
//     required this.totalPrice,
//     required this.userId,
//   });

//   @override
//   State<Checkout2Page> createState() => _Checkout2PageState();
// }

// class _Checkout2PageState extends State<Checkout2Page> {
//   final _formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     for (var item in widget.cartItems) {
//       print("🛒 Cart Item:");
//       print("Service ID: ${item['service_id']}");
//       print("Vendor ID: ${item['vendor_id']}");
//       print("Package ID: ${item['package_id']}");
//     }
//     print("User ID: ${widget.userId}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Checkout Details"),
//         backgroundColor: Colors.deepOrangeAccent,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const Text(
//                 "Enter your details",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: "Full Name"),
//                 validator:
//                     (value) => value!.isEmpty ? "Please enter your name" : null,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: "Email"),
//                 validator:
//                     (value) =>
//                         value!.isEmpty ? "Please enter your email" : null,
//               ),
//               TextFormField(
//                 controller: phoneController,
//                 decoration: const InputDecoration(labelText: "Phone Number"),
//                 validator:
//                     (value) =>
//                         value!.isEmpty ? "Please enter phone number" : null,
//               ),
//               TextFormField(
//                 controller: addressController,
//                 decoration: const InputDecoration(labelText: "Address"),
//                 validator:
//                     (value) => value!.isEmpty ? "Please enter address" : null,
//               ),
//               const SizedBox(height: 30),
//               const Divider(),
//               const Text(
//                 "Cart Summary",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               ...widget.cartItems.map((item) {
//                 return ListTile(
//                   title: Text("Service ID: ${item['service_id']}"),
//                   subtitle: Text(
//                     "Vendor ID: ${item['vendor_id']}\n"
//                     "Package ID: ${item['package_id']}\n"
//                     "Start: ${item['start_date']}\n"
//                     "End: ${item['end_date']}",
//                   ),
//                   trailing: Text("₹${item['price']}"),
//                 );
//               }),
//               const Divider(),
//               const SizedBox(height: 20),
//               Text(
//                 "Total: ₹${widget.totalPrice.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     final fullData = {
//                       "user_id": widget.userId,
//                       "name": nameController.text,
//                       "email": emailController.text,
//                       "phone": phoneController.text,
//                       "address": addressController.text,
//                       "total": widget.totalPrice,
//                       "items": widget.cartItems,
//                     };

//                     print("✅ Final Checkout Payload:");
//                     print(fullData);

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("✅ Data ready to send to backend"),
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrangeAccent,
//                   minimumSize: const Size.fromHeight(50),
//                 ),
//                 child: const Text(
//                   "Submit Booking",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class Checkout2Page extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final double totalPrice;
//   final int userId;

//   const Checkout2Page({
//     super.key,
//     required this.cartItems,
//     required this.totalPrice,
//     required this.userId,
//   });

//   @override
//   State<Checkout2Page> createState() => _Checkout2PageState();
// }

// class _Checkout2PageState extends State<Checkout2Page> {
//   final _formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     for (var item in widget.cartItems) {
//       print("🛒 Cart Item:");
//       print("Service ID: ${item['service_id']}");
//       print("Vendor ID: ${item['vendor_id']}");
//       print("Package ID: ${item['package_id']}");
//       print("Start: ${item['start_date']}");
//       print("End: ${item['end_date']}");
//     }
//     print("User ID: ${widget.userId}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Checkout Details"),
//         backgroundColor: Colors.deepOrangeAccent,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const Text(
//                 "Enter your details",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: "Full Name"),
//                 validator:
//                     (value) => value!.isEmpty ? "Please enter your name" : null,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: "Email"),
//                 validator:
//                     (value) =>
//                         value!.isEmpty ? "Please enter your email" : null,
//               ),
//               TextFormField(
//                 controller: phoneController,
//                 decoration: const InputDecoration(labelText: "Phone Number"),
//                 validator:
//                     (value) =>
//                         value!.isEmpty ? "Please enter phone number" : null,
//               ),
//               TextFormField(
//                 controller: addressController,
//                 decoration: const InputDecoration(labelText: "Address"),
//                 validator:
//                     (value) => value!.isEmpty ? "Please enter address" : null,
//               ),
//               const SizedBox(height: 30),
//               const Divider(),
//               const Text(
//                 "Cart Summary",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               ...widget.cartItems.map((item) {
//                 final startRaw = item['start_date'];
//                 final endRaw = item['end_date'];
//                 final DateTime start = DateTime.parse(startRaw);
//                 final DateTime end = DateTime.parse(endRaw);
//                 final bool isSame =
//                     start.year == end.year &&
//                     start.month == end.month &&
//                     start.day == end.day;
//                 final String endDisplay = isSame ? "-" : endRaw;

//                 return ListTile(
//                   title: Text("Service ID: ${item['service_id']}"),
//                   subtitle: Text(
//                     "Vendor ID: ${item['vendor_id']}\n"
//                     "Package ID: ${item['package_id']}\n"
//                     "Start: $startRaw\n"
//                     "End: $endDisplay",
//                   ),
//                   trailing: Text("₹${item['price']}"),
//                 );
//               }),
//               const Divider(),
//               const SizedBox(height: 20),
//               Text(
//                 "Total: ₹${widget.totalPrice.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     final processedItems =
//                         widget.cartItems.map((item) {
//                           final String startRaw = item['start_date'];
//                           final String endRaw = item['end_date'];

//                           final DateTime start = DateTime.parse(startRaw);
//                           final DateTime end = DateTime.parse(endRaw);
//                           final bool isSameDate =
//                               start.year == end.year &&
//                               start.month == end.month &&
//                               start.day == end.day;

//                           final String finalStart = start.toIso8601String();
//                           final String finalEnd =
//                               isSameDate ? "-" : end.toIso8601String();

//                           return {
//                             "service_id": item['service_id'],
//                             "vendor_id": item['vendor_id'],
//                             "package_id": item['package_id'],
//                             "price": item['price'],
//                             "start_date": finalStart,
//                             "end_date": finalEnd,
//                           };
//                         }).toList();

//                     final fullData = {
//                       "user_id": widget.userId,
//                       "name": nameController.text,
//                       "email": emailController.text,
//                       "phone": phoneController.text,
//                       "address": addressController.text,
//                       "total": widget.totalPrice,
//                       "items": processedItems,
//                     };

//                     print("✅ Final Checkout Payload:");
//                     print(fullData);

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text("✅ Data ready to send to backend"),
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrangeAccent,
//                   minimumSize: const Size.fromHeight(50),
//                 ),
//                 child: const Text(
//                   "Submit Booking",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Checkout2Page extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final double totalPrice;
//   final int userId;

//   const Checkout2Page({
//     super.key,
//     required this.cartItems,
//     required this.totalPrice,
//     required this.userId,
//   });

//   @override
//   State<Checkout2Page> createState() => _Checkout2PageState();
// }

// class _Checkout2PageState extends State<Checkout2Page> {
//   final _formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();

//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     for (var item in widget.cartItems) {
//       print("🛒 Cart Item:");
//       print("Service ID: ${item['service_id']}");
//       print("Vendor ID: ${item['vendor_id']}");
//       print("Package ID: ${item['package_id']}");
//       print("Start: ${item['start_date']}");
//       print("End: ${item['end_date']}");
//     }
//     print("User ID: ${widget.userId}");
//   }

//   Future<void> submitBooking() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       isLoading = true;
//     });

//     // 🔁 Convert all cart items to comma-separated strings
//     List<String> serviceIds = [];
//     List<String> packageIds = [];
//     List<String> vendorIds = [];
//     List<String> startDates = [];
//     List<String> endDates = [];

//     for (var item in widget.cartItems) {
//       serviceIds.add(item['service_id'].toString());
//       vendorIds.add(item['vendor_id'].toString());

//       // If package_id is null or 0, replace with "-"
//       final pkg = item['package_id'];
//       packageIds.add((pkg == null || pkg == 0) ? "-" : pkg.toString());

//       startDates.add(item['start_date']);
//       endDates.add(item['end_date']);
//     }

//     final fullData = {
//       "user_id": widget.userId,
//       "name": nameController.text,
//       "email": emailController.text,
//       "contact": phoneController.text,
//       "address": addressController.text,
//       "totalprice": widget.totalPrice.toInt(),
//       "payment_id": "payment123",
//       "vendor_id": vendorIds.join(","),
//       "service_id": serviceIds.join(","),
//       "package_id": packageIds.join(","),
//       "event_date_start": startDates.join(","),
//       "event_date_end": endDates.join(","),
//     };

//     print("✅ Final Payload:");
//     print(jsonEncode(fullData));

//     try {
//       final url = Uri.parse("http://172.20.10.2:8000/api/regularbooking");

//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(fullData),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print("✅ Booking Success: $responseData");

//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("🎉 Booking successful")));

//         Navigator.pop(context); // Navigate back or to success screen
//       } else {
//         print("❌ Booking Failed: ${response.body}");
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("❌ Booking failed")));
//       }
//     } catch (e) {
//       print("❌ Error: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("❌ Something went wrong")));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Checkout Details"),
//         backgroundColor: Colors.deepOrangeAccent,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const Text(
//                 "Enter your details",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: "Full Name"),
//                 validator:
//                     (value) => value!.isEmpty ? "Please enter your name" : null,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: "Email"),
//                 validator:
//                     (value) =>
//                         value!.isEmpty ? "Please enter your email" : null,
//               ),
//               TextFormField(
//                 controller: phoneController,
//                 decoration: const InputDecoration(labelText: "Phone Number"),
//                 keyboardType: TextInputType.phone,
//                 validator:
//                     (value) =>
//                         value!.isEmpty ? "Please enter phone number" : null,
//               ),
//               TextFormField(
//                 controller: addressController,
//                 decoration: const InputDecoration(labelText: "Address"),
//                 validator:
//                     (value) => value!.isEmpty ? "Please enter address" : null,
//               ),
//               const SizedBox(height: 30),
//               const Divider(),
//               const Text(
//                 "Cart Summary",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               ...widget.cartItems.map((item) {
//                 final startRaw = item['start_date'];
//                 final endRaw = item['end_date'];
//                 final DateTime start = DateTime.parse(startRaw);
//                 final DateTime end = DateTime.parse(endRaw);
//                 final bool isSame =
//                     start.year == end.year &&
//                     start.month == end.month &&
//                     start.day == end.day;
//                 final String endDisplay = isSame ? "-" : endRaw;

//                 return ListTile(
//                   title: Text("Service ID: ${item['service_id']}"),
//                   subtitle: Text(
//                     "Vendor ID: ${item['vendor_id']}\n"
//                     "Package ID: ${item['package_id'] ?? "-"}\n"
//                     "Start: $startRaw\n"
//                     "End: $endDisplay",
//                   ),
//                   trailing: Text("₹${item['price']}"),
//                 );
//               }).toList(),
//               const Divider(),
//               const SizedBox(height: 20),
//               Text(
//                 "Total: ₹${widget.totalPrice.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: isLoading ? null : submitBooking,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrangeAccent,
//                   minimumSize: const Size.fromHeight(50),
//                 ),
//                 child:
//                     isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                           "Submit Booking",
//                           style: TextStyle(color: Colors.white),
//                         ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Checkout2Page extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;
//   final double totalPrice;
//   final int userId;

//   const Checkout2Page({
//     super.key,
//     required this.cartItems,
//     required this.totalPrice,
//     required this.userId,
//   });

//   @override
//   State<Checkout2Page> createState() => _Checkout2PageState();
// }

// class _Checkout2PageState extends State<Checkout2Page> {
//   final _formKey = GlobalKey<FormState>();
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();

//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     for (var item in widget.cartItems) {
//       print("🛒 Cart Item:");
//       print("Service ID: ${item['service_id']}");
//       print("Vendor ID: ${item['vendor_id']}");
//       print("Package ID: ${item['package_id']}");
//       print("Start: ${item['start_date']}");
//       print("End: ${item['end_date']}");
//     }
//     print("User ID: ${widget.userId}");
//   }

//   Future<void> submitBooking() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       isLoading = true;
//     });

//     // 🔁 Convert all cart items to comma-separated strings
//     List<String> serviceIds = [];
//     List<String> packageIds = [];
//     List<String> vendorIds = [];
//     List<String> startDates = [];
//     List<String> endDates = [];

//     for (var item in widget.cartItems) {
//       // Convert 0 service_id to '-' if needed (optional)
//       final sid = item['service_id'];
//       serviceIds.add((sid == null || sid == 0) ? "-" : sid.toString());

//       final pkg = item['package_id'];
//       packageIds.add((pkg == null || pkg == 0) ? "-" : pkg.toString());

//       final vid = item['vendor_id'];
//       vendorIds.add((vid == null || vid == 0) ? "-" : vid.toString());

//       startDates.add(item['start_date']);
//       endDates.add(item['end_date']);
//     }

//     final fullData = {
//       "user_id": widget.userId,
//       "name": nameController.text,
//       "email": emailController.text,
//       "contact": phoneController.text,
//       "address": addressController.text,
//       "totalprice": widget.totalPrice.toInt(),
//       "payment_id": "payment123",
//       "vendor_id": vendorIds.join(","),
//       "service_id": serviceIds.join(","),
//       "package_id": packageIds.join(","),
//       "event_date_start": startDates.join(","),
//       "event_date_end": endDates.join(","),
//     };

//     print("✅ Final Payload:");
//     print(jsonEncode(fullData));

//     try {
//       final url = Uri.parse("http://172.20.10.2:8000/api/regularbooking");

//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(fullData),
//       );

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print("✅ Booking Success: $responseData");

//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("🎉 Booking successful")));

//         Navigator.pop(context); // You can also navigate to success page
//       } else {
//         print("❌ Booking Failed: ${response.body}");
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("❌ Booking failed")));
//       }
//     } catch (e) {
//       print("❌ Error: $e");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("❌ Something went wrong")));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Checkout Details"),
//         backgroundColor: Colors.deepOrangeAccent,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const Text(
//                 "Enter your details",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: "Full Name"),
//                 validator:
//                     (value) => value!.isEmpty ? "Please enter your name" : null,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: "Email"),
//                 validator:
//                     (value) =>
//                         value!.isEmpty ? "Please enter your email" : null,
//               ),
//               TextFormField(
//                 controller: phoneController,
//                 decoration: const InputDecoration(labelText: "Phone Number"),
//                 keyboardType: TextInputType.phone,
//                 validator:
//                     (value) =>
//                         value!.isEmpty ? "Please enter phone number" : null,
//               ),
//               TextFormField(
//                 controller: addressController,
//                 decoration: const InputDecoration(labelText: "Address"),
//                 validator:
//                     (value) => value!.isEmpty ? "Please enter address" : null,
//               ),
//               const SizedBox(height: 30),
//               const Divider(),
//               const Text(
//                 "Cart Summary",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               ...widget.cartItems.map((item) {
//                 final startRaw = item['start_date'];
//                 final endRaw = item['end_date'];
//                 final DateTime start = DateTime.parse(startRaw);
//                 final DateTime end = DateTime.parse(endRaw);
//                 final bool isSame =
//                     start.year == end.year &&
//                     start.month == end.month &&
//                     start.day == end.day;
//                 final String endDisplay = isSame ? "-" : endRaw;

//                 return ListTile(
//                   title: Text("Service ID: ${item['service_id']}"),
//                   subtitle: Text(
//                     "Vendor ID: ${item['vendor_id']}\n"
//                     "Package ID: ${item['package_id'] ?? "-"}\n"
//                     "Start: $startRaw\n"
//                     "End: $endDisplay",
//                   ),
//                   trailing: Text("₹${item['price']}"),
//                 );
//               }).toList(),
//               const Divider(),
//               const SizedBox(height: 20),
//               Text(
//                 "Total: ₹${widget.totalPrice.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: isLoading ? null : submitBooking,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrangeAccent,
//                   minimumSize: const Size.fromHeight(50),
//                 ),
//                 child:
//                     isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                           "Submit Booking",
//                           style: TextStyle(color: Colors.white),
//                         ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var item in widget.cartItems) {
      print("🛒 Cart Item:");
      print("Service ID: ${item['service_id']}");
      print("Vendor ID: ${item['vendor_id']}");
      print("Package ID: ${item['package_id']}");
      print("Start: ${item['start_date']}");
      print("End: ${item['end_date']}");
    }
    print("User ID: ${widget.userId}");
  }

  Future<void> submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    List<String> serviceIds = [];
    List<String> packageIds = [];
    List<String> vendorIds = [];
    List<String> startDates = [];
    List<String> endDates = [];

    for (var item in widget.cartItems) {
      // Service ID & Vendor ID
      final sid = item['service_id'];
      final vid = item['vendor_id'];
      final pkg = item['package_id'];
      serviceIds.add((sid == null || sid == 0) ? "-" : sid.toString());
      vendorIds.add((vid == null || vid == 0) ? "-" : vid.toString());
      packageIds.add((pkg == null || pkg == 0) ? "-" : pkg.toString());

      // 🗓️ Start & End Date Formatting
      final rawStart = item['start_date'];
      final rawEnd = item['end_date'];

      DateTime start = DateTime.parse(rawStart);
      DateTime end = DateTime.parse(rawEnd);

      String formattedStart =
          "${start.year.toString().padLeft(4, '0')}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
      String formattedEnd =
          "${end.year.toString().padLeft(4, '0')}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";

      startDates.add(formattedStart);

      // ✅ Compare dates: if same → "-"
      if (formattedStart == formattedEnd) {
        endDates.add("-");
      } else {
        endDates.add(formattedEnd);
      }
    }

    final fullData = {
      "user_id": widget.userId,
      "name": nameController.text,
      "email": emailController.text,
      "contact": phoneController.text,
      "address": addressController.text,
      "totalprice": widget.totalPrice.toInt(),
      "payment_id": "payment123",
      "vendor_id": vendorIds.join(","),
      "service_id": serviceIds.join(","),
      "package_id": packageIds.join(","),
      "event_date_start": startDates.join(","),
      "event_date_end": endDates.join(","),
    };

    print("✅ Final Payload:");
    print(jsonEncode(fullData));

    try {
      final url = Uri.parse("http://172.20.10.2:8000/api/regularbooking");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(fullData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("✅ Booking Success: $responseData");

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("🎉 Booking successful")));

        Navigator.pop(context); // You can also navigate to success page
      } else {
        print("❌ Booking Failed: ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("❌ Booking failed")));
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Something went wrong")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout Details"),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Enter your details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator:
                    (value) => value!.isEmpty ? "Please enter your name" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator:
                    (value) =>
                        value!.isEmpty ? "Please enter your email" : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value!.isEmpty ? "Please enter phone number" : null,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator:
                    (value) => value!.isEmpty ? "Please enter address" : null,
              ),
              const SizedBox(height: 30),
              const Divider(),
              const Text(
                "Cart Summary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ...widget.cartItems.map((item) {
                final startRaw = item['start_date'];
                final endRaw = item['end_date'];
                final DateTime start = DateTime.parse(startRaw);
                final DateTime end = DateTime.parse(endRaw);
                final bool isSame =
                    start.year == end.year &&
                    start.month == end.month &&
                    start.day == end.day;

                final String startDisplay =
                    "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}";
                final String endDisplay =
                    isSame
                        ? "-"
                        : "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";

                return ListTile(
                  title: Text("Service ID: ${item['service_id']}"),
                  subtitle: Text(
                    "Vendor ID: ${item['vendor_id']}\n"
                    "Package ID: ${item['package_id'] ?? "-"}\n"
                    "Start: $startDisplay\n"
                    "End: $endDisplay",
                  ),
                  trailing: Text("₹${item['price']}"),
                );
              }).toList(),
              const Divider(),
              const SizedBox(height: 20),
              Text(
                "Total: ₹${widget.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  minimumSize: const Size.fromHeight(50),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Submit Booking",
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
