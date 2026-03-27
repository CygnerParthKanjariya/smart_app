import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_grocery/features/login/auth/auth_repository.dart';
import 'package:smart_grocery/features/login/bloc/login_event.dart';
import 'package:smart_grocery/features/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitialState()) {
    on<LoginSuccessEvent>((event, emit) async {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      final passwordRegex = RegExp(r'^.{6,}$');

      await Future.delayed(Duration(seconds: 2));

      if (event.email.isEmpty || event.password.isEmpty) {
        emit(LoginFailedState(errorMessage: "Fields cannot be Empty"));
      } else if (!emailRegex.hasMatch(event.email)) {
        emit(LoginFailedState(errorMessage: "Invalid Email"));
      } else if (!passwordRegex.hasMatch(event.password)) {
        emit(LoginFailedState(errorMessage: "Invalid Password"));
      } else {
        emit(LoginLoadingState());
        await Future.delayed(Duration(seconds: 2));
        emit(LoginSuccessState());
      }
    });

    on<GoogleLoginEvent>((event, emit) async {
      emit(LoginLoadingState());

      try {
        final user = await authRepository.signInWithGoogle();
        print("========================================");
        print("user  :$user");
        print("========================================");
        if (user != null) {
          emit(GoogleLoginSuccessState());
        } else {
          emit(
            GoogleLoginFailedState(errorMessage: "Google Sign-In Cancelled"),
          );
        }
      } catch (e) {
        emit(GoogleLoginFailedState(errorMessage: "Google Login Cancelled"));
      }
    });
  }
}
