class WeddingService {
  final int serviceId;
  final String serviceType;
  final String description;
  final double price;
  final String images;

  WeddingService({
    required this.serviceId,
    required this.serviceType,
    required this.description,
    required this.price,
    required this.images,
  });

  factory WeddingService.fromJson(Map<String, dynamic> json) {
    return WeddingService(
      serviceId: json['service_id'],
      serviceType: json['service_type'],
      description: json['description'],
      price: json['price'].toDouble(),
      images: json['images'],
    );
  }
}
