import 'package:flutter/material.dart';
import 'package:marry_mate28/vendor/BookingsDataPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/loginpage.dart';
import 'VendorAvailabilityPage.dart';
import '../vendor/service_data_page.dart';
import '../vendor/PackageDataPage.dart';
import '../vendor/ReViewDataPage.dart';
import '../vendor/ReportsDataPage.dart';

class VendorPanelPage extends StatefulWidget {
  const VendorPanelPage({super.key});

  @override
  State<VendorPanelPage> createState() => _VendorPanelPageState();
}

class _VendorPanelPageState extends State<VendorPanelPage> {
  String userName = '';
  String userEmail = '';
  int? userId;

  bool showAvailability = false;
  bool showServices = false;
  bool showTrash = false;
  bool showPackages = false;
  bool showBookings = false;
  bool showReviews = false;
  bool showReports = false;

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
      userId = prefs.getInt('user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
        backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Components',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Grid of cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  serviceCard(
                    icon: Icons.event_available,
                    title: 'Availability',
                    onTap: () {
                      setState(() {
                        showAvailability = true;
                        showServices = false;
                        showPackages = false;
                        showBookings = false;
                        showReviews = false;
                        showReports = false;
                      });
                    },
                  ),
                  serviceCard(
                    icon: Icons.design_services,
                    title: 'Services',
                    onTap: () {
                      setState(() {
                        showServices = true;
                        showAvailability = false;
                        showPackages = false;
                        showBookings = false;
                        showReviews = false;
                        showReports = false;
                      });
                    },
                  ),
                  serviceCard(
                    icon: Icons.card_giftcard,
                    title: 'Packages',
                    onTap: () {
                      setState(() {
                        showPackages = true;
                        showServices = false;
                        showAvailability = false;
                        showBookings = false;
                        showReviews = false;
                        showReports = false;
                      });
                    },
                  ),
                  serviceCard(
                    icon: Icons.book_online,
                    title: 'Bookings',
                    onTap: () {
                      setState(() {
                        showBookings = true;
                        showPackages = false;
                        showServices = false;
                        showAvailability = false;
                        showReviews = false;
                        showReports = false;
                      });
                    },
                  ),
                  // serviceCard(icon: Icons.reviews, title: 'Reviews'),
                  serviceCard(
                    icon: Icons.reviews,
                    title: 'Reviews',
                    onTap: () {
                      setState(() {
                        showReviews = true;
                        showAvailability = false;
                        showServices = false;
                        showPackages = false;
                        showBookings = false;
                        showReports = false;
                        
                      });
                    },
                  ),
                  // serviceCard(icon: Icons.analytics, title: 'Reports'),
                  serviceCard(
                    icon: Icons.analytics,
                    title: 'Reports',
                    onTap: () {
                      setState(() {
                        showReports = true;
                        showReviews = false;
                        showAvailability = false;
                        showServices = false;
                        showPackages = false;
                        showBookings = false;
                      });
                    },
                  ),
                ],
              ),
            ),

            if (showAvailability)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: VendorAvailabilityPage(),
                ),
              ),

            if (showServices)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  child: ServiceDataPage(),
                ),
              ),

            if (showPackages)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  child: PackageDataPage(),
                ),
              ),

            if (showBookings && userId != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  child: BookingsDataPage(userId: userId!),
                ),
              ),
            if (showReviews && userId != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  child: ReviewDataPage(
                    userId: userId!.toString(),
                  ), // convert int to String here
                ),
              ),
               if (showReports && userId != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  child: ReportsDataPage(
                    userId: userId!.toString(),
                  ), // convert int to String here
                ),
              ),
          ],
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

  Widget serviceCard({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
      child: Card(
        color: Colors.white,
        elevation: 2.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        shadowColor: Colors.grey.shade300,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: Colors.deepPurple),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
