import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/product/bloc/product_event.dart';
import 'package:smart_grocery/features/product/bloc/product_state.dart';
import '../repository/api_helper.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  static const int _pageSize = 20;

  ProductBloc() : super(ProductInitialState()) {
    on<GetProductsEvent>((event, emit) async {
      try {
        final productModel = await ApiHelper().fetchProducts(
          limit: _pageSize,
          skip: event.pageKey,
        );

        final newItems = productModel.products ?? [];
        final total = productModel.total ?? 0;
        final currentSkip = event.pageKey;

        // Accurate last page detection: if skip + current items >= total
        final isLastPage =
            (currentSkip + newItems.length) >= total ||
            newItems.length < _pageSize;
        final nextPageKey = isLastPage
            ? 0
            : currentKeyCalculation(currentSkip, newItems.length);

        emit(
          ProductLoadedState(
            products: newItems,
            isLastPage: isLastPage,
            nextPageKey: nextPageKey,
          ),
        );
      } catch (e) {
        emit(ProductErrorState(errorMessage: e.toString()));
      }
    });

    on<SearchProductsEvent>((event, emit) async {
      if (event.query.isEmpty) {
        add(GetProductsEvent(pageKey: 0));
        return;
      }

      emit(ProductLoadingState());
      try {
        final productModel = await ApiHelper().searchProducts(
          query: event.query,
        );
        final items = productModel.products ?? [];

        emit(
          ProductLoadedState(products: items, isLastPage: true, nextPageKey: 0),
        );
      } catch (e) {
        emit(ProductErrorState(errorMessage: e.toString()));
      }
    });
  }

  int currentKeyCalculation(int skip, int count) {
    return skip + count;
  }
}
