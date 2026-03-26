import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/cart/bloc/cart_state.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart Items"), centerTitle: true),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is AddedToCartState) {
            return ListView.builder(
              itemCount: state.cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.network(
                            state.cartItems[index].thumbnail.toString(),
                            height: 200,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.remove),
                              ),
                              Text(" "),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              state.cartItems[index].title.toString(),
                              style: TextStyle(fontSize: 20, fontWeight: .bold),
                            ),
                            Text(
                              state.cartItems[index].description.toString(),
                              style: TextStyle(fontSize: 17),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 35),
                            ElevatedButton(
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  RemoveFromCartEvent(
                                    product: state.cartItems[index],
                                  ),
                                );
                              },
                              child: Text("Remove"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No Items Added to Cart"));
          }
        },
      ),
    );
  }
}
