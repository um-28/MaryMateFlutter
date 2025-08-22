// import 'package:flutter/material.dart';
// import 'homepage.dart';
// import 'bookingpage.dart';
// import 'profilepage.dart';
// import 'add_cart_page.dart';

// class BottomNavPage extends StatefulWidget {
//   final int initialIndex; // Tab to open initially

//   const BottomNavPage({super.key, this.initialIndex = 0});

//   @override
//   State<BottomNavPage> createState() => _BottomNavPageState();
// }

// class _BottomNavPageState extends State<BottomNavPage> {
//   late int _currentIndex;

//   final List<IconData> _icons = [
//     Icons.home_rounded,
//     Icons.calendar_month_rounded,
//     Icons.shopping_cart_rounded,
//     Icons.account_circle_rounded,
//   ];

//   final List<String> _labels = ["Home", "Booking", "Cart", "Profile"];

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex; // Set initial tab
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Pages for each tab
//     final List<Widget> pages = [
//       const HomePage(),
//       const BookingPage(),
//       AddCartPage(key: UniqueKey()), // forces rebuild on tab switch
//       const ProfilePage(),
//     ];

//     return Scaffold(
//       extendBody: true,
//       body: IndexedStack(index: _currentIndex, children: pages),
//       bottomNavigationBar: Container(
//         margin: const EdgeInsets.all(16),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(22),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 18,
//               offset: Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: List.generate(_icons.length, (index) {
//             final isSelected = _currentIndex == index;

//             return GestureDetector(
//               onTap: () {
//                 setState(() => _currentIndex = index);
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.black : Colors.transparent,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       _icons[index],
//                       color: isSelected ? Colors.white : Colors.black54,
//                       size: 24,
//                     ),
//                     if (isSelected) ...[
//                       const SizedBox(width: 8),
//                       Text(
//                         _labels[index],
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'homepage.dart';
// import 'bookingpage.dart';
// import 'profilepage.dart';
// import 'add_cart_page.dart';

// class BottomNavPage extends StatefulWidget {
//   final int initialIndex; // Tab to open initially

//   const BottomNavPage({super.key, this.initialIndex = 0});

//   @override
//   State<BottomNavPage> createState() => _BottomNavPageState();
// }

// class _BottomNavPageState extends State<BottomNavPage> {
//   late int _currentIndex;

//   final List<IconData> _icons = [
//     Icons.home_rounded,
//     Icons.calendar_month_rounded,
//     Icons.shopping_cart_rounded,
//     Icons.account_circle_rounded,
//   ];

//   final List<String> _labels = ["Home", "Booking", "Cart", "Profile"];

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex; // Set initial tab
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double bottomNavHeight = 70; // Approx height of bottom nav

//     // Pages for each tab
//     final List<Widget> pages = [
//       const HomePage(),
//       const BookingPage(),
//       AddCartPage(key: UniqueKey()), // forces rebuild on tab switch
//       const ProfilePage(),
//     ];

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Pages fill the screen above the bottom nav
//           Padding(
//             padding: EdgeInsets.only(bottom: bottomNavHeight),
//             child: IndexedStack(index: _currentIndex, children: pages),
//           ),

//           // Fixed bottom navigation bar
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: bottomNavHeight,
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(22),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 18,
//                     offset: Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: List.generate(_icons.length, (index) {
//                   final isSelected = _currentIndex == index;

//                   return GestureDetector(
//                     onTap: () {
//                       setState(() => _currentIndex = index);
//                     },
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isSelected ? Colors.black : Colors.transparent,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             _icons[index],
//                             color: isSelected ? Colors.white : Colors.black54,
//                             size: 24,
//                           ),
//                           if (isSelected) ...[
//                             const SizedBox(width: 8),
//                             Text(
//                               _labels[index],
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'homepage.dart';
import 'bookingpage.dart';
import 'profilepage.dart';
import 'add_cart_page.dart';

class BottomNavPage extends StatefulWidget {
  final int initialIndex; // Tab to open initially

  const BottomNavPage({super.key, this.initialIndex = 0});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  late int _currentIndex;

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.shopping_cart_rounded,
    Icons.account_circle_rounded,
  ];

  final List<String> _labels = ["Home", "Booking", "Cart", "Profile"];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Set initial tab
  }

  @override
  Widget build(BuildContext context) {
    final double bottomNavHeight = 70; // Approx height of bottom nav

    // Pages for each tab
    final List<Widget> pages = [
      const HomePage(),
      const BookingPage(),
      AddCartPage(key: UniqueKey()), // forces rebuild on tab switch
      const ProfilePage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Pages fill the screen above the bottom nav
          Padding(
            padding: EdgeInsets.only(bottom: bottomNavHeight),
            child: IndexedStack(index: _currentIndex, children: pages),
          ),

          // Fixed bottom navigation bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: bottomNavHeight,
              // 🔥 margin hata diya (pehle yaha EdgeInsets.all(16) tha)
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  0,
                ), // corner chipakane ke liye
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 18,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_icons.length, (index) {
                  final isSelected = _currentIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _currentIndex = index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _icons[index],
                            color: isSelected ? Colors.white : Colors.black54,
                            size: 24,
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            Text(
                              _labels[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
