// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:convert';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import '../models/vendormodel.dart';
// import '../screens/VendorServicePage.dart';
// import '../config/api_config.dart';

// class ServiceVendorPage extends StatefulWidget {
//   final String serviceName;
//   final String headerImage;

//   const ServiceVendorPage({
//     super.key,
//     required this.serviceName,
//     required this.headerImage,
//     required vendor,
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
//             Uri.parse('${ApiConfig.baseUrl}/api/vendors/type/$businessType'),
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
//               serviceName: vendorName, // pass businessName or name
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
//     Color headerColor =
//         (isLoading || hasError)
//             ? Colors.grey.shade300
//             : Colors.deepOrange.shade400;

//     return Stack(
//       children: [
//         Container(height: 80, decoration: BoxDecoration(color: headerColor)),
//         Positioned(
//           top: 18,
//           left: 12,
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             iconSize: 30,
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         Positioned(
//           left: 60,
//           bottom: 22,
//           child: Text(
//             widget.serviceName,
//             style: GoogleFonts.playfairDisplay(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBody() {
//     if (isLoading) return const Center(child: CircularProgressIndicator());
//     if (hasError) return _buildErrorWidget();
//     if (vendors.isEmpty) return _buildEmptyWidget();

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: vendors.length,
//       itemBuilder: (context, index) {
//         final vendor = vendors[index];
//         final isApproved = vendor.status == 1;

//         return InkWell(
//           onTap:
//               isApproved
//                   ? () => navigateToVendorDetail(
//                     vendor.vendorId,
//                     vendor.businessName,
//                   )
//                   : null,
//           borderRadius: BorderRadius.circular(20),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             margin: const EdgeInsets.only(bottom: 20),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFFAF0E6), Color(0xFFF5E9DC)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   blurRadius: 10,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   width: double.infinity,
//                   child: Text(
//                     vendor.businessName,
//                     style: GoogleFonts.roboto(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.brown.shade900,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     vendor.description,
//                     style: GoogleFonts.roboto(
//                       fontSize: 15,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     child: ElevatedButton.icon(
//                       onPressed:
//                           isApproved
//                               ? () => navigateToVendorDetail(
//                                 vendor.vendorId,
//                                 vendor.businessName,
//                               )
//                               : null,
//                       icon: Icon(isApproved ? Icons.visibility : Icons.lock),
//                       label: Text(isApproved ? "View" : "Not Available"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             isApproved ? Colors.deepOrangeAccent : Colors.grey,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildErrorWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
//             const SizedBox(height: 20),
//             Text(
//               "Something went wrong.\nPlease check your connection or try again later.",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.roboto(fontSize: 18, color: Colors.black54),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(onPressed: fetchVendors, child: const Text("Retry")),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.hourglass_empty, size: 80, color: Colors.black26),
//             const SizedBox(height: 20),
//             Text(
//               "No vendors available for ${widget.serviceName} currently.",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.roboto(fontSize: 18, color: Colors.black54),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/vendormodel.dart';
import '../screens/VendorServicePage.dart';
import '../config/api_config.dart';

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
            Uri.parse('${ApiConfig.baseUrl}/api/vendors/type/$businessType'),
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
            (context) =>
                VendorServicePage(vendorId: vendorId, serviceName: vendorName),
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
                // Business Name
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

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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

                // Rating Section (Below Description)
                if (vendor.rating != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < vendor.rating!.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          vendor.rating!.toStringAsFixed(1),
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 8),

                // View Button
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
