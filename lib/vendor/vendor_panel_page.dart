import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/loginpage.dart';
import '../vendor/VendorAvailabilityPage.dart';

class VendorPanelPage extends StatefulWidget {
  const VendorPanelPage({super.key});

  @override
  State<VendorPanelPage> createState() => _VendorPanelPageState();
}

class _VendorPanelPageState extends State<VendorPanelPage> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    loadVendorDetails();
  }

  Future<void> loadVendorDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? '';
      userEmail = prefs.getString('user_email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 4,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.deepPurple),
                accountName: Text(userName),
                accountEmail: Text(userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 6,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Component',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // buildDrawerItem(
              //   icon: Icons.event_available,
              //   title: 'Vendor Availability',
              //   onTap: () {},
              // ),
              buildDrawerItem(
                icon: Icons.event_available,
                title: 'Vendor Availability',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VendorAvailabilityPage(),
                    ),
                  );
                },
              ),
              buildDrawerItem(
                icon: Icons.design_services,
                title: 'Service Details',
                onTap: () {},
              ),
              buildDrawerItem(
                icon: Icons.card_giftcard,
                title: 'Package Details',
                onTap: () {},
              ),
              buildDrawerItem(
                icon: Icons.book_online,
                title: 'View Bookings',
                onTap: () {},
              ),
              buildDrawerItem(
                icon: Icons.reviews,
                title: 'View Reviews',
                onTap: () {},
              ),
              buildDrawerItem(
                icon: Icons.analytics,
                title: 'Generate Report',
                onTap: () {},
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 6,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Auth',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              buildDrawerItem(
                icon: Icons.person,
                title: 'Manage Profile',
                onTap: () {},
              ),
              buildDrawerItem(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // gradient: const LinearGradient(
              //   colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
            ),
            child: const Text(
              'Welcome to the Vendor Dashboard!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 14, 13, 13),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
