
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// import '../screens/custom_package_detail_page.dart';
// import '../screens/service_vendor_page.dart';
// import '../config/api_config.dart';

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

//   int _currentSlide = 0;
//   late PageController _pageController;
//   Timer? _timer;

//   List<dynamic> customPackages = [];
//   bool isLoadingPackages = true;

//   final TextEditingController _searchController = TextEditingController();
//   List<dynamic> searchedVendors = [];
//   bool isLoadingSearch = false;
//   bool hasSearched = false;

//   List<dynamic> categories = [];
//   bool isLoadingCategories = true;
//   bool hasFetched = false;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _startAutoSlide();
//     fetchCustomPackages();
//     fetchCategories();
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
//         Uri.parse("${ApiConfig.baseUrl}/api/showCustomPackage"),
//       );
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         setState(() {
//           customPackages = jsonData['data'];
//           isLoadingPackages = false;
//         });
//       } else {
//         throw Exception('Failed to load custom packages');
//       }
//     } catch (e) {
//       print("Error fetching custom packages: $e");
//       setState(() {
//         isLoadingPackages = false;
//       });
//     }
//   }

//   Future<void> fetchCategories() async {
//     if (hasFetched) return;
//     hasFetched = true;

//     setState(() {
//       isLoadingCategories = true;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse("${ApiConfig.baseUrl}/api/CategoryView"),
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         setState(() {
//           categories = jsonData['data'] ?? [];
//           isLoadingCategories = false;
//         });
//       } else {
//         throw Exception('Failed to load categories');
//       }
//     } catch (e) {
//       print("Error fetching categories: $e");
//       setState(() {
//         isLoadingCategories = false;
//       });
//     }
//   }

//   // ✅ Search vendors
//   Future<void> searchVendors() async {
//     final keyword = _searchController.text.trim();
//     if (keyword.isEmpty) {
//       setState(() {
//         searchedVendors = [];
//         hasSearched = false;
//       });
//       return;
//     }

//     setState(() {
//       isLoadingSearch = true;
//       hasSearched = true;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse("${ApiConfig.baseUrl}/api/search?keyword=$keyword"),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         setState(() {
//           searchedVendors = jsonData['vendors'] ?? [];
//         });
//       } else {
//         setState(() {
//           searchedVendors = [];
//         });
//       }
//     } catch (e) {
//       print("Error during search: $e");
//       setState(() {
//         searchedVendors = [];
//       });
//     } finally {
//       setState(() {
//         isLoadingSearch = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _timer?.cancel();
//     _searchController.dispose();
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
//             if (hasSearched) const SizedBox(height: 24),
//             if (hasSearched) _buildSearchResults(),
//             const SizedBox(height: 24),
//             _buildPremiumServicesGrid(),
//             const SizedBox(height: 24),
//             _buildCustomPackagesGrid(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(14),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade300,
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 icon: Icon(Icons.search, color: Colors.deepOrange),
//                 hintText: "Search services...",
//                 border: InputBorder.none,
//               ),
//               onSubmitted: (_) => searchVendors(),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepOrange,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//           ),
//           onPressed: searchVendors,
//           child: const Text("Search", style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }

//   /// ✅ Search Results
//   Widget _buildSearchResults() {
//     if (isLoadingSearch) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (searchedVendors.isEmpty) {
//       return const Center(
//         child: Text(
//           "No vendors found.",
//           style: TextStyle(fontSize: 16, color: Colors.black54),
//         ),
//       );
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Search Results",
//           style: GoogleFonts.playfairDisplay(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: searchedVendors.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 0.85,
//           ),
//           itemBuilder: (context, index) {
//             final vendor = searchedVendors[index];
//             final businessName = vendor['business_name'] ?? 'No Name';
//             final businessType = vendor['business_type'] ?? 'Service';

            

//             final imageUrl =
//                 (vendor['image'] != null &&
//                         vendor['image'].toString().isNotEmpty)
//                     ? vendor['image']
//                         as String // URL from Laravel API (/api/image/xyz)
//                     : "assets/images/custompackageimage.jpg";

//             return _buildCard(
//               title: businessName,
//               image: imageUrl,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder:
//                         (_) => ServiceVendorPage(
//                           serviceName: businessType,
//                           headerImage:
//                               imageUrl.startsWith('http')
//                                   ? imageUrl
//                                   : "assets/images/custompackageimage.jpg",
//                           vendor: vendor,
//                         ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ],
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
//             child: child,
//           ),
//         );
//       },
//       child: Container(),
//     );
//   }

//   Widget _buildPremiumServicesGrid() {
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
//         if (isLoadingCategories)
//           const Center(child: CircularProgressIndicator())
//         else if (categories.isEmpty)
//           const Text("No categories available.")
//         else
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: categories.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 0.85,
//             ),
//             itemBuilder: (context, index) {
//               final category = categories[index];
//               final imageStr =
//                   (category['image'] is String)
//                       ? category['image'] as String
//                       : "";
//               return _buildCard(
//                 title: category['name'] ?? "Service",
//                 image:
//                     imageStr.isNotEmpty
//                         ? imageStr
//                         : "assets/images/marrymate.png",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (_) => ServiceVendorPage(
//                             serviceName: category['name'] ?? "Service",
//                             headerImage:
//                                 imageStr.isNotEmpty &&
//                                         imageStr.startsWith('http')
//                                     ? imageStr
//                                     : "assets/images/marrymate.png",
//                             vendor: null,
//                           ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//       ],
//     );
//   }

//   Widget _buildCustomPackagesGrid() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Our Custom Packages",
//           style: GoogleFonts.playfairDisplay(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
//         if (isLoadingPackages)
//           const Center(child: CircularProgressIndicator())
//         else if (customPackages.isEmpty)
//           const Text("No packages available.")
//         else
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: customPackages.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 0.85,
//             ),
//             itemBuilder: (context, index) {
//               final package = customPackages[index];
//               return _buildCard(
//                 title: package['package_name'] ?? "Package",
//                 image: "assets/images/custompackageimage.jpg",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (_) => CustomPackageDetailPage(
//                             packageId: package['ap_id'],
//                             packageData: package,
//                           ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//       ],
//     );
//   }

//   /// ✅ Universal Card Widget
//   Widget _buildCard({
//     required String title,
//     required String image,
//     required VoidCallback onTap,
//   }) {
//     final isNetwork = image.startsWith('http');
//     return GestureDetector(
//       onTap: onTap,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child:
//                   isNetwork
//                       ? Image.network(
//                         image,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Image.asset(
//                             "assets/images/custompackageimage.jpg",
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       )
//                       : Image.asset(image, fit: BoxFit.cover),
//             ),
//             Positioned.fill(
//               child: Container(color: Colors.black.withOpacity(0.35)),
//             ),
//             Positioned(
//               bottom: 12,
//               left: 12,
//               right: 12,
//               child: Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.roboto(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Colors.white,
//                   shadows: const [
//                     Shadow(
//                       color: Colors.black54,
//                       blurRadius: 6,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../screens/custom_package_detail_page.dart';
import '../screens/service_vendor_page.dart';
import '../config/api_config.dart';

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

  int _currentSlide = 0;
  late PageController _pageController;
  Timer? _timer;

  List<dynamic> customPackages = [];
  bool isLoadingPackages = true;

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchedVendors = [];
  bool isLoadingSearch = false;
  bool hasSearched = false;

  List<dynamic> categories = [];
  bool isLoadingCategories = true;
  bool hasFetched = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
    fetchCustomPackages();
    fetchCategories();
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
        Uri.parse("${ApiConfig.baseUrl}/api/showCustomPackage"),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          customPackages = jsonData['data'];
          isLoadingPackages = false;
        });
      } else {
        throw Exception('Failed to load custom packages');
      }
    } catch (e) {
      print("Error fetching custom packages: $e");
      setState(() {
        isLoadingPackages = false;
      });
    }
  }

  Future<void> fetchCategories() async {
    if (hasFetched) return;
    hasFetched = true;

    setState(() {
      isLoadingCategories = true;
    });

    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/CategoryView"),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          categories = jsonData['data'] ?? [];
          isLoadingCategories = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() {
        isLoadingCategories = false;
      });
    }
  }

  Future<void> searchVendors() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) {
      setState(() {
        searchedVendors = [];
        hasSearched = false;
      });
      return;
    }

    setState(() {
      isLoadingSearch = true;
      hasSearched = true;
    });

    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/api/search?keyword=$keyword"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          searchedVendors = jsonData['vendors'] ?? [];
        });
      } else {
        setState(() {
          searchedVendors = [];
        });
      }
    } catch (e) {
      print("Error during search: $e");
      setState(() {
        searchedVendors = [];
      });
    } finally {
      setState(() {
        isLoadingSearch = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    _searchController.dispose();
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
            if (hasSearched) const SizedBox(height: 24),
            if (hasSearched) _buildSearchResults(),
            const SizedBox(height: 24),
            _buildPremiumServicesGrid(),
            const SizedBox(height: 24),
            _buildCustomPackagesGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
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
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.deepOrange),
                hintText: "Search services...",
                border: InputBorder.none,
              ),
              onSubmitted: (_) => searchVendors(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: searchVendors,
          child: const Text("Search", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (isLoadingSearch) {
      return const Center(child: CircularProgressIndicator());
    }
    if (searchedVendors.isEmpty) {
      return const Center(
        child: Text(
          "No vendors found.",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search Results",
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: searchedVendors.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final vendor = searchedVendors[index];
            final businessName = vendor['business_name'] ?? 'No Name';
            final businessType = vendor['business_type'] ?? 'Service';
            final imageUrl =
                (vendor['image'] != null && vendor['image'].toString().isNotEmpty)
                    ? vendor['image'] as String
                    : "assets/images/custompackageimage.jpg";

            return _buildCard(
              title: businessName,
              image: imageUrl,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceVendorPage(
                      serviceName: businessType,
                      headerImage: imageUrl.startsWith('http')
                          ? imageUrl
                          : "assets/images/custompackageimage.jpg",
                      vendor: vendor,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
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
                color: _currentSlide == index
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
            child: child,
          ),
        );
      },
      child: Container(),
    );
  }

  Widget _buildPremiumServicesGrid() {
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
        if (isLoadingCategories)
          const Center(child: CircularProgressIndicator())
        else if (categories.isEmpty)
          const Text("No categories available.")
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              final imageStr =
                  (category['image'] is String) ? category['image'] as String : "";
              return _buildCard(
                title: category['name'] ?? "Service",
                image: imageStr.isNotEmpty
                    ? imageStr
                    : "assets/images/marrymate.png",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceVendorPage(
                        serviceName: category['name'] ?? "Service",
                        headerImage: imageStr.isNotEmpty && imageStr.startsWith('http')
                            ? imageStr
                            : "assets/images/marrymate.png",
                        vendor: null,
                      ),
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildCustomPackagesGrid() {
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
        if (isLoadingPackages)
          const Center(child: CircularProgressIndicator())
        else if (customPackages.isEmpty)
          const Text("No packages available.")
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customPackages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final package = customPackages[index];
              final packageName = package['package_name'] ?? "Package";

              // 🔥 अब name + image header me dynamic bheja jayega
              return _buildCard(
                title: packageName,
                image: "assets/images/custompackageimage.jpg",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomPackageDetailPage(
                        packageId: package['ap_id'],
                        packageData: package,
                        packageName: packageName, // ✅ dynamic name pass
                        headerImage: "assets/images/custompackageimage.jpg", // ✅ dynamic image pass
                      ),
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String image,
    required VoidCallback onTap,
  }) {
    final isNetwork = image.startsWith('http');
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: isNetwork
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/custompackageimage.jpg",
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(image, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.35)),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

