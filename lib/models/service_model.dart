// class VendorService {
//   final int id;
//   final String serviceType;
//   final String categoryType;
//   final String description;
//   final double price;
//   final List<String> images;
//   final bool isPackage;
//   final bool isService;

//   DateTime? startDate;
//   DateTime? endDate;
//   bool isAddedToCart;

//   VendorService({
//     required this.id,
//     required this.serviceType,
//     required this.categoryType,
//     required this.description,
//     required this.price,
//     required this.images,
//     this.isPackage = false,
//     this.isService = true,
//     this.startDate,
//     this.endDate,
//     this.isAddedToCart = false,
//   });

//   factory VendorService.fromJson(
//     Map<String, dynamic> json, {
//     required bool isPackage,
//   }) {
//     return VendorService(
//       id: json['id'] ?? 0,
//       // serviceType: json['serviceType'] ?? json['service_type'] ?? '',
//       serviceType:
//           isPackage
//               ? json['package_name'] ?? 'Package'
//               : json['serviceType'] ?? json['service_type'] ?? '',
//       categoryType: json['service_types'] ?? '',
//       description: json['description'] ?? '',
//       price: (json['price'] ?? 0).toDouble(),
//       images: List<String>.from(json['images'] ?? []),
//       isPackage: isPackage,
//       isService: json['isService'] ?? json['is_service'] ?? true,
//       startDate:
//           json['startDate'] != null
//               ? DateTime.tryParse(json['startDate'])
//               : null,
//       endDate:
//           json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
//       isAddedToCart: json['isAddedToCart'] ?? false,
//     );
//   }

//   get vendorId => null;

//   get packageId => null;

//   get serviceId => null;

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'serviceType': serviceType,
//       'categoryType': categoryType,
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
  final String categoryType;
  final String description;
  final double price;
  final List<String> images;
  final bool isPackage;
  final bool isService;

  final int vendorId;
  final int serviceId;
  final int? packageId;

  DateTime? startDate;
  DateTime? endDate;
  bool isAddedToCart;

  VendorService({
    required this.id,
    required this.serviceType,
    required this.categoryType,
    required this.description,
    required this.price,
    required this.images,
    required this.vendorId,
    required this.serviceId,
    this.packageId,
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
      serviceType:
          isPackage
              ? json['package_name'] ?? 'Package'
              : json['serviceType'] ?? json['service_type'] ?? '',
      categoryType: json['service_types'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      vendorId: json['vendor_id'] ?? 0,
      serviceId: json['service_id'] ?? 0,
      packageId: json['package_id'], // null-safe
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
      'categoryType': categoryType,
      'description': description,
      'price': price,
      'images': images,
      'vendor_id': vendorId,
      'service_id': serviceId,
      'package_id': packageId,
      'isPackage': isPackage,
      'isService': isService,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isAddedToCart': isAddedToCart,
    };
  }
}
