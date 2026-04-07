import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/product/bloc/product_event.dart';
import 'package:smart_grocery/features/product/bloc/product_state.dart';
import 'package:smart_grocery/features/product/models/product_model.dart';
import '../repository/api_helper.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  static const int _pageSize = 20;
  
  List<Product> _allLoadedProducts = [];
  List<Product> _originalOrderProducts = [];
  ProductSortType _currentSortType = ProductSortType.none;

  ProductBloc() : super(ProductInitialState()) {
    on<GetProductsEvent>((event, emit) async {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(ProductErrorState(errorMessage: "Check your network connection."));
        return;
      }

      try {
        final productModel = await ApiHelper().fetchProducts(
          limit: _pageSize,
          skip: event.pageKey,
        );

        List<Product> newItems = productModel.products ?? [];

        if (_currentSortType != ProductSortType.none) {
           if (_currentSortType == ProductSortType.lowToHigh) {
             newItems.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
           } else if (_currentSortType == ProductSortType.highToLow) {
             newItems.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
           }
        }

        if (event.pageKey == 0) {
          _allLoadedProducts = List.from(newItems);
          _originalOrderProducts = List.from(productModel.products ?? []);
        } else {
          _allLoadedProducts.addAll(newItems);
          _originalOrderProducts.addAll(productModel.products ?? []);
        }

        final total = productModel.total ?? 0;
        final currentSkip = event.pageKey;

        final isLastPage = (currentSkip + newItems.length) >= total || newItems.length < _pageSize;
        final nextPageKey = isLastPage ? 0 : currentSkip + newItems.length;

        emit(ProductLoadedState(
          products: newItems,
          isLastPage: isLastPage,
          nextPageKey: nextPageKey,
          replaceAll: event.pageKey == 0,
        ));
      } catch (e) {
        emit(ProductErrorState(errorMessage: e.toString()));
      }
    });

    on<SearchProductsEvent>((event, emit) async {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(ProductErrorState(errorMessage: "Check your network connection."));
        return;
      }

      if (event.query.isEmpty) {
        add(GetProductsEvent(pageKey: 0));
        return;
      }

      emit(ProductLoadingState());
      try {
        final productModel = await ApiHelper().searchProducts(query: event.query);
        final items = productModel.products ?? [];
        
        emit(ProductLoadedState(
          products: items,
          isLastPage: true,
          nextPageKey: 0,
          replaceAll: true,
        ));
      } catch (e) {
        emit(ProductErrorState(errorMessage: e.toString()));
      }
    });

    on<SortProductsEvent>((event, emit) {
      if (_allLoadedProducts.isEmpty) return;
      _currentSortType = event.sortType;

      List<Product> sortedList = List.from(_allLoadedProducts);

      switch (event.sortType) {
        case ProductSortType.lowToHigh:
          sortedList.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
          break;
        case ProductSortType.highToLow:
          sortedList.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
          break;
        case ProductSortType.none:
          sortedList = List.from(_originalOrderProducts);
          break;
      }

      _allLoadedProducts = List.from(sortedList);

      final bool isLastPage = state is ProductLoadedState ? (state as ProductLoadedState).isLastPage : true;
      final int nextPageKey = state is ProductLoadedState ? (state as ProductLoadedState).nextPageKey : 0;

      emit(ProductLoadedState(
        products: sortedList,
        isLastPage: isLastPage,
        nextPageKey: nextPageKey,
        replaceAll: true,
      ));
    });
  }
}
