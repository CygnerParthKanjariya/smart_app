

import 'package:http/http.dart' as http;

class ApiHelper {

  Future<http.Response> getProductHelper(String url,int limit, int skip) async {
    print("========================================");
    print("Helper Activates");
    print("========================================");
    final response = await http.get(
      Uri.parse("https://dummyjson.com/products?limit=$limit&skip=$skip"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }

  Future<http.Response> searchProductHelper({required String url, required String query}) async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/products/search?q=$query"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }
}