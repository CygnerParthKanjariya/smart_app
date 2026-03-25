import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/product/bloc/product_event.dart';
import 'package:smart_grocery/features/product/bloc/product_state.dart';
import 'package:smart_grocery/features/product/models/Product_model.dart';
import 'package:smart_grocery/features/product/repository/api_helper.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  List<Product> _allProducts = [];

  ProductBloc() : super(ProductInitialState()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        ProductModel productModel = await ApiHelper().fetchProducts();
        _allProducts = productModel.products ?? [];
        emit(ProductLoadedState(products: _allProducts));
      } catch (e) {
        emit(ProductLoadedState(products: []));
      }
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
