class Vendor {
  final int vendorId;
  final String businessType;
  final String businessName;
  final String description;
  final int status;
  final String? categoryImageUrl;

  Vendor({
    required this.vendorId,
    required this.businessType,
    required this.businessName,
    required this.description,
    required this.status,
    this.categoryImageUrl,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorId: json['vendor_id'] ?? '',
      businessType: json['business_type'] ?? '',
      businessName: json['business_name'] ?? '',
      description: json['description'] ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      categoryImageUrl: json['category_image_url'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'vendor_id': vendorId,
  //     'business_name': businessName,
  //     'description': description,
  //     'status': status,
  //     'category_image_url': categoryImageUrl,
  //   };
  // }
}
