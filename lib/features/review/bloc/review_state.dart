abstract class ReviewState {}

class ReviewInitialState extends ReviewState {}

class ReviewLoadedState extends ReviewState {
  final List<dynamic> reviews;

  ReviewLoadedState({required this.reviews});
}
