// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:convert';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import '../models/vendormodel.dart';
// import '../screens/VendorServicePage.dart';

// class ServiceVendorPage extends StatefulWidget {
//   final String serviceName;
//   final String headerImage;

//   const ServiceVendorPage({
//     super.key,
//     required this.serviceName,
//     required this.headerImage,
//   });

//   @override
//   State<ServiceVendorPage> createState() => _ServiceVendorPageState();
// }

// class _ServiceVendorPageState extends State<ServiceVendorPage> {
//   List<Vendor> vendors = [];
//   bool isLoading = true;
//   bool hasError = false;

//   Future<void> fetchVendors() async {
//     final businessType = widget.serviceName;

//     try {
//       final response = await http
//           .get(
//             Uri.parse('http://192.168.1.4:8000/api/vendors/type/$businessType'),
//             headers: {'Accept': 'application/json'},
//           )
//           .timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == true && data['data'] != null) {
//           final List<Vendor> allVendors =
//               (data['data'] as List).map((v) => Vendor.fromJson(v)).toList();

//           setState(() {
//             vendors =
//                 allVendors
//                     .where((v) => v.status == 0 || v.status == 1)
//                     .toList();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//             hasError = true;
//           });
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//           hasError = true;
//         });
//       }
//     } on TimeoutException {
//       setState(() {
//         isLoading = false;
//         hasError = true;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         hasError = true;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchVendors();
//   }

//   void navigateToVendorDetail(int vendorId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => VendorServicePage(vendorId: vendorId),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(children: [_buildHeader(), Expanded(child: _buildBody())]),
//     );
//   }

//   Widget _buildHeader() {
//     // String headerImageUrl = '';

//     // Use first vendor's category image if available
//     if (vendors.isNotEmpty &&
//         vendors.first.categoryImageUrl != null &&
//         vendors.first.categoryImageUrl!.isNotEmpty) {
//       // headerImageUrl = vendors.first.categoryImageUrl!;
//     }

//     return Stack(
//       children: [
//         ClipRRect(

//         ),
//         Container(
//           height: 100,

//         ),
//         Positioned(
//           top: 48,
//           left: 16,
//           child: CircleAvatar(
//             backgroundColor: Colors.white.withOpacity(0.9),
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//         ),
//         Positioned(
//           left: 20,
//           bottom: 24,
//           child: Text(
//             widget.serviceName,
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: const Color.fromARGB(255, 0, 0, 0),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBody() {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (hasError) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.error_outline,
//                 size: 80,
//                 color: Colors.redAccent,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Something went wrong.\nPlease check your connection or try again later.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.roboto(fontSize: 18, color: Colors.black54),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: fetchVendors,
//                 child: const Text("Retry"),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else if (vendors.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.hourglass_empty,
//                 size: 80,
//                 color: Colors.black26,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "No vendors available for ${widget.serviceName} currently.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.roboto(fontSize: 18, color: Colors.black54),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: vendors.length,
//         itemBuilder: (context, index) {
//           final vendor = vendors[index];
//           final isApproved = vendor.status == 1;

//           return InkWell(
//             onTap:
//                 isApproved
//                     ? () => navigateToVendorDetail(vendor.vendorId)
//                     : null,
//             borderRadius: BorderRadius.circular(20),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFFFAF0E6), Color(0xFFF5E9DC)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Removed image from the card
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     width: double.infinity,
//                     child: Text(
//                       vendor.businessName,
//                       style: GoogleFonts.roboto(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.brown.shade900,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       vendor.description,
//                       style: GoogleFonts.roboto(
//                         fontSize: 15,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: ElevatedButton.icon(
//                         onPressed:
//                             isApproved
//                                 ? () => navigateToVendorDetail(vendor.vendorId)
//                                 : null,
//                         icon: Icon(isApproved ? Icons.visibility : Icons.lock),
//                         label: Text(isApproved ? "View" : "Not Available"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               isApproved
//                                   ? Colors.deepOrangeAccent
//                                   : Colors.grey,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:convert';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import '../models/vendormodel.dart';
// import '../screens/VendorServicePage.dart';

// class ServiceVendorPage extends StatefulWidget {
//   final String serviceName;
//   final String headerImage;

//   const ServiceVendorPage({
//     super.key,
//     required this.serviceName,
//     required this.headerImage,
//   });

//   @override
//   State<ServiceVendorPage> createState() => _ServiceVendorPageState();
// }

// class _ServiceVendorPageState extends State<ServiceVendorPage> {
//   List<Vendor> vendors = [];
//   bool isLoading = true;
//   bool hasError = false;

//   Future<void> fetchVendors() async {
//     final businessType = widget.serviceName;

//     try {
//       final response = await http
//           .get(
//             Uri.parse('http://192.168.1.4:8000/api/vendors/type/$businessType'),
//             headers: {'Accept': 'application/json'},
//           )
//           .timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == true && data['data'] != null) {
//           final List<Vendor> allVendors =
//               (data['data'] as List).map((v) => Vendor.fromJson(v)).toList();

//           setState(() {
//             vendors =
//                 allVendors
//                     .where((v) => v.status == 0 || v.status == 1)
//                     .toList();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//             hasError = true;
//           });
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//           hasError = true;
//         });
//       }
//     } on TimeoutException {
//       setState(() {
//         isLoading = false;
//         hasError = true;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         hasError = true;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchVendors();
//   }

//   void navigateToVendorDetail(int vendorId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => VendorServicePage(vendorId: vendorId),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(children: [_buildHeader(), Expanded(child: _buildBody())]),
//     );
//   }

//   Widget _buildHeader() {
//     // Decide background color based on loading/error
//     Color headerColor;
//     if (isLoading || hasError) {
//       headerColor = Colors.grey.shade300;
//     } else {
//       headerColor = Colors.deepOrange.shade400;
//     }

//     return Stack(
//       children: [
//         Container(
//           height: 140,
//           decoration: BoxDecoration(
//             color: headerColor,
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(24),
//               bottomRight: Radius.circular(24),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 48,
//           left: 16,
//           child: CircleAvatar(
//             backgroundColor: Colors.white.withOpacity(0.9),
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//         ),
//         Positioned(
//           left: 20,
//           bottom: 24,
//           child: Text(
//             widget.serviceName,
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBody() {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (hasError) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.error_outline,
//                 size: 80,
//                 color: Colors.redAccent,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Something went wrong.\nPlease check your connection or try again later.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.roboto(fontSize: 18, color: Colors.black54),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: fetchVendors,
//                 child: const Text("Retry"),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else if (vendors.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.hourglass_empty,
//                 size: 80,
//                 color: Colors.black26,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "No vendors available for ${widget.serviceName} currently.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.roboto(fontSize: 18, color: Colors.black54),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: vendors.length,
//         itemBuilder: (context, index) {
//           final vendor = vendors[index];
//           final isApproved = vendor.status == 1;

//           return InkWell(
//             onTap:
//                 isApproved
//                     ? () => navigateToVendorDetail(vendor.vendorId)
//                     : null,
//             borderRadius: BorderRadius.circular(20),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFFFAF0E6), Color(0xFFF5E9DC)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     width: double.infinity,
//                     child: Text(
//                       vendor.businessName,
//                       style: GoogleFonts.roboto(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.brown.shade900,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       vendor.description,
//                       style: GoogleFonts.roboto(
//                         fontSize: 15,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: ElevatedButton.icon(
//                         onPressed:
//                             isApproved
//                                 ? () => navigateToVendorDetail(vendor.vendorId)
//                                 : null,
//                         icon: Icon(isApproved ? Icons.visibility : Icons.lock),
//                         label: Text(isApproved ? "View" : "Not Available"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               isApproved
//                                   ? Colors.deepOrangeAccent
//                                   : Colors.grey,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:convert';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import '../models/vendormodel.dart';
// import '../screens/VendorServicePage.dart';

// class ServiceVendorPage extends StatefulWidget {
//   final String serviceName;
//   final String headerImage;

//   const ServiceVendorPage({
//     super.key,
//     required this.serviceName,
//     required this.headerImage,
//   });

//   @override
//   State<ServiceVendorPage> createState() => _ServiceVendorPageState();
// }

// class _ServiceVendorPageState extends State<ServiceVendorPage> {
//   List<Vendor> vendors = [];
//   bool isLoading = true;
//   bool hasError = false;

//   Future<void> fetchVendors() async {
//     final businessType = widget.serviceName;

//     try {
//       final response = await http
//           .get(
//             Uri.parse('http://192.168.1.4:8000/api/vendors/type/$businessType'),
//             headers: {'Accept': 'application/json'},
//           )
//           .timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == true && data['data'] != null) {
//           final List<Vendor> allVendors =
//               (data['data'] as List).map((v) => Vendor.fromJson(v)).toList();

//           setState(() {
//             vendors =
//                 allVendors
//                     .where((v) => v.status == 0 || v.status == 1)
//                     .toList();
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//             hasError = true;
//           });
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//           hasError = true;
//         });
//       }
//     } on TimeoutException {
//       setState(() {
//         isLoading = false;
//         hasError = true;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         hasError = true;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchVendors();
//   }

//   void navigateToVendorDetail(int vendorId, String vendorName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => VendorServicePage(
//               vendorId: vendorId,
//               serviceName: serviceName, // yahan correct argument
//             ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(children: [_buildHeader(), Expanded(child: _buildBody())]),
//     );
//   }

//   Widget _buildHeader() {
//     // Decide background color based on loading/error
//     Color headerColor;
//     if (isLoading || hasError) {
//       headerColor = Colors.grey.shade300;
//     } else {
//       headerColor = Colors.deepOrange.shade400;
//     }

//     return Stack(
//       children: [
//         Container(
//           height: 80, // reduced height
//           decoration: BoxDecoration(color: headerColor),
//         ),
//         Positioned(
//           top: 18,
//           left: 12,
//           child: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Color.fromARGB(255, 231, 230, 230),
//             ),
//             iconSize: 30, // arrow thoda bada aur visible
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         Positioned(
//           left: 60,
//           bottom: 22,
//           child: Text(
//             widget.serviceName,
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 28, // slightly smaller
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBody() {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (hasError) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.error_outline,
//                 size: 80,
//                 color: Colors.redAccent,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Something went wrong.\nPlease check your connection or try again later.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.roboto(fontSize: 18, color: Colors.black54),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: fetchVendors,
//                 child: const Text("Retry"),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else if (vendors.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.hourglass_empty,
//                 size: 80,
//                 color: Colors.black26,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "No vendors available for ${widget.serviceName} currently.",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.roboto(fontSize: 18, color: Colors.black54),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: vendors.length,
//         itemBuilder: (context, index) {
//           final vendor = vendors[index];
//           final isApproved = vendor.status == 1;

//           return InkWell(
//             onTap:
//                 isApproved
//                     ? () => navigateToVendorDetail(
//                       vendor.vendorId,
//                       vendor.serviceName,
//                     ) // ya jo bhi field hai
//                     : null,

//             borderRadius: BorderRadius.circular(20),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFFFAF0E6), Color(0xFFF5E9DC)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     width: double.infinity,
//                     child: Text(
//                       vendor.businessName,
//                       style: GoogleFonts.roboto(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.brown.shade900,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       vendor.description,
//                       style: GoogleFonts.roboto(
//                         fontSize: 15,
//                         color: Colors.black87,
//                       ),
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: ElevatedButton.icon(
//                         onPressed:
//                             isApproved
//                                 ? () => navigateToVendorDetail(vendor.vendorId)
//                                 : null,
//                         icon: Icon(isApproved ? Icons.visibility : Icons.lock),
//                         label: Text(isApproved ? "View" : "Not Available"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               isApproved
//                                   ? Colors.deepOrangeAccent
//                                   : Colors.grey,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/vendormodel.dart';
import '../screens/VendorServicePage.dart';

class ServiceVendorPage extends StatefulWidget {
  final String serviceName;
  final String headerImage;

  const ServiceVendorPage({
    super.key,
    required this.serviceName,
    required this.headerImage,
    required vendor,
  });

  @override
  State<ServiceVendorPage> createState() => _ServiceVendorPageState();
}

class _ServiceVendorPageState extends State<ServiceVendorPage> {
  List<Vendor> vendors = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void> fetchVendors() async {
    final businessType = widget.serviceName;

    try {
      final response = await http
          .get(
            Uri.parse('http://192.168.1.6:8000/api/vendors/type/$businessType'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final List<Vendor> allVendors =
              (data['data'] as List).map((v) => Vendor.fromJson(v)).toList();

          setState(() {
            vendors =
                allVendors
                    .where((v) => v.status == 0 || v.status == 1)
                    .toList();
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            hasError = true;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } on TimeoutException {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVendors();
  }

  void navigateToVendorDetail(int vendorId, String vendorName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => VendorServicePage(
              vendorId: vendorId,
              serviceName: vendorName, // pass businessName or name
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [_buildHeader(), Expanded(child: _buildBody())]),
    );
  }

  Widget _buildHeader() {
    Color headerColor =
        (isLoading || hasError)
            ? Colors.grey.shade300
            : Colors.deepOrange.shade400;

    return Stack(
      children: [
        Container(height: 80, decoration: BoxDecoration(color: headerColor)),
        Positioned(
          top: 18,
          left: 12,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            iconSize: 30,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          left: 60,
          bottom: 22,
          child: Text(
            widget.serviceName,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (hasError) return _buildErrorWidget();
    if (vendors.isEmpty) return _buildEmptyWidget();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        final isApproved = vendor.status == 1;

        return InkWell(
          onTap:
              isApproved
                  ? () => navigateToVendorDetail(
                    vendor.vendorId,
                    vendor.businessName,
                  )
                  : null,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFAF0E6), Color(0xFFF5E9DC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: Text(
                    vendor.businessName,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade900,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    vendor.description,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton.icon(
                      onPressed:
                          isApproved
                              ? () => navigateToVendorDetail(
                                vendor.vendorId,
                                vendor.businessName,
                              )
                              : null,
                      icon: Icon(isApproved ? Icons.visibility : Icons.lock),
                      label: Text(isApproved ? "View" : "Not Available"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isApproved ? Colors.deepOrangeAccent : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
            const SizedBox(height: 20),
            Text(
              "Something went wrong.\nPlease check your connection or try again later.",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: fetchVendors, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty, size: 80, color: Colors.black26),
            const SizedBox(height: 20),
            Text(
              "No vendors available for ${widget.serviceName} currently.",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
