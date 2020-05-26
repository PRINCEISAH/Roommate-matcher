import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/blocs/auth_bloc.dart';
<<<<<<< HEAD
import 'package:roommatematcher/core/models/house.dart';
import 'package:roommatematcher/ui/roommate_matcher/apartment_details_page.dart';
=======
import 'package:roommatematcher/ui/chat/chat_list_screen.dart';
//import 'package:roommatematcher/core/models/house.dart';
//import 'package:roommatematcher/ui/roommate_matcher/apartment_details_page.dart';
import 'package:roommatematcher/ui/roommate_matcher/search_results.dart';
import 'package:roommatematcher/utils/circular_progress_loading.dart';
import 'package:roommatematcher/core/api_services/apartment_api_services.dart';
>>>>>>> b5147c9f1e2ed5393d790b7f8ebf3f0061e2dfb7

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

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.orange),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.grey,
            ),
            title: Text('Favourite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.face,
              color: Colors.grey,
            ),
            title: Text('profile'),
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;

<<<<<<< HEAD
            if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            }
          });
        },
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 70,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text("Hi,${user.name}",
                    style: GoogleFonts.nunito(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 40)),
                Text("Advertise your room or find,",
                    style: GoogleFonts.nunito(
                        color: Colors.deepPurple, fontSize: 20)),
                Text("housemates with similar interests.",
                    style: GoogleFonts.nunito(
                        color: Colors.deepPurple, fontSize: 20)),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(20))),
                      height: double.infinity,
                      child: Container(
                        child: Center(
                          child: Text(
                            "A Room",
                            style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      child: Center(
                        child: Text(
                          "A Housemate",
                          style: GoogleFonts.nunito(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold),
=======
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
      length: _currentIndex == 1 ? 1 :2,
      child: Scaffold(
        body: _currentIndex == 1 ? ChatListScreen() : NestedScrollView(
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
                              unselectedLabelColor: Colors.blueGrey.shade700,
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
                                style: Theme.of(context).textTheme.headline2,
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
>>>>>>> b5147c9f1e2ed5393d790b7f8ebf3f0061e2dfb7
                        ),
                      ),
                    ),
<<<<<<< HEAD
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 29,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Recommended',
              style: GoogleFonts.nunito(
                  fontSize: 25,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  apartment: Apartment(
                      titleText: "Two BedRoom",
                      apartmentId: '0101',
                      amenities: ['water', "Stable power,Security"],
                      imageUrls: [
                        "https://q-cf.bstatic.com/images/hotel/max1024x768/162/162892055.jpg",
                        'https://images.nigeriapropertycentre.com/properties/images/395512/2541977_395512-exquisite-3-bedroom-bungalow-with-two-room-self-contained-apartment-all-on-ample-grounds-in-iyaganku-gra-detached-bungalows-for-sale-iyaganku-ibadan-oyo-.JPG',
                      ],
                      rules: ["No smoking,No late night"],
                      price: 30),
                ),
=======
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return Text(
                              'There was an error trying to get apartments');
                        }

                        if (snapshot.hasData) {
                          return columnBuilder(
                            context: context,
                            itemBuilder: (BuildContext context, int index) =>
                                ApartmentCard(apartment: snapshot.data[index]),
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
                  child: Text('Tab two'),
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
              icon: Icon(Icons.home,),
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
>>>>>>> b5147c9f1e2ed5393d790b7f8ebf3f0061e2dfb7
              ),
            ),
<<<<<<< HEAD
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 200,
              child: Container(
                child: TopDisplay(
                  price: "200,00",
                  imageUrl:
                      "https://q-cf.bstatic.com/images/hotel/max1024x768/162/162892055.jpg",
                ),
=======
            BottomNavigationBarItem(
              icon: Icon(
                Icons.face,
>>>>>>> b5147c9f1e2ed5393d790b7f8ebf3f0061e2dfb7
              ),
            ),
          )
        ],
      ),
    );
  }
}
