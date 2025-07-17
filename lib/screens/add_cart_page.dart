// import 'package:flutter/material.dart';
// import '../models/service_model.dart';

// class AddCartPage extends StatelessWidget {
//   final List<VendorService> cartItems;

//   const AddCartPage({super.key, required this.cartItems});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Your Cart")),
//       body:
//           cartItems.isEmpty
//               ? const Center(child: Text("Your cart is empty."))
//               : ListView.builder(
//                 itemCount: cartItems.length,
//                 itemBuilder: (context, index) {
//                   final item = cartItems[index];
//                   String start =
//                       item.startDate != null
//                           ? item.startDate!.toLocal().toString().split(' ')[0]
//                           : "N/A";
//                   String end =
//                       item.endDate != null
//                           ? item.endDate!.toLocal().toString().split(' ')[0]
//                           : "N/A";

//                   return Card(
//                     margin: const EdgeInsets.all(8),
//                     child: ListTile(
//                       leading: Image.network(
//                         item.images.first,
//                         width: 60,
//                         fit: BoxFit.cover,
//                       ),
//                       title: Text(item.serviceType),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("₹${item.price.toStringAsFixed(2)}"),
//                           const SizedBox(height: 4),
//                           Text("From: $start"),
//                           Text("To: $end"),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../data/cart_data.dart';
// import '../models/service_model.dart';

class AddCartPage extends StatefulWidget {
  const AddCartPage({super.key});

  @override
  State<AddCartPage> createState() => _AddCartPageState();
}

class _AddCartPageState extends State<AddCartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body:
          globalCartItems.isEmpty
              ? const Center(child: Text("Your cart is empty."))
              : ListView.builder(
                itemCount: globalCartItems.length,
                itemBuilder: (context, index) {
                  final service = globalCartItems[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(service.serviceType),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price: ₹${service.price}"),
                          Text(
                            "From: ${service.startDate?.toLocal().toString().split(' ')[0]}",
                          ),
                          Text(
                            "To: ${service.endDate?.toLocal().toString().split(' ')[0]}",
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            globalCartItems.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Item removed from cart"),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
