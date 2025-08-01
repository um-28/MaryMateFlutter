// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../routes/app_routes.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _logoScale;
//   late Animation<double> _logoFade;
//   late Animation<double> _textFade;
//   late Animation<double> _subtitleFade;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 4),
//       vsync: this,
//     );

//     _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
//       ),
//     );

//     _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
//       ),
//     );

//     _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.45, 0.75, curve: Curves.easeIn),
//       ),
//     );

//     _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
//       ),
//     );

//     _controller.forward();

//     Timer(const Duration(seconds: 7), () {
//       Navigator.pushReplacementNamed(context, AppRoutes.welcome);
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Clean white background
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo with scale + fade
//               ScaleTransition(
//                 scale: _logoScale,
//                 child: FadeTransition(
//                   opacity: _logoFade,
//                   child: Container(
//                     width: 160,
//                     height: 160,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 24,
//                           offset: Offset(0, 10),
//                         ),
//                       ],
//                       border: Border.all(color: Colors.black12, width: 2),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: ClipOval(
//                         child: Image.asset(
//                           'assets/images/marrymate.png',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 40),

//               // Title
//               FadeTransition(
//                 opacity: _textFade,
//                 child: const Text(
//                   'MarryMate',
//                   style: TextStyle(
//                     fontSize: 46,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     letterSpacing: 2.0,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // Subtitle
//               FadeTransition(
//                 opacity: _subtitleFade,
//                 child: const Text(
//                   'Your Wedding Partner',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontStyle: FontStyle.italic,
//                     color: Colors.black54,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../routes/app_routes.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _logoScale;
//   late Animation<double> _logoFade;
//   late Animation<double> _textFade;
//   late Animation<double> _subtitleFade;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 4),
//       vsync: this,
//     );

//     _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
//       ),
//     );

//     _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
//       ),
//     );

//     _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.45, 0.75, curve: Curves.easeIn),
//       ),
//     );

//     _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
//       ),
//     );

//     _controller.forward();

//     // After 7 seconds, check login status and navigate accordingly
//     Timer(const Duration(seconds: 7), () async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//       String? role = prefs.getString('user_role');

//       // Debug prints
//       print('isLoggedIn: $isLoggedIn');
//       print('user_role: $role');

//       if (isLoggedIn && role == 'C') {
//         Navigator.pushReplacementNamed(context, AppRoutes.home);
//       } else {
//         Navigator.pushReplacementNamed(context, AppRoutes.welcome);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo animation
//               ScaleTransition(
//                 scale: _logoScale,
//                 child: FadeTransition(
//                   opacity: _logoFade,
//                   child: Container(
//                     width: 160,
//                     height: 160,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 24,
//                           offset: Offset(0, 10),
//                         ),
//                       ],
//                       border: Border.all(color: Colors.black12, width: 2),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: ClipOval(
//                         child: Image.asset(
//                           'assets/images/marrymate.png',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//               // App Title
//               FadeTransition(
//                 opacity: _textFade,
//                 child: const Text(
//                   'MarryMate',
//                   style: TextStyle(
//                     fontSize: 46,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                     letterSpacing: 2.0,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Subtitle
//               FadeTransition(
//                 opacity: _subtitleFade,
//                 child: const Text(
//                   'Your Wedding Partner',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontStyle: FontStyle.italic,
//                     color: Colors.black54,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<double> _subtitleFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.75, curve: Curves.easeIn),
      ),
    );

    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // After 7 seconds, check login status and navigate accordingly
    Timer(const Duration(seconds: 7), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      String? role = prefs.getString('user_role');

      print('isLoggedIn: $isLoggedIn');
      print('user_role: $role');

      if (isLoggedIn && role == 'C') {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else if (isLoggedIn && role == 'V') {
        Navigator.pushReplacementNamed(context, AppRoutes.vendorPanel);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _logoScale,
                child: FadeTransition(
                  opacity: _logoFade,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 24,
                          offset: Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: Colors.black12, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/marrymate.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _textFade,
                child: const Text(
                  'MarryMate',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _subtitleFade,
                child: const Text(
                  'Your Wedding Partner',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
