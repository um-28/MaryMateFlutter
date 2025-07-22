// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'service_vendor_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final List<String> sliderImages = [
//     "assets/images/hall.jpg",
//     "assets/images/decor.jpg",
//     "assets/images/catering.jpg",
//   ];

//   final List<Map<String, String>> services = [
//     {"name": "Wedding Hall", "image": "assets/images/hall.jpg"},
//     {"name": "Decorator", "image": "assets/images/decor.jpg"},
//     {"name": "Catering", "image": "assets/images/catering.jpg"},
//     {"name": "Pandit", "image": "assets/images/pandit.jpg"},
//     {"name": "DJ & Sound System", "image": "assets/images/dj.jpg"},
//     {"name": "Saloon", "image": "assets/images/saloon.jpg"},
//     {"name": "Transportation", "image": "assets/images/trasport.jpg"},
//   ];

//   int _currentSlide = 0;
//   late PageController _pageController;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
//       if (_currentSlide < sliderImages.length - 1) {
//         _currentSlide++;
//       } else {
//         _currentSlide = 0;
//       }
//       if (_pageController.hasClients) {
//         _pageController.animateToPage(
//           _currentSlide,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             _buildSearchBar(),
//             const SizedBox(height: 16),
//             _buildImageSlider(),
//             const SizedBox(height: 24),
//             _buildBanner(),
//             const SizedBox(height: 24),
//             _buildServiceSection(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: const TextField(
//         decoration: InputDecoration(
//           icon: Icon(Icons.search, color: Colors.black87),
//           hintText: "Search services...",
//           border: InputBorder.none,
//         ),
//         style: TextStyle(color: Colors.black),
//       ),
//     );
//   }

//   Widget _buildImageSlider() {
//     return Column(
//       children: [
//         SizedBox(
//           height: 180,
//           child: PageView.builder(
//             controller: _pageController,
//             itemCount: sliderImages.length,
//             onPageChanged: (index) => setState(() => _currentSlide = index),
//             itemBuilder: (context, index) {
//               return Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 8),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   image: DecorationImage(
//                     image: AssetImage(sliderImages[index]),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(sliderImages.length, (index) {
//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               width: _currentSlide == index ? 16 : 8,
//               height: 8,
//               decoration: BoxDecoration(
//                 color:
//                     _currentSlide == index ? Colors.black87 : Colors.grey[400],
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildBanner() {
//     return TweenAnimationBuilder<double>(
//       duration: const Duration(seconds: 2),
//       tween: Tween(begin: 0, end: 1),
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(0, (1 - value) * 20),
//             child: child,
//           ),
//         );
//       },
//       child: Text(
//         "Plan Your Dream Wedding\nwith MarryMate",
//         textAlign: TextAlign.center,
//         style: GoogleFonts.playfairDisplay(
//           fontSize: 28,
//           fontWeight: FontWeight.w700,
//           color: Colors.black87,
//           height: 1.4,
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Our Services",
//           style: GoogleFonts.playfairDisplay(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           height: 230,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: services.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 16),
//             itemBuilder: (context, index) {
//               final service = services[index];
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (_) => ServiceVendorPage(
//                             serviceName: service['name']!,
//                             headerImage: service['image']!,
//                           ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 180,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     image: DecorationImage(
//                       image: AssetImage(service['image']!),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.black.withOpacity(0.5),
//                               Colors.transparent,
//                             ],
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 10,
//                         left: 10,
//                         child: Text(
//                           service['name']!,
//                           style: GoogleFonts.playfairDisplay(
//                             fontSize: 18,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }



// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// import 'service_vendor_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final List<String> sliderImages = [
//     "assets/images/hall.jpg",
//     "assets/images/decor.jpg",
//     "assets/images/catering.jpg",
//   ];

//   final List<Map<String, String>> services = [
//     {"name": "Wedding Hall", "image": "assets/images/hall.jpg"},
//     {"name": "Decorator", "image": "assets/images/decor.jpg"},
//     {"name": "Catering", "image": "assets/images/catering.jpg"},
//     {"name": "Pandit", "image": "assets/images/pandit.jpg"},
//     {"name": "DJ & Sound", "image": "assets/images/dj.jpg"},
//     {"name": "Salon", "image": "assets/images/saloon.jpg"},
//     {"name": "Transport", "image": "assets/images/trasport.jpg"},
//   ];

//   int _currentSlide = 0;
//   late PageController _pageController;
//   Timer? _timer;

//   List<dynamic> customPackages = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _startAutoSlide();
//     fetchCustomPackages();
//   }

//   void _startAutoSlide() {
//     _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
//       _currentSlide = (_currentSlide + 1) % sliderImages.length;
//       if (_pageController.hasClients) {
//         _pageController.animateToPage(
//           _currentSlide,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   Future<void> fetchCustomPackages() async {
//     try {
//       final response = await http.get(
//         Uri.parse("http://192.168.1.6:8000/api/showCustomPackage"),
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         setState(() {
//           customPackages = jsonData['data'];
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load custom packages');
//       }
//     } catch (e) {
//       print("Error fetching custom packages: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFDF7F2),
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             _buildSearchBar(),
//             const SizedBox(height: 16),
//             _buildImageSlider(),
//             const SizedBox(height: 24),
//             _buildAnimatedBanner(),
//             const SizedBox(height: 24),
//             _buildServiceSection(), // Premium Services first
//             const SizedBox(height: 24),
//             _buildCustomPackageSection(), // Custom packages after
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: const TextField(
//         decoration: InputDecoration(
//           icon: Icon(Icons.search, color: Colors.deepOrange),
//           hintText: "Search wedding services...",
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }

//   Widget _buildImageSlider() {
//     return Column(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: SizedBox(
//             height: 180,
//             child: PageView.builder(
//               controller: _pageController,
//               itemCount: sliderImages.length,
//               onPageChanged: (index) => setState(() => _currentSlide = index),
//               itemBuilder: (context, index) {
//                 return Image.asset(
//                   sliderImages[index],
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 );
//               },
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(sliderImages.length, (index) {
//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               width: _currentSlide == index ? 16 : 8,
//               height: 8,
//               decoration: BoxDecoration(
//                 color:
//                     _currentSlide == index
//                         ? Colors.deepOrange
//                         : Colors.grey[400],
//                 borderRadius: BorderRadius.circular(4),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   Widget _buildAnimatedBanner() {
//     return TweenAnimationBuilder<double>(
//       duration: const Duration(seconds: 1),
//       tween: Tween(begin: 0, end: 1),
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(0, (1 - value) * 20),
//             child: Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFFFEECE9), Color(0xFFFFD6C8)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   "Plan Your Dream Wedding\nwith Marry Mate",
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.playfairDisplay(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                     color: const Color.fromARGB(255, 12, 12, 12),
//                     height: 1.4,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildServiceSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Our Premium Services",
//           style: GoogleFonts.playfairDisplay(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           height: 230,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: services.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 16),
//             itemBuilder: (context, index) {
//               final service = services[index];
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (_) => ServiceVendorPage(
//                             serviceName: service['name']!,
//                             headerImage: service['image']!,
//                           ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 180,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     image: DecorationImage(
//                       image: AssetImage(service['image']!),
//                       fit: BoxFit.cover,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.4),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.black.withOpacity(0.5),
//                               Colors.transparent,
//                             ],
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 10,
//                         left: 12,
//                         child: Text(
//                           service['name']!,
//                           style: GoogleFonts.roboto(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCustomPackageSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Oue Custom Packages",
//           style: GoogleFonts.playfairDisplay(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//         isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SizedBox(
//               height: 230,
//               child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: customPackages.length,
//                 separatorBuilder: (_, __) => const SizedBox(width: 16),
//                 itemBuilder: (context, index) {
//                   final package = customPackages[index];
//                   return Container(
//                     width: 180,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       image: const DecorationImage(
//                         image: AssetImage(
//                           "assets/images/custompackageimage.jpg",
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.4),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             gradient: LinearGradient(
//                               colors: [
//                                 Colors.black.withOpacity(0.5),
//                                 Colors.transparent,
//                               ],
//                               begin: Alignment.bottomCenter,
//                               end: Alignment.topCenter,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 10,
//                           left: 12,
//                           child: Text(
//                             package['package_name'] ?? '',
//                             style: GoogleFonts.roboto(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../screens/custom_package_detail_page.dart';

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
    {"name": "DJ & Sound", "image": "assets/images/dj.jpg"},
    {"name": "Salon", "image": "assets/images/saloon.jpg"},
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
        Uri.parse("http://192.168.1.6:8000/api/showCustomPackage"),
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
            _buildImageSlider(),
            const SizedBox(height: 24),
            _buildServiceSection(),
            const SizedBox(height: 24),
            _buildCustomPackageSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 180,
        child: PageView.builder(
          controller: _pageController,
          itemCount: sliderImages.length,
          itemBuilder: (context, index) {
            return Image.asset(sliderImages[index], fit: BoxFit.cover);
          },
        ),
      ),
    );
  }

  Widget _buildServiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Our Premium Services", style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(service['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      service['name']!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
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
        Text("Our Custom Packages", style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold)),
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
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomPackageDetailPage(packageId: package['ap_id']),
                          ),
                        );
                      },
                      child: Container(
                        width: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/custompackageimage.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              package['package_name'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
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

