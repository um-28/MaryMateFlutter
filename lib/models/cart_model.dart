class CartItem {
  final String serviceName;
  final String description;
  final double price;
  final int serviceId;
  final int? packageId;
  final int vendorId;
  final DateTime? startDate;
  final DateTime? endDate;

  CartItem({
    required this.serviceName,
    required this.description,
    required this.price,
    required this.vendorId,
    required this.serviceId,
    required this.packageId,
    required this.startDate,
    required this.endDate,
  });
}
