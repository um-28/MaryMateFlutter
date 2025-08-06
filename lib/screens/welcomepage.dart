// import 'package:flutter/material.dart';
// import '../routes/app_routes.dart';

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});

//   void _navigateToHome(BuildContext context) {
//     Navigator.pushReplacementNamed(context, AppRoutes.home);
//   }

//   void _navigateToClientRegister(BuildContext context) {
//     Navigator.pushNamed(context, AppRoutes.register);
//   }

//   void _navigateToBusinessRegister(BuildContext context) {
//     Navigator.pushNamed(context, AppRoutes.businessRegister);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey registerKey = GlobalKey(); // Key for Register button

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 30),

//                 // Logo
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
//                   style: TextStyle(fontSize: 16, color: Colors.black54),
//                 ),

//                 const SizedBox(height: 40),

//                 Row(
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
//                       child: Material(
//                         key: registerKey, // key set here
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(14),
//                         elevation: 5,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(14),
//                           onTap: () async {
//                             final RenderBox renderBox =
//                                 registerKey.currentContext!.findRenderObject()
//                                     as RenderBox;
//                             final Offset offset = renderBox.localToGlobal(
//                               Offset.zero,
//                             );
//                             final Size size = renderBox.size;

//                             final result = await showMenu<String>(
//                               context: context,
//                               position: RelativeRect.fromLTRB(
//                                 offset.dx,
//                                 offset.dy +
//                                     size.height +
//                                     5, // Drop below button
//                                 offset.dx + size.width,
//                                 offset.dy + size.height,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               color: Colors.white,
//                               items: const [
//                                 PopupMenuItem(
//                                   value: 'client',
//                                   child: Text("Client Registration"),
//                                 ),
//                                 PopupMenuItem(
//                                   value: 'business',
//                                   child: Text("Business Registration"),
//                                 ),
//                               ],
//                             );

//                             if (result == 'client') {
//                               _navigateToClientRegister(context);
//                             } else if (result == 'business') {
//                               _navigateToBusinessRegister(context);
//                             }
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             alignment: Alignment.center,
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Register",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 SizedBox(width: 8),
//                                 Icon(
//                                   Icons.arrow_drop_down,
//                                   color: Colors.white,
//                                 ),
//                               ],
//                             ),
//                           ),
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
    Navigator.pushNamed(context, AppRoutes.register);
  }

  void _navigateToBusinessRegister(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.businessRegister);
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
              children: [
                const SizedBox(height: 30),

                // Logo
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
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 40),

                // Row with Client & Business Sign Up
                Row(
                  children: [
                    // Client Sign Up
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _navigateToClientRegister(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Customer Sign Up",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Business Sign Up
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _navigateToBusinessRegister(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Business Sign Up",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Get Started Button - Smaller width, centered
                Center(
                  child: SizedBox(
                    width: 200, // smaller width
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
