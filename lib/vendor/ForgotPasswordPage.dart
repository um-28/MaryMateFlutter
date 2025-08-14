
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({Key? key}) : super(key: key);

//   @override
//   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final TextEditingController _emailController = TextEditingController();
//   bool isLoading = false;

//   Future<void> sendResetLink() async {
//     if (_emailController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please enter your email")));
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     var url = Uri.parse("http://192.168.1.4:8000/api/forgot-password");
//     var response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({"email": _emailController.text}),
//     );

//     setState(() {
//       isLoading = false;
//     });

//     var data = json.decode(response.body);

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(data["message"] ?? "Reset link sent"),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(data["message"] ?? "Error sending link"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.white,
//       // appBar: AppBar(
//       //   title: const Text("Forgot Password"),
//       //   backgroundColor: Colors.deepPurple[700],
//       //     backgroundColor: Colors.white,
//       //   elevation: 0,
//       // ),
//       appBar: AppBar(
//         title: const Text(
//           "Forgot Password",
//           style: TextStyle(color: Colors.white), // title color
//         ),
//         backgroundColor: Colors.deepPurple, // AppBar background white
//         elevation: 0,
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ), // back button/icon color
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 40),
//               const Text(
//                 "Forgot your password?",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 "Enter your email below and we'll send you a link to reset your password.",
//                 style: TextStyle(fontSize: 16, color: Colors.black54),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   hintText: "Email",
//                   prefixIcon: const Icon(Icons.email, color: Colors.deepPurple),
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     vertical: 18,
//                     horizontal: 16,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               isLoading
//                   ? const Center(
//                     child: CircularProgressIndicator(color: Colors.deepPurple),
//                   )
//                   : GestureDetector(
//                     onTap: sendResetLink,
//                     child: Container(
//                       height: 55,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.deepPurple.withOpacity(0.4),
//                             offset: const Offset(0, 4),
//                             blurRadius: 6,
//                           ),
//                         ],
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "Send Reset Link",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  void showMessage(String message, {bool success = true}) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: success ? Colors.green : Colors.red,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  Future<void> sendResetLink() async {
    if (_emailController.text.isEmpty) {
      showMessage("Please enter your email", success: false);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var url = Uri.parse("http://192.168.1.4:8000/api/forgot-password");
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": _emailController.text}),
      );

      var data = json.decode(response.body);

      if (response.statusCode == 200) {
        showMessage(data["message"] ?? "Reset link sent");
      } else {
        showMessage(data["message"] ?? "Error sending link", success: false);
      }
    } catch (e) {
      showMessage("Something went wrong", success: false);
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
        title: const Text(
          "Forgot Password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Forgot your password?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Enter your email below and we'll send you a link to reset your password.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email, color: Colors.deepPurple),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  )
                  : GestureDetector(
                    onTap: sendResetLink,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.4),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Send Reset Link",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
