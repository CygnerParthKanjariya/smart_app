import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/cart/screen/cart_screen.dart';
import 'package:smart_grocery/features/product/bloc/product_bloc.dart';
import 'package:smart_grocery/features/product/models/Product_model.dart';

import '../../details/screen/detail_screen.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController productController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() {
    context.read<ProductBloc>().add(GetProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart APP"),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductLoadedState) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: productController,
                    decoration: InputDecoration(
                      hintText: "Search Product",
                      prefixIcon: Icon(
                        Icons.production_quantity_limits_outlined,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<ProductBloc>().add(
                        SearchProductsEvent(query: value),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      itemCount: state.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  product: state.products[index],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    "${state.products[index].thumbnail}",
                                  ),
                                ),
                                Text(
                                  state.products[index].title ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: .w600,
                                  ),
                                ),
                                Text(
                                  state.products[index].description ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
        listener: (context, state) {},
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
