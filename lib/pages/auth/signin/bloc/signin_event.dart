abstract class SigninEvent {}

class SigninRequested extends SigninEvent {
  final String username;
  final String password;

  SigninRequested({
    required this.username,
    required this.password,
  });
}