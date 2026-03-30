import 'package:smart_grocery/features/product/models/product_model.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<Product> products;
  final bool isLastPage;
  final int nextPageKey;

  ProductLoadedState({
    required this.products,
    required this.isLastPage,
    required this.nextPageKey,
  });
}

class ProductErrorState extends ProductState {
  final String errorMessage;

  ProductErrorState({required this.errorMessage});
}
