import 'package:flutter/material.dart';
import '../screens/SplashScreen.dart';
import '../screens/welcomepage.dart';
// import '../screens/HomePage.dart';
import '../screens/weddinghallpage.dart';
// import '../screens/service_vendor_page.dart';
import '../screens/cateringpage.dart';
import '../screens/servicedetailpage.dart';
import '../screens/bookingpage.dart';
import '../screens/bottomnavpage.dart';
import '../screens/registerpage.dart';
import '../screens/loginpage.dart';
// import '../screens/vendor_service_page.dart';
import '../screens/add_cart_page.dart';
import '../screens/EditProfilePage.dart';
// import '../screens/custom_package_detail_page.dart';
import '../vendor/business_register_page.dart';
import '../vendor/vendor_panel_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String bottomNav = '/bottomnav';
  static const String weddingHall = '/wedding-hall';
  static const String decorator = '/decorator';
  static const String catering = '/catering';
  static const String serviceDetail = '/service-detail';
  static const String booking = '/booking';
  static const String sercies = '/vendor-services';
  static const String addcart = '/addcart';
  static const String customPackageDetail = '/custom-package-detail';
  static const String editProfile = '/edit-profile';

  static const String businessRegister = 'business-register';
  static const String vendorPanel = '/vendorplanne';

  static final routes = <String, WidgetBuilder>{
    splash: (context) => const SplashScreen(),
    welcome: (context) => const WelcomePage(),
    home: (context) => const BottomNavPage(), //use BottomNavPage here
    weddingHall: (context) => const WeddingHallPage(),
    // decorator: (context) => const DecoratorPage(),
    // vendorservices: (context) => const vendorservicepage(),
    catering: (context) => const CateringPage(),
    serviceDetail: (context) => const ServiceDetailPage(),
    booking: (context) => const BookingPage(),
    bottomNav: (context) => const BottomNavPage(),
    register: (context) => const RegisterPage(),
    login: (context) => const LoginPage(),
    addcart: (context) => const AddCartPage(),
    editProfile: (context) => const EditProfilePage(),
    businessRegister: (context) => const BusinessRegisterPage(),

    vendorPanel: (context) => const VendorPanelPage(),

    // customPackageDetail: (context) => const CustomPackageDetailPage(packageId: 0),
  };
}
