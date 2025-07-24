import 'dart:convert';
import 'package:http/http.dart' as http;
import '../screens/wedding_service_model.dart';

class WeddingServiceApi {
  static const String baseUrl = 'http://192.168.1.3:8000/api/services';

  static Future<List<WeddingService>> fetchWeddingHalls() async {
    final response = await http.get(Uri.parse('$baseUrl/wedding-halls'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => WeddingService.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }
}
