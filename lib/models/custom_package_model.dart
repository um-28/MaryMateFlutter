class CustomPackage {
  final int ap_id;
  final String packageName;
  final String description;
  final String serviceIds;
  final String packageIds;
  final double totalCost;

  CustomPackage({
    required this.ap_id,
    required this.packageName,
    required this.description,
    required this.serviceIds,
    required this.packageIds,
    required this.totalCost,
  });

  factory CustomPackage.fromJson(Map<String, dynamic> json) {
    return CustomPackage(
      ap_id: json['ap_id'], // ✅ fixed this line
      packageName: json['package_name'],
      description: json['description'],
      serviceIds: json['service_ids'],
      packageIds: json['package_ids'],
      totalCost: double.parse(json['totalcost'].toString()),
    );
  }
}
