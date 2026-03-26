import '../../product/models/Product_model.dart';

abstract class DetailState {}

class DetailInitialState extends DetailState {}

class AddedToCartState extends DetailState {
  List<Product> cartItems;

  AddedToCartState({required this.cartItems});
}
