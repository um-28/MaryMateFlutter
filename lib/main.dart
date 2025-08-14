// import 'package:flutter/material.dart';
// import 'routes/app_routes.dart';
// import '../vendor/ResetpasswordPage.dart';

// void main() {
//   runApp(const MarryMateApp());
// }

// class MarryMateApp extends StatelessWidget {
//   const MarryMateApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Marry Mate',
//       debugShowCheckedModeBanner: false,
//       initialRoute: AppRoutes.splash,
//       routes: AppRoutes.routes,

//       onGenerateInitialRoutes: (String initialRouteName) {
//         // check if initialRouteName is a reset password link
//         Uri uri = Uri.parse(initialRouteName);
//         if (uri.path == '/reset-password') {
//           final token = uri.queryParameters['token'] ?? '';
//           return [
//             MaterialPageRoute(builder: (_) => ResetPasswordPage(token: token)),
//           ];
//         }
//         // fallback to normal splash
//         return [
//           MaterialPageRoute(
//             builder: (_) => AppRoutes.routes[AppRoutes.splash]!(context),
//           ),
//         ];
//       },
//       onGenerateRoute: (settings) {
//         Uri uri = Uri.parse(settings.name ?? '');
//         if (uri.path == '/reset-password') {
//           final token = uri.queryParameters['token'] ?? '';
//           return MaterialPageRoute(
//             builder: (_) => ResetPasswordPage(token: token),
//           );
//         }
//         return null; // fallback
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'routes/app_routes.dart';
// import '../vendor/ResetpasswordPage.dart';

// void main() {
//   runApp(const MarryMateApp());
// }

// class MarryMateApp extends StatelessWidget {
//   const MarryMateApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Marry Mate',
//       debugShowCheckedModeBanner: false,

//       routes: AppRoutes.routes,
//       // This handles deep links / reset-password
//       onGenerateRoute: (settings) {
//         Uri uri = Uri.parse(settings.name ?? '');

//         if (uri.path == AppRoutes.resetPassword) {
//           final token = uri.queryParameters['token'] ?? '';
//           return MaterialPageRoute(
//             builder: (_) => ResetPasswordPage(token: token),
//           );
//         }

//         if (AppRoutes.routes.containsKey(settings.name)) {
//           return MaterialPageRoute(
//             builder: AppRoutes.routes[settings.name]!,
//             settings: settings,
//           );
//         }

//         return MaterialPageRoute(
//           builder:
//               (_) => Scaffold(
//                 body: Center(child: Text('Page not found: ${settings.name}')),
//               ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import '../vendor/ResetpasswordPage.dart';
import '../screens/SplashScreen.dart'; 

void main() {
  runApp(const MarryMateApp());
}

class MarryMateApp extends StatelessWidget {
  const MarryMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect current URL path (Flutter Web)
    final String initialPath = Uri.base.path; // example: /reset-password
    Widget homeWidget;

    if (initialPath == AppRoutes.resetPassword) {
      // If the URL has /reset-password, open ResetPasswordPage
      final token = Uri.base.queryParameters['token'] ?? '';
      homeWidget = ResetPasswordPage(token: token);
    } else {
      // Otherwise, show normal SplashScreen
      homeWidget = const SplashScreen();
    }

    return MaterialApp(
      title: 'Marry Mate',
      debugShowCheckedModeBanner: false,
      home: homeWidget, // dynamic initial page
      routes: {
        // Removed '/' route to avoid conflict with 'home'

        // Add more routes as needed
      },
      onGenerateRoute: (settings) {
        Uri uri = Uri.parse(settings.name ?? '');

        // Handle reset-password navigation inside app
        if (uri.path == AppRoutes.resetPassword) {
          final token = uri.queryParameters['token'] ?? '';
          return MaterialPageRoute(
            builder: (_) => ResetPasswordPage(token: token),
          );
        }

        // Normal app routes fallback
        if (AppRoutes.routes.containsKey(settings.name)) {
          return MaterialPageRoute(
            builder: AppRoutes.routes[settings.name]!,
            settings: settings,
          );
        }

        // Unknown route fallback
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(child: Text('Page not found: ${settings.name}')),
              ),
        );
      },
    );
  }
}
