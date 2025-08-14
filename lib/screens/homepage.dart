// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// import '../screens/custom_package_detail_page.dart';
// import '../screens/service_vendor_page.dart';

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
//         Uri.parse("http://192.168.1.4:8000/api/showCustomPackage"),
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
//             _buildServiceSection(), // ✅ Fixed: Services section
//             const SizedBox(height: 24),
//             _buildCustomPackageSection(), // ✅ Custom packages section
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
//                         // ignore: deprecated_member_use
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
//                               // ignore: deprecated_member_use
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
//           "Our Custom Packages",
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
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (_) =>
//                               // CustomPackageDetailPage(packageData: package),
//                               CustomPackageDetailPage(
//                                 packageId:
//                                     package['ap_id'], // make sure this matches your backend key
//                                 packageData: package,
//                               ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: 180,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         image: const DecorationImage(
//                           image: AssetImage(
//                             "assets/images/custompackageimage.jpg",
//                           ),
//                           fit: BoxFit.cover,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             // ignore: deprecated_member_use
//                             color: Colors.grey.withOpacity(0.4),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Stack(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               gradient: LinearGradient(
//                                 colors: [
//                                   // ignore: deprecated_member_use
//                                   Colors.black.withOpacity(0.5),
//                                   Colors.transparent,
//                                 ],
//                                 begin: Alignment.bottomCenter,
//                                 end: Alignment.topCenter,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 10,
//                             left: 12,
//                             child: Text(
//                               package['package_name'] ?? '',
//                               style: GoogleFonts.roboto(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//       ],
//     );
//   }
// }

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// import '../screens/custom_package_detail_page.dart';
// import '../screens/service_vendor_page.dart';

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

//   // Dynamic categories
//   List<dynamic> categories = [];
//   bool isLoadingCategories = true;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _startAutoSlide();
//     fetchCustomPackages();
//     fetchCategories(); // fetch dynamic categories
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
//         Uri.parse("http://192.168.1.4:8000/api/showCustomPackage"),
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
//     try {
//       final response = await http.get(
//         Uri.parse("http://192.168.1.4:8000/api/CategoryView"),
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
//         Uri.parse("http://192.168.1.4:8000/api/search?keyword=$keyword"),
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         setState(() {
//           searchedVendors = jsonData['vendors'] ?? [];
//         });
//       } else {
//         print("Search API error: ${response.statusCode}");
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
//             if (hasSearched) const SizedBox(height: 16),
//             if (hasSearched) _buildSearchResults(),
//             const SizedBox(height: 16),
//             _buildImageSlider(),
//             const SizedBox(height: 24),
//             _buildAnimatedBanner(),
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
//           child: const Text("Search"),
//         ),
//       ],
//     );
//   }

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

//     return SizedBox(
//       height: 250,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: searchedVendors.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (context, index) {
//           final vendor = searchedVendors[index];
//           final businessType = vendor['business_type'] ?? '';
//           final vendorName =
//               vendor['user'] != null
//                   ? vendor['user']['name'] ?? 'No Name'
//                   : 'No Name';
//           final vendorImage =
//               vendor['user'] != null
//                   ? (vendor['user']['profile_image'] ??
//                       'assets/images/default_vendor.jpg')
//                   : 'assets/images/default_vendor.jpg';

//           // Get category name dynamically
//           final category = categories.firstWhere(
//             (c) => c['category_id'].toString() == businessType.toString(),
//             orElse: () => {'name': businessType},
//           );

//           return Container(
//             width: 180,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   child:
//                       vendorImage.startsWith('http')
//                           ? Image.network(
//                             vendorImage,
//                             height: 120,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             errorBuilder:
//                                 (context, error, stackTrace) => Image.asset(
//                                   'assets/images/default_vendor.jpg',
//                                   height: 120,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                 ),
//                           )
//                           : Image.asset(
//                             vendorImage,
//                             height: 120,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   vendorName,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   category['name'] ?? businessType,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.deepOrange,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//               ],
//             ),
//           );
//         },
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
//           child: Transform.translate(offset: Offset(0, (1 - value) * 20)),
//         );
//       },
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
//               return _buildCard(
//                 title: category['name'] ?? "Service",
//                 image:
//                     category['image'] != null && category['image'] != ''
//                         ? category['image']
//                         : "assets/images/hall.jpg",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (_) => ServiceVendorPage(
//                             serviceName: category['name'] ?? "Service",
//                             headerImage:
//                                 category['image'] != null &&
//                                         category['image'] != ''
//                                     ? category['image']
//                                     : "assets/images/hall.jpg",
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

//   Widget _buildCard({
//     required String title,
//     required String image,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             ),
//           ],
//           image: DecorationImage(
//             image:
//                 image.startsWith('http')
//                     ? NetworkImage(image) as ImageProvider
//                     : AssetImage(image),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.35),
//               BlendMode.darken,
//             ),
//           ),
//         ),
//         child: Stack(
//           children: [
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

// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// import '../screens/custom_package_detail_page.dart';
// import '../screens/service_vendor_page.dart';

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
//         Uri.parse("http://192.168.1.4:8000/api/showCustomPackage"),
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
//     if (hasFetched) return; // ✅ Already fetched? Skip.
//     hasFetched = true;

//     setState(() {
//       isLoadingCategories = true;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse("http://192.168.1.4:8000/api/CategoryView"),
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
//         Uri.parse("http://192.168.1.4:8000/api/search?keyword=$keyword"),
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
//             if (hasSearched) const SizedBox(height: 16),
//             if (hasSearched) _buildSearchResults(),
//             const SizedBox(height: 16),
//             _buildImageSlider(),
//             const SizedBox(height: 24),
//             _buildAnimatedBanner(),
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
//           child: const Text("Search"),
//         ),
//       ],
//     );
//   }

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
//     return SizedBox(
//       height: 250,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: searchedVendors.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (context, index) {
//           final vendor = searchedVendors[index];
//           final businessType = vendor['business_type'] ?? '';
//           final vendorName = vendor['user']?['name'] ?? 'No Name';
//           final vendorImage =
//               vendor['user']?['profile_image'] ??
//               'assets/images/default_vendor.jpg';

//           final category = categories.firstWhere(
//             (c) => c['category_id'].toString() == businessType.toString(),
//             orElse: () => {'name': businessType},
//           );

//           return Container(
//             width: 180,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   child:
//                       vendorImage.startsWith('http')
//                           ? Image.network(
//                             vendorImage,
//                             height: 120,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             gaplessPlayback: true, // prevents flicker
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Container(
//                                 height: 120,
//                                 color: Colors.grey[200],
//                                 child: const Center(
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               );
//                             },
//                             errorBuilder:
//                                 (context, error, stackTrace) => Image.asset(
//                                   'assets/images/default_vendor.jpg',
//                                   height: 120,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                 ),
//                           )
//                           : Image.asset(
//                             vendorImage,
//                             height: 120,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   vendorName,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   category['name'] ?? businessType,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.deepOrange,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           );
//         },
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
//             child: child,
//           ),
//         );
//       },
//       child: Container(), // you can add your banner widget here
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
//               return _buildCard(
//                 title: category['name'] ?? "Service",
//                 image: category['image'] ?? "assets/images/hall.jpg",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (_) => ServiceVendorPage(
//                             serviceName: category['name'] ?? "Service",
//                             headerImage:
//                                 category['image'] ?? "assets/images/hall.jpg",
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

//   Widget _buildCard({
//     required String title,
//     required String image,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             ),
//           ],
//           image: DecorationImage(
//             image:
//                 image.startsWith('http')
//                     ? NetworkImage(image)
//                     : AssetImage(image) as ImageProvider,
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.35),
//               BlendMode.darken,
//             ),
//           ),
//         ),
//         child: Stack(
//           children: [
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
        Uri.parse("http://192.168.1.4:8000/api/showCustomPackage"),
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
        Uri.parse("http://192.168.1.4:8000/api/CategoryView"),
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
        Uri.parse("http://192.168.1.4:8000/api/search?keyword=$keyword"),
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
            if (hasSearched) const SizedBox(height: 16),
            if (hasSearched) _buildSearchResults(),
            const SizedBox(height: 16),
            _buildImageSlider(),
            const SizedBox(height: 24),
            _buildAnimatedBanner(),
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
          child: const Text("Search"),
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
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: searchedVendors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final vendor = searchedVendors[index];
          final businessType = vendor['business_type'] ?? '';
          final vendorName = vendor['user']?['name'] ?? 'No Name';
          final vendorImage = vendor['user']?['profile_image'] ?? '';

          final category = categories.firstWhere(
            (c) => c['category_id'].toString() == businessType.toString(),
            orElse: () => {'name': businessType},
          );

          return Container(
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child:
                      vendorImage.startsWith('http')
                          ? Image.network(
                            vendorImage,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 120,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder:
                                (context, error, stackTrace) => Image.asset(
                                  'assets/images/default_vendor.jpg',
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                          )
                          : Image.asset(
                            'assets/images/default_vendor.jpg',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                ),
                const SizedBox(height: 8),
                Text(
                  vendorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  category['name'] ?? businessType,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.deepOrange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
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
            child: child,
          ),
        );
      },
      child: Container(), // Placeholder for banner
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
              return _buildCard(
                title: category['name'] ?? "Service",
                image: category['image'] ?? "assets/images/hall.jpg",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ServiceVendorPage(
                            serviceName: category['name'] ?? "Service",
                            headerImage:
                                category['image'] ?? "assets/images/hall.jpg",
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
              return _buildCard(
                title: package['package_name'] ?? "Package",
                image: "assets/images/custompackageimage.jpg",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => CustomPackageDetailPage(
                            packageId: package['ap_id'],
                            packageData: package,
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
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child:
                  image.startsWith('http')
                      ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder:
                            (context, error, stackTrace) => Image.asset(
                              'assets/images/hall.jpg',
                              fit: BoxFit.cover,
                            ),
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
