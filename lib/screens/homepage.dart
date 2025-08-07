import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../screens/custom_package_detail_page.dart';
import '../screens/service_vendor_page.dart'; // ✅ Make sure this file exists

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> sliderImages = [
    "assets/images/hall.jpg",
    "assets/images/decor.jpg",
    "assets/images/catering.jpg",
  ];

  final List<Map<String, String>> services = [
    {"name": "Wedding Hall", "image": "assets/images/hall.jpg"},
    {"name": "Decorator", "image": "assets/images/decor.jpg"},
    {"name": "Catering", "image": "assets/images/catering.jpg"},
    {"name": "Pandit", "image": "assets/images/pandit.jpg"},
    {"name": "DJ & Sound System", "image": "assets/images/dj.jpg"},
    {"name": "Saloon", "image": "assets/images/saloon.jpg"},
    {"name": "Transport", "image": "assets/images/trasport.jpg"},
  ];

  int _currentSlide = 0;
  late PageController _pageController;
  Timer? _timer;

  List<dynamic> customPackages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
    fetchCustomPackages();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _currentSlide = (_currentSlide + 1) % sliderImages.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentSlide,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> fetchCustomPackages() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.9:8000/api/showCustomPackage"),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          customPackages = jsonData['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load custom packages');
      }
    } catch (e) {
      print("Error fetching custom packages: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildImageSlider(),
            const SizedBox(height: 24),
            _buildAnimatedBanner(),
            const SizedBox(height: 24),
            _buildServiceSection(), // ✅ Fixed: Services section
            const SizedBox(height: 24),
            _buildCustomPackageSection(), // ✅ Custom packages section
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.deepOrange),
          hintText: "Search wedding services...",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              itemCount: sliderImages.length,
              onPageChanged: (index) => setState(() => _currentSlide = index),
              itemBuilder: (context, index) {
                return Image.asset(
                  sliderImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(sliderImages.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentSlide == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    _currentSlide == index
                        ? Colors.deepOrange
                        : Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAnimatedBanner() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 1),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFEECE9), Color(0xFFFFD6C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  "Plan Your Dream Wedding\nwith Marry Mate",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 12, 12, 12),
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our Premium Services",
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ServiceVendorPage(
                            serviceName: service['name']!,
                            headerImage: service['image']!,
                          ),
                    ),
                  );
                },
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(service['image']!),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              // ignore: deprecated_member_use
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 12,
                        child: Text(
                          service['name']!,
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomPackageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our Custom Packages",
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
              height: 230,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: customPackages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final package = customPackages[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                              // CustomPackageDetailPage(packageData: package),
                              CustomPackageDetailPage(
                                packageId:
                                    package['ap_id'], // make sure this matches your backend key
                                packageData: package,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage(
                            "assets/images/custompackageimage.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  // ignore: deprecated_member_use
                                  Colors.black.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 12,
                            child: Text(
                              package['package_name'] ?? '',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }
}
