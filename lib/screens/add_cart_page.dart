// import 'package:flutter/material.dart';
// import 'package:marry_mate28/screens/Checkout2Page.dart';
// import '../data/cart_data.dart';

// class AddCartPage extends StatefulWidget {
//   const AddCartPage({super.key});

//   @override
//   State<AddCartPage> createState() => _AddCartPageState();
// }

// class _AddCartPageState extends State<AddCartPage> {
//   @override
//   void initState() {
//     super.initState();
//     loadCartFromPrefs().then((_) {
//       setState(() {});
//     });
//   }

//   double getTotalPrice() {
//     double total = 0.0;
//     for (var service in globalCartItems) {
//       if (service.startDate != null && service.endDate != null) {
//         int days = service.endDate!.difference(service.startDate!).inDays + 1;
//         if (days < 1) days = 1;
//         total += service.price * days;
//       } else {
//         total += service.price;
//       }
//     }
//     return total;
//   }

//   int calculateDays(DateTime? start, DateTime? end) {
//     if (start == null || end == null) return 1;
//     int days = end.difference(start).inDays + 1;
//     return days < 1 ? 1 : days;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Cart"),
//         backgroundColor: Colors.deepOrangeAccent,
//         foregroundColor: Colors.white,
//       ),
//       body:
//           globalCartItems.isEmpty
//               ? const Center(
//                 child: Text(
//                   "Your cart is empty!",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//               )
//               : SafeArea(
//                 child: Stack(
//                   children: [
//                     Positioned.fill(
//                       child: ListView.builder(
//                         padding: const EdgeInsets.only(bottom: 160),
//                         itemCount: globalCartItems.length,
//                         itemBuilder: (context, index) {
//                           final service = globalCartItems[index];
//                           final int days = calculateDays(
//                             service.startDate,
//                             service.endDate,
//                           );
//                           final double totalItemPrice = service.price * days;

//                           return Container(
//                             margin: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 10,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 6,
//                                   offset: const Offset(0, 3),
//                                 ),
//                               ],
//                               border: Border.all(
//                                 color: Colors.deepOrangeAccent.shade100,
//                                 width: 1.2,
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(16),
//                                     topRight: Radius.circular(16),
//                                   ),
//                                   child:
//                                       service.images.isNotEmpty
//                                           ? Image.network(
//                                             service.images.first,
//                                             height: 180,
//                                             width: double.infinity,
//                                             fit: BoxFit.cover,
//                                           )
//                                           : Container(
//                                             height: 180,
//                                             color: Colors.grey[300],
//                                             alignment: Alignment.center,
//                                             child: const Icon(
//                                               Icons.image,
//                                               size: 60,
//                                             ),
//                                           ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 12,
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         service.serviceType,
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.deepOrangeAccent,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.calendar_today,
//                                             size: 16,
//                                             color: Colors.grey,
//                                           ),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             "From: ${service.startDate?.toLocal().toString().split(' ')[0]}",
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.calendar_month,
//                                             size: 16,
//                                             color: Colors.grey,
//                                           ),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             "To: ${service.endDate?.toLocal().toString().split(' ')[0]}",
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         "Per Day Price: ₹${service.price.toStringAsFixed(2)}",
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.black54,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         "Total (${service.price.toStringAsFixed(0)} × $days days): ₹${totalItemPrice.toStringAsFixed(2)}",
//                                         style: const TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 12),
//                                       Align(
//                                         alignment: Alignment.centerRight,
//                                         child: ElevatedButton.icon(
//                                           onPressed: () {
//                                             setState(() {
//                                               globalCartItems.removeAt(index);
//                                             });
//                                             saveCartToPrefs(); // 🔁 Save after removal
//                                             ScaffoldMessenger.of(
//                                               context,
//                                             ).showSnackBar(
//                                               const SnackBar(
//                                                 content: Text(
//                                                   "Item removed from cart",
//                                                 ),
//                                               ),
//                                             );
//                                           },

//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor:
//                                                 Colors.deepOrangeAccent,
//                                             foregroundColor: Colors.white,
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 16,
//                                               vertical: 10,
//                                             ),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                           icon: const Icon(Icons.delete),
//                                           label: const Text("Remove"),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),

//                     // ✅ Bottom total and confirm button
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(20),
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 8,
//                               offset: Offset(0, -2),
//                             ),
//                           ],
//                           borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(20),
//                           ),
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   "Total:",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 Text(
//                                   "₹${getTotalPrice().toStringAsFixed(2)}",
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 14),
//                             ElevatedButton(
//                               onPressed: () {
//                                 final List<Map<String, dynamic>> checkoutData =
//                                     globalCartItems.map((item) {
//                                       print("Preparing item:");
//                                       print(
//                                         "Service ID: ${item.serviceId}, Vendor ID: ${item.vendorId}, Package ID: ${item.packageId}",
//                                       );

//                                       return {
//                                         "service_id": item.serviceId,
//                                         "vendor_id": item.vendorId,
//                                         "package_id": item.packageId ?? 0,
//                                         "price": item.price,
//                                         "start_date":
//                                             item.startDate?.toIso8601String(),
//                                         "end_date":
//                                             item.endDate?.toIso8601String(),
//                                       };
//                                     }).toList();

//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) => Checkout2Page(
//                                           cartItems: checkoutData,
//                                           totalPrice: getTotalPrice(),
//                                           userId:
//                                               1, // 🔁 Replace with real user ID if available
//                                         ),
//                                   ),
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.deepOrangeAccent,
//                                 minimumSize: const Size.fromHeight(50),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Confirm Booking",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:marry_mate28/screens/Checkout2Page.dart';
import '../data/cart_data.dart';

class AddCartPage extends StatefulWidget {
  const AddCartPage({super.key});

  @override
  State<AddCartPage> createState() => _AddCartPageState();
}

class _AddCartPageState extends State<AddCartPage> {
  @override
  void initState() {
    super.initState();
    loadCartFromPrefs().then((_) {
      setState(() {});
    });
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var service in globalCartItems) {
      if (service.startDate != null && service.endDate != null) {
        int days = service.endDate!.difference(service.startDate!).inDays + 1;
        if (days < 1) days = 1;
        total += service.price * days;
      } else {
        total += service.price;
      }
    }
    return total;
  }

  int calculateDays(DateTime? start, DateTime? end) {
    if (start == null || end == null) return 1;
    int days = end.difference(start).inDays + 1;
    return days < 1 ? 1 : days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
      ),
      body:
          globalCartItems.isEmpty
              ? const Center(
                child: Text(
                  "Your cart is empty!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
              : SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 160),
                        itemCount: globalCartItems.length,
                        itemBuilder: (context, index) {
                          final service = globalCartItems[index];
                          final int days = calculateDays(
                            service.startDate,
                            service.endDate,
                          );
                          final double totalItemPrice = service.price * days;

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.deepOrangeAccent.shade100,
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child:
                                      service.images.isNotEmpty
                                          ? Image.network(
                                            service.images.first,
                                            height: 180,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                          : Container(
                                            height: 180,
                                            color: Colors.grey[300],
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.image,
                                              size: 60,
                                            ),
                                          ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service.serviceType,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrangeAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "From: ${service.startDate?.toLocal().toString().split(' ')[0]}",
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_month,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "To: ${service.endDate?.toLocal().toString().split(' ')[0]}",
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Per Day Price: ₹${service.price.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Total (${service.price.toStringAsFixed(0)} × $days days): ₹${totalItemPrice.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // ✅ Display IDs
                                      Text(
                                        "Service ID: ${service.serviceId}",
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      Text(
                                        "Package ID: ${service.packageId ?? 'N/A'}",
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      Text(
                                        "Vendor ID: ${service.vendorId}",
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            setState(() {
                                              globalCartItems.removeAt(index);
                                            });
                                            saveCartToPrefs();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Item removed from cart",
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.deepOrangeAccent,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          icon: const Icon(Icons.delete),
                                          label: const Text("Remove"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // ✅ Bottom bar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, -2),
                            ),
                          ],
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "₹${getTotalPrice().toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () {
                                final List<Map<String, dynamic>> checkoutData =
                                    globalCartItems.map((item) {
                                      print("Preparing item:");
                                      print(
                                        "Service ID: ${item.serviceId}, Vendor ID: ${item.vendorId}, Package ID: ${item.packageId}",
                                      );

                                      return {
                                        "service_id": item.serviceId,
                                        "vendor_id": item.vendorId,
                                        "package_id": item.packageId ?? 0,
                                        "price": item.price,
                                        "start_date":
                                            item.startDate?.toIso8601String(),
                                        "end_date":
                                            item.endDate?.toIso8601String(),
                                      };
                                    }).toList();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => Checkout2Page(
                                          cartItems: checkoutData,
                                          totalPrice: getTotalPrice(),
                                          userId:
                                              1, // Replace with real user ID
                                        ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Confirm Booking",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
