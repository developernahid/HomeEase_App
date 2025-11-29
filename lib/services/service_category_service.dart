import 'package:HomeEase/models/service_category_model.dart';
import 'package:HomeEase/services/api_service.dart';

class ServiceCategoryService {
  static Future<List<ServiceCategory>> getServices() async {
    try {
      final response = await ApiService.get('services');
      if (response is List) {
        return response.map((e) => ServiceCategory.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get services: $e');
    }
  }

  static Future<ServiceCategory?> createService(
      Map<String, dynamic> serviceData) async {
    try {
      final response = await ApiService.post('services', serviceData);
      if (response.isNotEmpty) {
        return ServiceCategory.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create service: $e');
    }
  }

  static Future<ServiceCategory?> updateService(
      String id, Map<String, dynamic> serviceData) async {
    try {
      final response = await ApiService.put('services/$id', serviceData);
      if (response.isNotEmpty) {
        return ServiceCategory.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to update service $id: $e');
    }
  }

  static Future<void> deleteService(String id) async {
    try {
      await ApiService.delete('services/$id');
    } catch (e) {
      throw Exception('Failed to delete service $id: $e');
    }
  }
}
