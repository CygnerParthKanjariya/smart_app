import '../../product/models/product_model.dart';

abstract class CartState {}

class CartInitialState extends CartState {}

class AddedToCartState extends CartState {
  final bool isAdded;
  final List<Product> cartItems;

  AddedToCartState({required this.cartItems, required this.isAdded});
}
