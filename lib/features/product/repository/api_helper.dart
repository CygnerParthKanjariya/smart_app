import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_grocery/features/product/models/product_model.dart';

class ApiHelper {
  Future<ProductModel> fetchProducts({required int limit, required int skip}) async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/products?limit=$limit&skip=$skip"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = await jsonDecode(response.body);
      if (data['products'] == null) {
        return ProductModel(products: []);
      }

      return ProductModel.fromJson(data);
    } else {
      throw Exception("Failed to load products");
    }
  }

  Future<ProductModel> searchProducts({required String query}) async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/products/search?q=$query"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = await jsonDecode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception("Failed to search products");
    }
  }
}
