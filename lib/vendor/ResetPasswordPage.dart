// import 'package:flutter/material.dart';

// class ResetPasswordPage extends StatefulWidget {
//   final String token;

//   const ResetPasswordPage({Key? key, required this.token}) : super(key: key);

//   @override
//   State<ResetPasswordPage> createState() => _ResetPasswordPageState();
// }

// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Reset Password")),
//       body: Center(
//         child: Text("Token: ${widget.token}"), // Replace with your reset form
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ResetPasswordPage extends StatefulWidget {
//   final String token;
//   const ResetPasswordPage({Key? key, required this.token}) : super(key: key);

//   @override
//   State<ResetPasswordPage> createState() => _ResetPasswordPageState();
// }

// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   bool isLoading = false;

//   Future<void> resetPassword() async {
//     if (_passwordController.text.isEmpty ||
//         _confirmPasswordController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
//       return;
//     }

//     if (_passwordController.text.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password must be at least 6 characters")),
//       );
//       return;
//     }

//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     var url = Uri.parse("http://192.168.1.4:8000/api/reset-password");
//     try {
//       var response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: json.encode({
//           "token": widget.token,
//           "password": _passwordController.text,
//           "password_confirmation": _confirmPasswordController.text,
//         }),
//       );

//       var data = json.decode(response.body);

//       if (response.statusCode == 200 && data["status"] == true) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Password reset successful"),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context); // back to login page
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(data["message"] ?? "Failed to reset password"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Something went wrong"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Reset Password")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Text(
//               "Token: ${widget.token}",
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: "New Password",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: "Confirm Password",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                   onPressed: resetPassword,
//                   child: const Text("Change Password"),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../routes/app_routes.dart';

// class ResetPasswordPage extends StatefulWidget {
//   final String token;
//   const ResetPasswordPage({Key? key, required this.token}) : super(key: key);

//   @override
//   State<ResetPasswordPage> createState() => _ResetPasswordPageState();
// }

// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   bool isLoading = false;

//   Future<void> resetPassword() async {
//     if (_passwordController.text.isEmpty ||
//         _confirmPasswordController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
//       return;
//     }

//     if (_passwordController.text.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Password must be at least 6 characters")),
//       );
//       return;
//     }

//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     var url = Uri.parse("http://192.168.1.4:8000/api/reset-password");

//     try {
//       var response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: json.encode({
//           "token": widget.token,
//           "password": _passwordController.text,
//           "password_confirmation": _confirmPasswordController.text,
//         }),
//       );

//       var data = json.decode(response.body);

//       if (response.statusCode == 200 && data["status"] == true) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(data["message"] ?? "Password reset successful"),
//             backgroundColor: Colors.green,
//           ),
//         );

//         // Redirect to login page after short delay
//         Future.delayed(const Duration(seconds: 1), () {
//           Navigator.pushReplacementNamed(context, AppRoutes.login);
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(data["message"] ?? "Failed to reset password"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Something went wrong"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Reset Password")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Text(
//               "Token: ${widget.token}",
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: "New Password",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: "Confirm Password",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                   onPressed: resetPassword,
//                   child: const Text("Change Password"),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import '../routes/app_routes.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;
  const ResetPasswordPage({Key? key, required this.token}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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

  Future<void> resetPassword() async {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      showMessage("Please fill all fields", success: false);
      return;
    }

    if (_passwordController.text.length < 6) {
      showMessage("Password must be at least 6 characters", success: false);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showMessage("Passwords do not match", success: false);
      return;
    }

    setState(() {
      isLoading = true;
    });

    var url = Uri.parse("http://192.168.1.4:8000/api/reset-password");

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "token": widget.token,
          "password": _passwordController.text,
          "password_confirmation": _confirmPasswordController.text,
        }),
      );

      var data = json.decode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        showMessage(data["message"] ?? "Password reset successful");

        // Redirect to login page after short delay
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        });
      } else {
        showMessage(
          data["message"] ?? "Failed to reset password",
          success: false,
        );
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
          "Reset Password",
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
                "Reset Your Password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Enter your new password below and confirm it to reset your password.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Token: ${widget.token}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "New Password",
                  prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
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
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
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
                    onTap: resetPassword,
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
                          "Change Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
