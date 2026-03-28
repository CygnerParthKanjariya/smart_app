

abstract class ProductEvent {}

class GetProductsEvent extends ProductEvent {
  final bool isLoadMore;
  GetProductsEvent({this.isLoadMore = false});
}

class SearchProductsEvent extends ProductEvent {
  final String query;



  SearchProductsEvent({required this.query});
}
