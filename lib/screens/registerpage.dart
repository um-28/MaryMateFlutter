import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String fullName = '';
  String email = '';
  String password = '';
  String contact = '';
  String address = '';
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> registerUser() async {
    setState(() => _isLoading = true);

    final url = Uri.parse("http://192.168.1.7:8000/api/register");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': fullName,
          'email': email,
          'password': password,
          'contact': contact,
          'address': address,
          'role_as': 'C',
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.deepPurple,
          ),
        );
        Future.delayed(const Duration(milliseconds: 800), () {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        });
      } else {
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          String combinedErrors = errors.values
              .map((e) => e[0].toString())
              .join('\n');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(combinedErrors),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          final errorMsg = responseData['message'] ?? 'Registration failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset('assets/images/marrymate.png', height: 100),
                  const SizedBox(height: 16),
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Join MarryMate and plan your dream wedding!',
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextField(
                      label: 'Full Name',
                      icon: Icons.person,
                      validatorMsg: 'Please enter your full name',
                      onSaved: (val) => fullName = val!.trim(),
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: 'Email Address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validatorMsg: 'Please enter a valid email address',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[^@]+@[^@]+\.[^@]+',
                        ).hasMatch(val.trim())) {
                          return 'Invalid email format';
                        }
                        return null;
                      },
                      onSaved: (val) => email = val!.trim(),
                    ),
                    const SizedBox(height: 20),
                    buildPasswordField(),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: 'Contact Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validatorMsg: 'Please enter a valid contact number',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter contact number';
                        }
                        if (!RegExp(
                          r'^\+?[0-9]{10,15}$',
                        ).hasMatch(val.trim())) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                      onSaved: (val) => contact = val!.trim(),
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: 'Address',
                      icon: Icons.home,
                      maxLines: 3,
                      validatorMsg: 'Please enter your address',
                      onSaved: (val) => address = val!.trim(),
                    ),
                    const SizedBox(height: 35),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          registerUser(); // Call API
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child:
                              _isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 14),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.login);
                          },
                          child: const Text(
                            " Login",
                            style: TextStyle(
                              color: Color(0xFF2575FC),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required IconData icon,
    String? validatorMsg,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    required Function(String?) onSaved,
  }) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      validator:
          validator ??
          (val) {
            if (val == null || val.trim().isEmpty) {
              return validatorMsg ?? 'This field is required';
            }
            return null;
          },
      onSaved: onSaved,
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'Please enter a password';
        if (val.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
      onSaved: (val) => password = val ?? '',
    );
  }
}
