// class VendorService {
//   String serviceType;
//   String description;
//   double price;
//   List<String> images;
//   bool isAddedToCart;
//   DateTime? startDate;
//   DateTime? endDate;

//   VendorService({
//     required this.serviceType,
//     required this.description,
//     required this.price,
//     required this.images,
//     this.isAddedToCart = false,
//     this.startDate,
//     this.endDate,
//   });

//   factory VendorService.fromJson(Map<String, dynamic> json) {
//     return VendorService(
//       // vendorId: json['vendor_id'],
//       serviceType: json['service_type'],
//       description: json['description'],
//       price: json['price'].toDouble(),
//       images: List<String>.from(json['images'] ?? []),
//       startDate:
//           json['start_date'] != null
//               ? DateTime.parse(json['start_date'])
//               : null,
//       endDate:
//           json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
//     );
//   }
// }

// class VendorService {
//   String serviceType;
//   String description;
//   double price;
//   List<String> images;
//   bool isAddedToCart;
//   DateTime? startDate;
//   DateTime? endDate;

//   VendorService({
//     required this.serviceType,
//     required this.description,
//     required this.price,
//     required this.images,
//     this.isAddedToCart = false,
//     this.startDate,
//     this.endDate,
//   });

//   factory VendorService.fromJson(Map<String, dynamic> json) {
//     return VendorService(
//       serviceType: json['service_type'],
//       description: json['description'],
//       price: json['price'].toDouble(),
//       images: List<String>.from(json['images'] ?? []),
//       isAddedToCart: json['isAddedToCart'] ?? false,
//       startDate:
//           json['start_date'] != null
//               ? DateTime.parse(json['start_date'])
//               : null,
//       endDate:
//           json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'service_type': serviceType,
//       'description': description,
//       'price': price,
//       'images': images,
//       'isAddedToCart': isAddedToCart,
//       'start_date': startDate?.toIso8601String(),
//       'end_date': endDate?.toIso8601String(),
//     };
//   }
// }

// class VendorService {
//   final int id;
//   final String serviceType;
//   final String description;
//   final double price;
//   final List<String> images;
//   final bool isPackage; // ✅ required for UI
//   final bool isService; // ✅ optional depending on your app logic

//   DateTime? startDate; // ✅ for cart date logic
//   DateTime? endDate;
//   bool isAddedToCart;

//   VendorService({
//     required this.id,
//     required this.serviceType,
//     required this.description,
//     required this.price,
//     required this.images,
//     this.isPackage = false,
//     this.isService = true,
//     this.startDate,
//     this.endDate,
//     this.isAddedToCart = false,
//   });

//   factory VendorService.fromJson(Map<String, dynamic> json, {required bool isPackage}) {
//     return VendorService(
//       id: json['id'] ?? 0,
//       serviceType: json['serviceType'] ?? '',
//       description: json['description'] ?? '',
//       price: (json['price'] ?? 0).toDouble(),
//       images: List<String>.from(json['images'] ?? []),
//       isPackage: json['isPackage'] ?? false,
//       isService: json['isService'] ?? true,
//       startDate:
//           json['startDate'] != null
//               ? DateTime.tryParse(json['startDate'])
//               : null,
//       endDate:
//           json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
//       isAddedToCart: json['isAddedToCart'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'serviceType': serviceType,
//       'description': description,
//       'price': price,
//       'images': images,
//       'isPackage': isPackage,
//       'isService': isService,
//       'startDate': startDate?.toIso8601String(),
//       'endDate': endDate?.toIso8601String(),
//       'isAddedToCart': isAddedToCart,
//     };
//   }
// }

class VendorService {
  final int id;
  final String serviceType;
  final String description;
  final double price;
  final List<String> images;
  final bool isPackage;
  final bool isService;

  DateTime? startDate;
  DateTime? endDate;
  bool isAddedToCart;

  VendorService({
    required this.id,
    required this.serviceType,
    required this.description,
    required this.price,
    required this.images,
    this.isPackage = false,
    this.isService = true,
    this.startDate,
    this.endDate,
    this.isAddedToCart = false,
  });

  factory VendorService.fromJson(
    Map<String, dynamic> json, {
    required bool isPackage,
  }) {
    return VendorService(
      id: json['id'] ?? 0,
      serviceType: json['serviceType'] ?? json['service_type'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      isPackage: isPackage,
      isService: json['isService'] ?? json['is_service'] ?? true,
      startDate:
          json['startDate'] != null
              ? DateTime.tryParse(json['startDate'])
              : null,
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      isAddedToCart: json['isAddedToCart'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceType': serviceType,
      'description': description,
      'price': price,
      'images': images,
      'isPackage': isPackage,
      'isService': isService,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isAddedToCart': isAddedToCart,
    };
  }
}
