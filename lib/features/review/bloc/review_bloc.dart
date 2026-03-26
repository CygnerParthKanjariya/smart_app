

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/review/bloc/review_event.dart';
import 'package:smart_grocery/features/review/bloc/review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent,ReviewState>{
  ReviewBloc(): super(ReviewInitialState()){
    on<ShowReviewEvent>((event, emit) {
      emit(ReviewLoadedState(reviews: event.reviews));
    },);

  }
}