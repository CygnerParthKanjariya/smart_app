import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/product/bloc/product_bloc.dart';
import 'package:smart_grocery/features/product/bloc/product_state.dart';
import 'package:smart_grocery/features/product/models/Product_model.dart';

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title.toString()), centerTitle: true),
      body: SingleChildScrollView(
        child: BlocConsumer<ProductBloc, ProductState>(
          builder: (context, state) {
            double discountedPrice =
                product.price! -
                (product.price! * product.discountPercentage! / 100);
            String discountedPriceString = discountedPrice.toStringAsFixed(2);
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.network(product.thumbnail.toString()),
                  Text(
                    product.title.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: .bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        "Price: \$$discountedPriceString",
                        style: TextStyle(fontSize: 18, fontWeight: .bold),
                      ),
                      Text(
                        "\$${product.price}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: .w300,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        "(${product.discountPercentage}% OFF)",
                        style: TextStyle(fontSize: 18, fontWeight: .bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blueAccent[100],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.description.toString(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {},
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () {},
                child: Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 18, fontWeight: .bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Buy Now",
                  style: TextStyle(fontSize: 18, fontWeight: .bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
