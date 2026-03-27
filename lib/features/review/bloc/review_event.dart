abstract class ReviewEvent {}

class ShowReviewEvent extends ReviewEvent {
  final List<dynamic> reviews;

  ShowReviewEvent({required this.reviews});
}
