// import 'package:flutter/material.dart';

// class AddCartPage extends StatelessWidget {
//   const AddCartPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add to Cart")),
//       body: const Center(child: Text("Your cart is empty.")),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class AddCartPage extends StatelessWidget {
  final List<CartItem> cartItems;

  const AddCartPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add to Cart")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty."))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item.serviceName),
                    subtitle: Text(item.description),
                    trailing: Text("₹${item.price.toStringAsFixed(2)}"),
                  ),
                );
              },
            ),
    );
  }
}

