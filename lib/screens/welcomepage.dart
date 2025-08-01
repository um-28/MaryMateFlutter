// import 'package:flutter/material.dart';
// import '../routes/app_routes.dart';

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});

//   void _navigateToHome(BuildContext context) {
//     Navigator.pushReplacementNamed(context, AppRoutes.home);
//   }

//   void _navigateToRegister(BuildContext context) {
//     Navigator.pushNamed(context, AppRoutes.register);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Rounded Image Logo
//                 Container(
//                   height: 250,
//                   width: 250,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 20,
//                         offset: Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: ClipOval(
//                     child: Image.asset(
//                       'assets/images/marrymate.png',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 const Text(
//                   "Welcome to Marry Mate",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 const Text(
//                   "Your one-stop solution for everything wedding. Let’s make it magical!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black54,
//                   ),
//                 ),

//                 const SizedBox(height: 40),


//                 // Buttons in a Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Get Started Button
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => _navigateToHome(context),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           elevation: 5,
//                         ),
//                         child: const Text(
//                           "Get Started",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),

//                     // Register Button
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => _navigateToRegister(context),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           elevation: 5,
//                         ),
//                         child: const Text(
//                           "Register",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _navigateToClientRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.register); // Client register route
  }

  void _navigateToBusinessRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.businessRegister); // You must define this route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rounded Image Logo
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/marrymate.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Welcome to Marry Mate",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Your one-stop solution for everything wedding. Let’s make it magical!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 40),

                // Buttons in a Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Get Started Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _navigateToHome(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Register Dropdown Button
                    Expanded(
                      child: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'client') {
                            _navigateToClientRegister(context);
                          } else if (value == 'business') {
                            _navigateToBusinessRegister(context);
                          }
                        },
                        offset: const Offset(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'client',
                            child: Text("Client Registration"),
                          ),
                          const PopupMenuItem(
                            value: 'business',
                            child: Text("Business Registration"),
                          ),
                        ],
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 5,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
