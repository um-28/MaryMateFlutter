import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  int? userId;
  bool isLoading = true; // Flag to manage loading state

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
      name = prefs.getString('user_name');
      email = prefs.getString('user_email');
      isLoading = false; // Loading complete
    });
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : userId == null
                ? const Center(
                  child: Text(
                    "User not logged in",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text("Logout"),
                        onPressed: logoutUser,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "User ID: $userId",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text("Name: $name", style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text("Email: $email", style: const TextStyle(fontSize: 18)),
                  ],
                ),
      ),
    );
  }
}
