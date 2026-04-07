import 'dart:convert';
import 'package:smart_grocery/core/api_helper/api_helper.dart';
import 'package:smart_grocery/features/product/models/product_model.dart';

class ProductRepository {
  final ApiHelper apiHelper;

  ProductRepository(this.apiHelper);

  Future<ProductModel> fetchProducts({
    required int limit,
    required int skip,
  }) async {
    final response = await apiHelper.getProductHelper(
      "https://dummyjson.com/products?limit=$limit&skip=$skip",
      limit,
      skip,
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
    final response = await apiHelper.searchProductHelper(
      url: "https://dummyjson.com/products/search?q=$query",
      query: query,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = await jsonDecode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception("Failed to search products");
    }
  }
}
