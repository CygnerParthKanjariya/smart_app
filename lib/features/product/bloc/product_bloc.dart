import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/product/bloc/product_event.dart';
import 'package:smart_grocery/features/product/bloc/product_state.dart';
import 'package:smart_grocery/features/product/models/product_model.dart';
import 'package:smart_grocery/features/product/repository/api_helper.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  List<Product> _allProducts = [];
  int _currentSkip = 0;
  final int _limit = 20;
  bool _isFetching = false;
  bool _hasReachedMax = false;

  ProductBloc() : super(ProductInitialState()) {
    on<GetProductsEvent>((event, emit) async {
      if (_isFetching || _hasReachedMax) return;

      _isFetching = true;

      try {
        if (!event.isLoadMore) {
          emit(ProductLoadingState());

          _currentSkip = 0;
          _allProducts = [];
          _hasReachedMax = false;
        }

        final productModel = await ApiHelper().fetchProducts(
          skip: _currentSkip,
          limit: _limit,
        );

        final List<Product> newProducts = productModel.products ?? [];

        if (newProducts.isEmpty) {
          _hasReachedMax = true;
        } else {
          _allProducts.addAll(newProducts);
          _currentSkip += _limit;
        }
        print(_allProducts);
        print(_allProducts.length);
        emit(ProductLoadedState(products: _allProducts));
      } catch (e) {
        if (_allProducts.isEmpty) {
          emit(ProductErrorState(errorMessage: e.toString()));
        }
      }

      _isFetching = false;
    });

    on<SearchProductsEvent>((event, emit) {
      final query = event.query.toLowerCase();

      final List<Product> filterProducts = _allProducts
          .where(
            (product) => product.title?.toLowerCase().contains(query) ?? false,
          )
          .toList();

      emit(ProductLoadedState(products: filterProducts));
    });
  }
}
