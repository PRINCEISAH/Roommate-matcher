import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/repository/user_repository.dart';

@immutable
abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithCredentialsPressed(this.email, this.password);

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}

class LoginWithGooglePressed extends LoginEvent {}

class ResetPassword extends LoginEvent {
  final String email;
  ResetPassword(this.email);

  @override
  List<Object> get props => [email];
}

class SignUpPressed extends LoginEvent {
  final String username;
  final String email;
  final String password;
  SignUpPressed(this.username, this.email, this.password);

  @override
  List<Object> get props => [username, email, password];

  @override
  String toString() {
    return 'SignUp { email: $email, password: $password }';
  }
}

class SignOut extends LoginEvent {}

@immutable
class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String error;

  LoginState(
      {@required this.isLoading,
      @required this.isSuccess,
      @required this.isFailure,
      this.error = ""});

  factory LoginState.empty() {
    return LoginState(
      isLoading: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isLoading: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.failure(String error) {
    return LoginState(
        isLoading: false, isSuccess: false, isFailure: true, error: error);
  }

  factory LoginState.success() {
    return LoginState(
      isLoading: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  LoginState copyWith({
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return LoginState(
      isLoading: isSubmitting ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isSubmitting: $isLoading,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepo;
  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(UserRepository != null),
        _userRepo = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(event);
    }
    if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGoogle();
    }
    if (event is SignUpPressed) {
      yield* _mapSignUpToState(event);
    }
    if (event is SignOut) {
      yield* _mapEventToSignOut();
    }
    if (event is ResetPassword) {
      yield* _mapStateToResetPassword(event.email);
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      LoginWithCredentialsPressed event) async* {
    yield LoginState.loading();
    try {
      await _userRepo.signInWithCredentials(event.email, event.password);
      yield LoginState.success();
    } on Exception catch (error) {
      yield LoginState.failure(error.toString());
    }
  }

  Stream<LoginState> _mapLoginWithGoogle() async* {
    yield LoginState.loading();
    try {
      await _userRepo.signInWithGoogle();
      yield LoginState.success();
    } on Exception catch (error) {
      yield LoginState.failure(error.toString());
    }
  }

  Stream<LoginState> _mapSignUpToState(SignUpPressed event) async* {
    yield LoginState.loading();
    try {
      await _userRepo.signUp(event.username, event.email, event.password);
      yield LoginState.success();
    } on Exception catch (error) {
      yield LoginState.failure(error.toString());
    }
  }

  Stream<LoginState> _mapEventToSignOut() async* {
    try {
      _userRepo.signOut();
      yield LoginState.empty();
    } catch (error) {
      yield LoginState.failure(error.toString());
    }
  }

  Stream<LoginState> _mapStateToResetPassword(String email) async* {
    try {
      await _userRepo.resetPassword(email);
      yield LoginState.failure('Reset Password Email Sent');
    } catch (error) {
      yield LoginState.failure(error.toString());
    }
  }
}
