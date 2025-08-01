import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('user_name') ?? '';
    emailController.text = prefs.getString('user_email') ?? '';
    contactController.text = prefs.getString('user_contact') ?? '';
    addressController.text = prefs.getString('user_address') ?? '';

    setState(() => isLoading = false);
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final url = Uri.parse('http://192.168.1.4:8000/api/update-profile');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('auth_token');
    final int userId = prefs.getInt('user_id') ?? 0;

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'name': nameController.text,
          'email': emailController.text,
          'contact': contactController.text,
          'address': addressController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        await prefs.setString('user_name', data['user']['name']);
        await prefs.setString('user_email', data['user']['email']);
        await prefs.setString('user_contact', data['user']['contact'] ?? '');
        await prefs.setString('user_address', data['user']['address'] ?? '');

        await prefs.setInt('user_id', data['user']['user_id']);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Update failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.deepOrange, // Premium orange header
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator:
                            (value) => value!.isEmpty ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator:
                            (value) => value!.isEmpty ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: contactController,
                        decoration: const InputDecoration(labelText: 'Contact'),
                        validator:
                            (value) => value!.isEmpty ? 'Enter contact' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator:
                            (value) => value!.isEmpty ? 'Enter address' : null,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: updateProfile,
                        child: const Text("Save Changes"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
