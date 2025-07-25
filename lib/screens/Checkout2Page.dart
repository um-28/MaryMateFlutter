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
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    for (var item in widget.cartItems) {
      print("🛒 Cart Item:");
      print("Service ID: ${item['service_id']}");
      print("Vendor ID: ${item['vendor_id']}");
      print("Package ID: ${item['package_id']}");
    }
    print("User ID: ${widget.userId}");
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
                return ListTile(
                  title: Text("Service ID: ${item['service_id']}"),
                  subtitle: Text(
                    "Vendor ID: ${item['vendor_id']}\n"
                    "Package ID: ${item['package_id']}\n"
                    "Start: ${item['start_date']}\n"
                    "End: ${item['end_date']}",
                  ),
                  trailing: Text("₹${item['price']}"),
                );
              }),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final fullData = {
                      "user_id": widget.userId,
                      "name": nameController.text,
                      "email": emailController.text,
                      "phone": phoneController.text,
                      "address": addressController.text,
                      "total": widget.totalPrice,
                      "items": widget.cartItems,
                    };

                    print("✅ Final Checkout Payload:");
                    print(fullData);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Data ready to send to backend"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
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
