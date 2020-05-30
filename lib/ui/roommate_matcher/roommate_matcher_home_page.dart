//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/blocs/auth_bloc.dart';
import 'package:roommatematcher/ui/apartment_create/apartment_create.dart';
import 'package:roommatematcher/ui/chat/chat_list_screen.dart';
//import 'package:roommatematcher/core/models/house.dart';
//import 'package:roommatematcher/ui/roommate_matcher/apartment_details_page.dart';
import 'package:roommatematcher/ui/roommate_matcher/search_results.dart';
import 'package:roommatematcher/utils/circular_progress_loading.dart';
import 'package:roommatematcher/core/api_services/apartment_api_services.dart';

class RoommateMatcherHomePage extends StatefulWidget {
  @override
  _RoommateMatcherHomePageState createState() =>
      _RoommateMatcherHomePageState();
}

class _RoommateMatcherHomePageState extends State<RoommateMatcherHomePage> {
  int _currentIndex = 0;

  columnBuilder(
      {BuildContext context, IndexedWidgetBuilder itemBuilder, int itemCount}) {
    List<Widget> columnChildren = [];
    for (var i = 0; i < itemCount; ++i) {
      columnChildren.add(itemBuilder(context, i));
    }

    return Column(
      children: columnChildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is how to get the user anywhere in the widget tree once the person have successfully authenticate
    final user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;

    /// This is where the logout function is
    /*popUpMenuFunction(String val) {
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
    }*/

    return DefaultTabController(
      length: _currentIndex == 1 ? 1 : 2,
      child: Scaffold(
        body: _currentIndex == 1
            ? ChatListScreen()
            : NestedScrollView(
                headerSliverBuilder: (_, __) => [
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        sliver: SliverAppBar(
                            elevation: 0,
                            pinned: true,
                            floating: true,
                            forceElevated: __,
                            backgroundColor: Colors.transparent,
                            bottom: PreferredSize(
                              preferredSize: Size.fromHeight(60),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.3,
                                      color: Theme.of(context).dividerColor),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.all(2),
                                child: TabBar(
                                  tabs: [
                                    Tab(
                                      text: 'A Room',
                                    ),
                                    Tab(
                                      text: 'A Roommate',
                                    )
                                  ],
                                  indicator: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  unselectedLabelColor:
                                      Colors.blueGrey.shade700,
                                ),
                              ),
                            ),
                            expandedHeight: 240,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Hi, ${user.name}',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.headline2,
                                  ),
                                  Text(
                                    'Advertise your room or find housemates with similar interests.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                body: TabBarView(
                  children: [
                    ListView(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                                // Yet to implement the function
                                // TODO: Implement the filter function
                                icon: Icon(Icons.filter_list),
                                onPressed: () => Container()),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            // TODO: Use appropriate hint text
                            hintText: 'MS Northbound, London',
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FutureBuilder(
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text(
                                  'There was an error trying to get apartments');
                            }

                            if (snapshot.hasData) {
                              return columnBuilder(
                                context: context,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        ApartmentCard(
                                            apartment: snapshot.data[index]),
                                itemCount: snapshot.data.length,
                              );
                            }

                            return CircularProgressLoading();
                          },
                          future: ApartmentApiService.getAllApartments(),
                        ),
                      ],
                    ),
                    Center(
                      child: RaisedButton(
                        child: Text('Create apartment'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ApartmentCreate()));
                        },
                      ),
                    ),
                  ],
                )),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          iconSize: 20,
          selectedIconTheme: IconThemeData(color: Colors.deepOrange),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
              ),
              title: Text('Messages'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.face,
              ),
              title: Text('profile'),
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
