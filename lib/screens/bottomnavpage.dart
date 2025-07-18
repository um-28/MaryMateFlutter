// import 'package:flutter/material.dart';
// import 'homepage.dart';
// import 'bookingpage.dart';
// import 'profilepage.dart';
// import 'add_cart_page.dart';

// class BottomNavPage extends StatefulWidget {
//   const BottomNavPage({super.key});

//   @override
//   State<BottomNavPage> createState() => _BottomNavPageState();
// }

// class _BottomNavPageState extends State<BottomNavPage> {
//   int _currentIndex = 0;

//   final List<IconData> _icons = [
//     Icons.home_rounded,
//     Icons.calendar_month_rounded,
//     Icons.shopping_cart_rounded,
//     Icons.account_circle_rounded,
//   ];

//   final List<String> _labels = ["Home", "Booking", "Cart", "Profile"];

//   @override
//   Widget build(BuildContext context) {
//     final pages = [
//       const HomePage(),
//       const BookingPage(),
//       const AddCartPage(), // Placeholder for CartPage
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
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 18,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: List.generate(_icons.length, (index) {
//             final isSelected = _currentIndex == index;

//             return GestureDetector(
//               onTap: () {

//                 if (index == 2) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AddCartPage(),
//                     ),
//                   );
//                 } else {
//                   setState(() => _currentIndex = index);
//                 }
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
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'bookingpage.dart';
import 'profilepage.dart';
import 'add_cart_page.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _currentIndex = 0;

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.shopping_cart_rounded,
    Icons.account_circle_rounded,
  ];

  final List<String> _labels = ["Home", "Booking", "Cart", "Profile"];

  @override
  Widget build(BuildContext context) {
    // AddCartPage gets a UniqueKey to rebuild when tab is selected
    final List<Widget> pages = [
      const HomePage(),
      const BookingPage(),
      AddCartPage(key: UniqueKey()), // forces rebuild on tab switch
      const ProfilePage(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 18,
              offset: Offset(0, 6),
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
    );
  }
}
