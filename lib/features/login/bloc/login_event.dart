abstract class LoginEvent {}

class LoginSuccessEvent extends LoginEvent {
  final String email;
  final String password;

  LoginSuccessEvent({required this.email, required this.password});
}

class GoogleLoginEvent extends LoginEvent {}
