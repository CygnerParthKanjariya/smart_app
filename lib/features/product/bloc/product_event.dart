abstract class ProductEvent {}

class GetProductsEvent extends ProductEvent {
  final int pageKey;

  GetProductsEvent({required this.pageKey});
}

class SearchProductsEvent extends ProductEvent {
  final String query;

  SearchProductsEvent({required this.query});
}
