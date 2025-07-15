import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  String selectedCategory = 'All Services';

  final List<Map<String, String>> services = [
    {'title': 'Wedding Hall', 'image': 'assets/images/hall.jpg'},
    {'title': 'Decorator', 'image': 'assets/images/decor.jpg'},
    {'title': 'Catering', 'image': 'assets/images/catering.jpg'},
    {'title': 'Pandit', 'image': 'assets/images/pandit.jpg'},
    {'title': 'DJ & Sound System', 'image': 'assets/images/Dj.jpg'},
    {'title': 'Salon', 'image': 'assets/images/saloon.jpg'},
    {'title': 'Transportation', 'image': 'assets/images/trasport.jpg'},
  ];

  final List<String> serviceCategories = [
    'All Services',
    'Wedding Hall',
    'DJ & Sound System',
    'Salon',
    'Transportation',
    'Decorator',
    'Catering',
    'Pandit',
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredServices = selectedCategory == 'All Services'
        ? services
        : services.where((service) {
            return service['title']!.toLowerCase().contains(
                  selectedCategory.toLowerCase(),
                );
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Services',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              // child: Text(
              //   "Our Services",
              //   style: GoogleFonts.playfairDisplay(
              //     fontSize: 28,
              //     fontWeight: FontWeight.w700,
              //     color: Colors.black87,
              //     letterSpacing: 1.2,
              //     shadows: [
              //       Shadow(
              //         color: Colors.grey.shade300,
              //         offset: const Offset(2, 2),
              //         blurRadius: 4,
              //       ),
              //     ],
              //   ),
              // ),
            ),
            const SizedBox(height: 16),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: serviceCategories.map((category) {
                  final isSelected = category == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF1D4350),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      selectedColor: const Color.fromARGB(255, 18, 7, 6),
                      backgroundColor: Colors.grey[100],
                      side: BorderSide(
                        color: isSelected ? const Color.fromARGB(255, 14, 8, 8) : Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: isSelected ? 6 : 2,
                      pressElevation: 4,
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Service Grid
            Expanded(
              child: filteredServices.isEmpty
                  ? const Center(
                      child: Text(
                        "No services found in this category.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                      children: filteredServices.map((service) {
                        return GestureDetector(
                          onTap: () {
                            print("Tapped on: ${service['title']}");
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    service['image']!,
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.6),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    left: 12,
                                    right: 12,
                                    child: Text(
                                      service['title']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black45,
                                            offset: Offset(1, 1),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
