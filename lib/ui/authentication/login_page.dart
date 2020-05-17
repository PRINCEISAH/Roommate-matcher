import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/blocs/auth_bloc.dart';
import 'package:roommatematcher/core/blocs/login_bloc.dart';

import 'widgets/wave_clipper.dart';
import '../../utils/string_extension.dart';

const double _horizontalPadding = 32;

class LoginPage extends StatefulWidget {
  static const ROUTE_NAME = "/login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _loginFormKey = new GlobalKey();
  FocusNode _passwordFocusNode, _loginFocusNode, _emailFocusNode;
  bool _isShowPassWord = false;
  TextEditingController _email = TextEditingController(text: "");
  TextEditingController _username = TextEditingController(text: "");

  TextEditingController _password = TextEditingController(text: "");

  bool _isLogin = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _loginFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
  }

  void _showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  void _changeIsLogin() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _signInOrUp() {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      if (!_isLogin) {
        BlocProvider.of<LoginBloc>(context)
            .add(SignUpPressed(_username.text, _email.text, _password.text));
      } else {
        BlocProvider.of<LoginBloc>(context)
            .add(LoginWithCredentialsPressed(_email.text, _password.text));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipper2(),
                  child: Container(
                    child: Column(),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Theme.of(context).primaryColorDark.withOpacity(0.3),
                          Theme.of(context).primaryColorLight.withOpacity(0.3)
                        ])),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper3(),
                  child: Container(
                    child: Column(),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Theme.of(context).primaryColorDark.withOpacity(0.6),
                          Theme.of(context).primaryColorLight.withOpacity(0.6)
                        ])),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper1(),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Icon(
                          Icons.location_city,
                          color: Colors.white,
                          size: 60,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Roommate Matcher",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 30),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Theme.of(context).primaryColorDark,
                          Theme.of(context).primaryColorLight
                        ])),
                  ),
                ),
              ],
            ),
          ),
          if (_isLogin)
            SizedBox(
              height: 30,
            ),
          Form(
            key: _loginFormKey,
            child: Column(
              children: <Widget>[
                if (!_isLogin)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: _horizontalPadding),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextFormField(
                        key: UniqueKey(),
                        controller: _username,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_emailFocusNode),
                        validator: (String value) {
                          return value.isNotEmpty
                              ? null
                              : "Please Enter a Valid Name";
                        },
                        onSaved: (value) {
                          this._username.text = value;
                        },
                        decoration: InputDecoration(
                            hintText: "Username",
                            prefixIcon: Material(
                              elevation: 0,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.account_circle,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 13)),
                      ),
                    ),
                  ),
                if (!_isLogin)
                  SizedBox(
                    height: 30,
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: TextFormField(
                      key: UniqueKey(),
                      controller: _email,
                      focusNode: _emailFocusNode,
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      validator: (String value) {
                        return value.isEmailValid
                            ? null
                            : "Please enter a valid email";
                      },
                      onSaved: (value) {
                        this._email.text = value;
                      },
                      decoration: InputDecoration(
                          hintText: " Email address",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 13)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: TextFormField(
                      key: UniqueKey(),
                      controller: _password,
                      focusNode: _passwordFocusNode,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_loginFocusNode),
                      validator: (value) {
                        return value.isEmpty
                            ? "Please enter a valid password"
                            : null;
                      },
                      onSaved: (value) {
                        this._password.text = value;
                      },
                      //输入密码，需要用*****显示
                      obscureText: !_isShowPassWord,
                      decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                              icon: Icon(
                                _isShowPassWord
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () => _showPassWord()),
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: Icon(
                              Icons.lock,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 13)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                child: child,
                scale: animation,
              );
            },
            child: BlocConsumer<LoginBloc, LoginState>(
              builder: (BuildContext context, LoginState state) {
                if (state.isLoading) {
                  return _buildLoginLoading();
                } else {
                  return _buildLoginButton();
                }
              },
              listener: (BuildContext context, LoginState state) {
                if (state.isFailure) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Container(
                    child: Text("${state.error}"),
                  )));
                } else if (state.isSuccess) {
                  print(
                      "State is success in login bloc trying to yield LoggedIn in  Auth bloc");

                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: _horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  !_isLogin ? "Have account?" : "Don't have account? ",
                  style: TextStyle(fontFamily: "Poppins-Medium"),
                ),
                InkWell(
                  onTap: () {
                    _changeIsLogin();
                  },
                  child: Text(
                    !_isLogin ? " Sign in" : " Sign up",
                  ),
                )
              ],
            ),
          ),
          GoogleSignInButton(
            onPressed: () {
              BlocProvider.of<LoginBloc>(context).add(LoginWithGooglePressed());
            },
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLoading() {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: 25, width: 25, child: CircularProgressIndicator()),
        ));
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
          focusNode: _loginFocusNode,
          child: Text(
            _isLogin ? " Login in" : " Sign up",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          onPressed: () async {
            if (_loginFormKey.currentState.validate()) {
              _loginFormKey.currentState.save();
              _signInOrUp();
            }
          },
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({Key key, @required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Text(
              "Sign in with Google",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}