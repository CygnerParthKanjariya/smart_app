import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/details/bloc/detail_bloc.dart';
import 'package:smart_grocery/features/details/bloc/detail_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart Items"), centerTitle: true),
      body: BlocConsumer<DetailBloc, DetailState>(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("NO Items Added to Cart"));
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}
