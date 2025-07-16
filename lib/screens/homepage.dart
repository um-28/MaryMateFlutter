import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'service_vendor_page.dart'; // <- Make sure this path is correct

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
    {"name": "Transportation", "image": "assets/images/trasport.jpg"},
  ];

  int _currentSlide = 0;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentSlide < sliderImages.length - 1) {
        _currentSlide++;
      } else {
        _currentSlide = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentSlide,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildImageSlider(),
            const SizedBox(height: 24),
            _buildBanner(),
            const SizedBox(height: 24),
            _buildServiceSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.black87),
          hintText: "Search services...",
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: sliderImages.length,
            onPageChanged: (index) => setState(() => _currentSlide = index),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(sliderImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
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
                    _currentSlide == index ? Colors.black87 : Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: Text(
        "Plan Your Dream Wedding\nwith MarryMate",
        textAlign: TextAlign.center,
        style: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our Services",
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
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
                        left: 10,
                        child: Text(
                          service['name']!,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
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
