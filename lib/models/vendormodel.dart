class Vendor {
  final int vendorId;
  final String businessType;
  final String businessName;
  final String description;
  final int status;

  Vendor({
    required this.vendorId,
    required this.businessType,
    required this.businessName,
    required this.description,
    required this.status,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorId: json['vendor_id'] ?? '',
      businessType: json['business_type'] ?? '',
      businessName: json['business_name'] ?? '',
      description: json['description'] ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
    );
  }
}
