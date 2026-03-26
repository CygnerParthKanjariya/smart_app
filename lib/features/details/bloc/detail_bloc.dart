import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/product/models/Product_model.dart';

import 'detail_event.dart';
import 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  List<Product> cartItems = [];

  DetailBloc() : super(DetailInitialState()) {
    on<DetailAddToCartEvent>((event, emit) {
      // cartItems.add(event.product);
      // print("==============================");
      // print(cartItems);
      // print(cartItems.length);
      // print("==============================");
      // emit(AddedToCartState(cartItems: cartItems));
      if (!cartItems.contains(event.product)) {
        cartItems.add(event.product);
      }
      print("==============================");
      print(cartItems);
      print(cartItems.length);
      print("==============================");
      emit(AddedToCartState(cartItems: cartItems));
    });
  }
}
