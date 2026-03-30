

abstract class ProductEvent {}

class GetProductsEvent extends ProductEvent {
}

class SearchProductsEvent extends ProductEvent {
  final String query;



  SearchProductsEvent({required this.query});
}
