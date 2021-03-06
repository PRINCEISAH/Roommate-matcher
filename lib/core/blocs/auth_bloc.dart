import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/repository/user_repository.dart';

import '../../core/models/user.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {
  final User user;
  const Authenticated(this.user);
  @override
  List<Object> get props => [user];
  @override
  String toString() => 'Authenticated { user: $user }';
}

class Unauthenticated extends AuthenticationState {}

class InitialAuthState extends AuthenticationState {}

class AuthenticationErrorState extends AuthenticationState {
  final String errorMessage;
  AuthenticationErrorState(this.errorMessage);
}

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => InitialAuthState();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppToState();
    }
    if (event is LoggedIn) {
      print("yielding login in Auth bloc");
      yield* _mapLoginToState();
    }
    if (event is LoggedOut) {
      yield* _mapLogoutToStart();
    }
  }

  Stream<AuthenticationState> _mapAppToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        yield Authenticated(await _userRepository.getCurrentUser());
      } else {
        yield Unauthenticated();
      }
    } catch (e) {
      yield AuthenticationErrorState("$e");
    }
  }

  Stream<AuthenticationState> _mapLoginToState() async* {
    print("Inside _mapLoginToState ");
    try {
      final user = await _userRepository.getCurrentUser();
      print("This is the authenticated user $user");
      yield Authenticated(user);
    } catch (e) {
      yield AuthenticationErrorState("$e");
    }
  }

  Stream<AuthenticationState> _mapLogoutToStart() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
