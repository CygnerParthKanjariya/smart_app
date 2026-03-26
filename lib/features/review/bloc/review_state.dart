import '../../product/models/Product_model.dart';

abstract class ReviewState {}

class ReviewInitialState extends ReviewState {}

class ReviewLoadedState extends ReviewState {
  final List<Review> reviews;

  ReviewLoadedState({required this.reviews});
}
