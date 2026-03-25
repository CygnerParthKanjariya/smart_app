import 'package:smart_grocery/features/product/models/Product_model.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<Product> products;

  ProductLoadedState({required this.products});
}
