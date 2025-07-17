class VendorService {
  // final int vendorId;
  final String serviceType;
  final String description;
  final double price;
  final List<String> images;
  DateTime? startDate;
  DateTime? endDate;
  bool isAddedToCart;

  VendorService({
    // required this.vendorId,
    required this.serviceType,
    required this.description,
    required this.price,
    required this.images,
    this.startDate,
    this.endDate,
    this.isAddedToCart = false,

  });

  factory VendorService.fromJson(Map<String, dynamic> json) {
    return VendorService(
      // vendorId: json['vendor_id'],
      serviceType: json['service_type'],
      description: json['description'],
      price: json['price'].toDouble(),
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
