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

class VendorService {
  String serviceType;
  String description;
  double price;
  List<String> images;
  bool isAddedToCart;
  DateTime? startDate;
  DateTime? endDate;

  VendorService({
    required this.serviceType,
    required this.description,
    required this.price,
    required this.images,
    this.isAddedToCart = false,
    this.startDate,
    this.endDate,
  });

  factory VendorService.fromJson(Map<String, dynamic> json) {
    return VendorService(
      serviceType: json['service_type'],
      description: json['description'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images'] ?? []),
      isAddedToCart: json['isAddedToCart'] ?? false,
      startDate:
          json['start_date'] != null
              ? DateTime.parse(json['start_date'])
              : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_type': serviceType,
      'description': description,
      'price': price,
      'images': images,
      'isAddedToCart': isAddedToCart,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }
}
