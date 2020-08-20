import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/blocs/auth_bloc.dart';
import 'core/blocs/login_bloc.dart';
import 'core/repository/user_repository.dart';
import 'ui/authentication/login_page.dart';
import 'ui/roommate_matcher/roommate_matcher_home_page.dart';
import 'utils/circular_progress_loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository _userRepository = UserRepository();

  runApp(MultiBlocProvider(
    child: MyApp(),
    providers: <BlocProvider>[
      BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) =>
            AuthenticationBloc(userRepository: _userRepository)
              ..add(AppStarted()),
      ),
      BlocProvider<LoginBloc>(
        create: (BuildContext context) =>
            LoginBloc(userRepository: _userRepository),
      )
    ],
  ));
}

class MyApp extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      // routes: AppRoute().routes,
      //navigatorObservers: [AppRoute()],
      //onGenerateRoute: AppRoute().generateRoute,
      home: Scaffold(
        key: _scaffoldKey,
        body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          builder: (context, AuthenticationState state) {
            if (state is Authenticated) {
              return RoommateMatcherHomePage();
            } else if (state is InitialAuthState) {
              return SplashScreen();
            } else {
              return LoginPage();
            }
          },
          listener: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationErrorState) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Container(
                child: Text("${state.errorMessage}"),
              )));
            }
          },
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircularProgressLoading(),
    );
  }
}
