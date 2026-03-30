import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:smart_grocery/features/product/bloc/product_bloc.dart';
import 'package:smart_grocery/features/product/models/product_model.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_state.dart';
import '../../cart/screen/cart_screen.dart';
import '../../details/screen/detail_screen.dart';
import '../../settings/screen/settings_screen.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController productController = TextEditingController();
  late final PagingController<int, Product> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, Product>(
      getNextPageKey: (state) => null, // Triggered by Bloc listener
      fetchPage: (pageKey) {
        context.read<ProductBloc>().add(GetProductsEvent(pageKey: pageKey));
        return <Product>[];
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    productController.dispose();
    super.dispose();
  }

  void _onFetchNextPage() {
    final currentState = _pagingController.value;
    if (currentState.isLoading || !currentState.hasNextPage) return;

    _pagingController.value = PagingState(
      pages: currentState.pages,
      keys: currentState.keys,
      error: currentState.error,
      hasNextPage: currentState.hasNextPage,
      isLoading: true,
    );

    int nextKey = 0;
    if (currentState.pages != null) {
      for (var page in currentState.pages!) {
        nextKey += page.length;
      }
    }
    context.read<ProductBloc>().add(GetProductsEvent(pageKey: nextKey));
  }

  final user = FirebaseAuth.instance.currentUser;

  Widget buildProfilePicture() {
    if (user?.photoURL == null || user!.photoURL!.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.person));
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(user!.photoURL!),
      radius: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart APP"),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: buildProfilePicture(),
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: buildProfilePicture()),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          user?.displayName ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(user?.email ?? ""),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('My Cart'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is AddedToCartState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        state.isAdded
                            ? "Product has been Added to cart"
                            : "Product has remove from cart",
                      ),
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductLoadedState) {
                final currentState = _pagingController.value;
                if (productController.text.isNotEmpty) {
                  _pagingController.value = PagingState(
                    pages: [state.products],
                    keys: [0],
                    hasNextPage: false,
                    isLoading: false,
                  );
                } else {
                  final List<List<Product>> updatedPages = List.from(currentState.pages ?? []);
                  updatedPages.add(state.products);

                  final List<int> updatedKeys = List.from(currentState.keys ?? []);
                  updatedKeys.add(state.nextPageKey);

                  _pagingController.value = PagingState(
                    pages: updatedPages,
                    keys: updatedKeys,
                    hasNextPage: !state.isLastPage,
                    isLoading: false,
                  );
                }
              } else if (state is ProductErrorState) {
                _pagingController.value = PagingState(
                  pages: _pagingController.value.pages,
                  keys: _pagingController.value.keys,
                  error: state.errorMessage,
                  hasNextPage: _pagingController.value.hasNextPage,
                  isLoading: false,
                );
              } else if (state is ProductLoadingState) {
                _pagingController.value = PagingState(
                  pages: _pagingController.value.pages,
                  keys: _pagingController.value.keys,
                  error: _pagingController.value.error,
                  hasNextPage: _pagingController.value.hasNextPage,
                  isLoading: true,
                );
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: productController,
                decoration: InputDecoration(
                  hintText: "Search Product",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    _pagingController.value = PagingState(hasNextPage: true, isLoading: false);
                    context.read<ProductBloc>().add(GetProductsEvent(pageKey: 0));
                  } else {
                    context.read<ProductBloc>().add(SearchProductsEvent(query: value));
                  }
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ValueListenableBuilder<PagingState<int, Product>>(
                  valueListenable: _pagingController,
                  builder: (context, state, _) {
                    return PagedGridView<int, Product>(
                      state: state,
                      fetchNextPage: _onFetchNextPage,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                      ),
                      builderDelegate: PagedChildBuilderDelegate<Product>(
                        itemBuilder: (context, item, index) => InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(product: item),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    item.thumbnail ?? "",
                                    errorBuilder: (_, __, ___) => const Icon(Icons.error),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    item.title ?? "",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text(
                                    item.description ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
