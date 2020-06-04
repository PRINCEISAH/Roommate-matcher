import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/blocs/auth_bloc.dart';
import 'package:roommatematcher/core/blocs/login_bloc.dart';

import '../../utils/string_extension.dart';

const double _horizontalPadding = 20;

class LoginPage extends StatefulWidget {
  static const ROUTE_NAME = "/login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _loginFormKey = new GlobalKey();
  FocusNode _passwordFocusNode,
      _loginFocusNode,
      _emailFocusNode,
      _phoneFocusNode;
  bool _isShowPassWord = false;
  TextEditingController _email = TextEditingController(text: "");
  TextEditingController _username = TextEditingController(text: "");
  TextEditingController _phone = TextEditingController(text: "");

  TextEditingController _password = TextEditingController(text: "");

  bool _isLogin = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _loginFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
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
        BlocProvider.of<LoginBloc>(context).add(SignUpPressed(
            _username.text, _email.text, _phone.text, _password.text));
      } else {
        BlocProvider.of<LoginBloc>(context)
            .add(LoginWithCredentialsPressed(_email.text, _password.text));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 75,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Welcome back. Let\'s pick up',
                      style: TextStyle(color: Color(0xff2F4070), fontSize: 24),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'where you left off.',
                      style: TextStyle(color: Color(0xff2F4070), fontSize: 24),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Text(
                    'Sign in below to continue',
                    style: TextStyle(color: Color(0xfff2F4070), fontSize: 24),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              if (_isLogin)
                SizedBox(
                  height: 10,
                ),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    if (!_isLogin)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _horizontalPadding),
                        child: Material(
                          color: Color(0xffE4E6E9),
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: TextFormField(
                            key: UniqueKey(),
                            controller: _username,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_phoneFocusNode),
                            validator: (String value) {
                              return value.isNotEmpty
                                  ? null
                                  : "Please Enter a Valid Name";
                            },
                            onSaved: (value) {
                              this._username.text = value;
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: "Username",
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
                    if (!_isLogin)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _horizontalPadding),
                        child: Material(
                          color: Color(0xffE4E6E9),
                          elevation: 2.0,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: TextFormField(
                            key: UniqueKey(),
                            controller: _phone,
                            focusNode: _phoneFocusNode,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            // Todo add a good phone validation
                            validator: (String value) {
                              return value.isNotEmpty
                                  ? null
                                  : "Please Enter a Valid Phone Number";
                            },
                            onSaved: (value) {
                              this._phone.text = value;
                            },
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintText: "Phone number",
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
                      padding:
                          EdgeInsets.symmetric(horizontal: _horizontalPadding),
                      child: Material(
                        color: Color(0xffE4E6E9),
                        elevation: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              hintText: " Email",
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        color: Color(0xffE4E6E9),
                        elevation: 2.0,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: TextFormField(
                          key: UniqueKey(),
                          controller: _password,
                          focusNode: _passwordFocusNode,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_loginFocusNode),
                          validator: (value) {
                            return value.isEmpty
                                ? "Please enter a valid password"
                                : null;
                          },
                          onSaved: (value) {
                            this._password.text = value;
                          },
                          obscureText: !_isShowPassWord,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
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

                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(LoggedIn());
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
                  BlocProvider.of<LoginBloc>(context)
                      .add(LoginWithGooglePressed());
                },
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
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
      height: 48,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: FlatButton(
          color: Colors.black,
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          focusNode: _loginFocusNode,
          child: Text(
            _isLogin ? " Login" : " Sign up",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("Icons/Google.png"),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "Sign in with Google",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
