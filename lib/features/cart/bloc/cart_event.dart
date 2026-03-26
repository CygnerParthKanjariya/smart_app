import 'package:smart_grocery/features/product/models/product_model.dart';

abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;

  AddToCartEvent({required this.product});
}

class RemoveFromCartEvent extends CartEvent {
  final Product product;

  RemoveFromCartEvent({required this.product});
}

