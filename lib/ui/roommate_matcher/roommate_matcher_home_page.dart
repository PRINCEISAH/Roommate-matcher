import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/blocs/auth_bloc.dart';

class RoommateMatcherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is how to get the user anywhere in the widget tree once the person have successfully authenticate
    final user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user.name}"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Log out"),
                  value: "logout",
                )
              ];
            },
            onSelected: (String val) {
              if (val == "logout") {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Log out"),
                        content: Text("Are you sure you want to log out?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          FlatButton(
                            child: Text("Log out"),
                            onPressed: () {
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(LoggedOut());
                              Navigator.maybePop(context);
                            },
                          ),
                        ],
                      );
                    });
              }
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[

        ],
      ),
    );
  }
}
