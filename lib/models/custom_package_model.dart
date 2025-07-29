class CustomPackage {
  final int apId;
  final String packageName;
  final String description;
  final String serviceIds;
  final String packageIds;
  final double totalCost;

  CustomPackage({
    required this.apId,
    required this.packageName,
    required this.description,
    required this.serviceIds,
    required this.packageIds,
    required this.totalCost,
  });

  factory CustomPackage.fromJson(Map<String, dynamic> json) {
    return CustomPackage(
      apId: json['ap_id'],
      packageName: json['package_name'],
      description: json['description'],
      serviceIds: json['service_ids'],
      packageIds: json['package_ids'],
      totalCost: double.parse(json['totalcost'].toString()),
    );
  }
}
