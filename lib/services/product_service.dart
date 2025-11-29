import 'package:HomeEase/models/product_model.dart';
import 'package:HomeEase/services/api_service.dart';

class ProductService {
  static Future<List<Product>> getProducts() async {
    try {
      final response = await ApiService.get('product');
      if (response is List) {
        return response.map((e) => Product.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  static Future<Product?> getProduct(String id) async {
    try {
      final response = await ApiService.get('product/$id');
      if (response.isNotEmpty) {
        return Product.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get product $id: $e');
    }
  }

  static Future<Product?> createProduct(
      Map<String, dynamic> productData) async {
    try {
      final response = await ApiService.post('product', productData);
      if (response.isNotEmpty) {
        return Product.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  static Future<Product?> updateProduct(
      String id, Map<String, dynamic> productData) async {
    try {
      final response = await ApiService.put('product/$id', productData);
      if (response.isNotEmpty) {
        return Product.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to update product $id: $e');
    }
  }

  static Future<void> deleteProduct(String id) async {
    try {
      await ApiService.delete('product/$id');
    } catch (e) {
      throw Exception('Failed to delete product $id: $e');
    }
  }
}
