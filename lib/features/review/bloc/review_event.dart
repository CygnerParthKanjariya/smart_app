

import '../../product/models/Product_model.dart';

abstract class ReviewEvent {}

class ShowReviewEvent extends ReviewEvent{
   final List<Review> reviews;

  ShowReviewEvent({required this.reviews});
}