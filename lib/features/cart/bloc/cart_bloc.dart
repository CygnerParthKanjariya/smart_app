import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/product/models/product_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<Product> cartItems = [];

  CartBloc() : super(CartInitialState()) {
    on<AddToCartEvent>((event, emit) {
      if (!cartItems.contains(event.product)) {
        cartItems.add(event.product);
      }
      print("==============================");
      print(cartItems);
      print(cartItems.length);
      print("==============================");
      emit(AddedToCartState(cartItems: cartItems,isAdded: true));
    });
    on<RemoveFromCartEvent>((event, emit) {
      cartItems.remove(event.product);
      emit(AddedToCartState(cartItems: cartItems,isAdded: false));
    },);
  }
}
