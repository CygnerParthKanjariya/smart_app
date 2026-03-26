import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:smart_grocery/features/product/bloc/product_bloc.dart';
import 'package:smart_grocery/features/product/bloc/product_state.dart';
import 'package:smart_grocery/features/product/models/product_model.dart';
import 'package:smart_grocery/features/review/bloc/review_bloc.dart';
import 'package:smart_grocery/features/review/bloc/review_state.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../review/bloc/review_event.dart';

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title.toString()), centerTitle: true),
      body: SingleChildScrollView(
        child: BlocListener<ReviewBloc, ReviewState>(
          listener: (BuildContext context, state) {
            if (state is ReviewLoadedState) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("User Feedback"),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.reviews.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(state.reviews[index].toString()),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              double discountedPrice =
                  product.price! -
                  (product.price! * product.discountPercentage! / 100);
              String discountedPriceString = discountedPrice.toStringAsFixed(2);
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,

                      child: CarouselView(
                        scrollDirection: .horizontal,
                        itemExtent: double.infinity,
                        children: List.generate(product.images?.length ?? 0, (
                          index,
                        ) {
                          print("================================");
                          print(product.images![index]);
                          print("================================");
                          return Image.network(product.images?[index] ?? "");
                        }),
                      ),
                    ),
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
                    SizedBox(height: 10),
                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "In Stock: ${product.stock}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Brand: ${product.brand}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Category: ${product.category}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            StarRating(
                              allowHalfRating: true,
                              rating: product.rating ?? 0,
                              onRatingChanged: (rating) {},
                            ),
                            InkWell(
                              onTap: () {
                                // context.read<ReviewBloc>().add(
                                //   ShowReviewEvent(
                                //     reviews: product.reviews,
                                //   ),
                                // );
                              },
                              child: Text("View More"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
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
                onPressed: () {
                  context.read<CartBloc>().add(
                    AddToCartEvent(product: product),
                  );
                },
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
