import 'package:smart_grocery/features/product/models/Product_model.dart';

abstract class DetailEvent {}

class DetailAddToCartEvent extends DetailEvent {
  final Product product;

  DetailAddToCartEvent({required this.product});
}

