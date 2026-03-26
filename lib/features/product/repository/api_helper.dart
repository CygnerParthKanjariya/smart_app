import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_grocery/features/product/models/product_model.dart';

class ApiHelper {
  Future<ProductModel> fetchProducts() async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/products"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = await jsonDecode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception("Failed to load products");
    }
  }
}
