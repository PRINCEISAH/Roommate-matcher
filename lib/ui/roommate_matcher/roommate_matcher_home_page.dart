import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/blocs/auth_bloc.dart';
import 'package:roommatematcher/core/models/house.dart';
import 'package:roommatematcher/ui/roommate_matcher/apartment_details_page.dart';

class RoommateMatcherHomePage extends StatefulWidget {
  @override
  _RoommateMatcherHomePageState createState() =>
      _RoommateMatcherHomePageState();
}

class _RoommateMatcherHomePageState extends State<RoommateMatcherHomePage> {
  @override
  Widget build(BuildContext context) {
    // This is how to get the user anywhere in the widget tree once the person have successfully authenticate
    final user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;
    int _currentIndex = 0;

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

            if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                            apartment: Apartment(
                              apartmentId: "23",
                              amenities: [
                                "water",
                                "light",
                              ],
                              imageUrls: [
                                'https://i.pinimg.com/originals/73/5f/72/735f72927dff9b3904f7da4779d3297e.jpg,',
                                "https://i.pinimg.com/originals/73/5f/72/735f72927dff9b3904f7da4779d3297e.jpg"
                              ],
                              price: 2000,
                            ),
                          )));
            }
          });
        },
      ),
      body: ListView(
        children: <Widget>[
//          DetailPage(
//            apartment: Apartment(apartmentId: "23", amenities: [
//              "water",
//              "light",
//            ], imageUrls: [
//              'https://i.pinimg.com/originals/73/5f/72/735f72927dff9b3904f7da4779d3297e.jpg,',
//              "https://i.pinimg.com/originals/73/5f/72/735f72927dff9b3904f7da4779d3297e.jpg"
//            ]),
//          )
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  apartment: Apartment(
                      description: "two bed room flat with kitchen and toilet",
                      dateTime: DateTime(2020),
                      location: GeoPoint(2, 6),
                      titleText: "Two Bed Room",
                      apartmentId: '01111',
                      amenities: ['water', "Stable power,Security"],
                      imageUrls: [
                        'https://images.nigeriapropertycentre.com/properties/images/395512/2541977_395512-exquisite-3-bedroom-bungalow-with-two-room-self-contained-apartment-all-on-ample-grounds-in-iyaganku-gra-detached-bungalows-for-sale-iyaganku-ibadan-oyo-.JPG',
                        'https://images.nigeriapropertycentre.com/properties/images/395512/2541977_395512-exquisite-3-bedroom-bungalow-with-two-room-self-contained-apartment-all-on-ample-grounds-in-iyaganku-gra-detached-bungalows-for-sale-iyaganku-ibadan-oyo-.JPG',
                      ],
                      rules: ["No smoking,No late night"],
                      price: 30),
                ),
              ),
            ),
            child: Container(
              height: 300,
              child: TopDisplay(
                price: "200,00",
                imageUrl:
                    'https://images.nigeriapropertycentre.com/properties/images/395512/2541977_395512-exquisite-3-bedroom-bungalow-with-two-room-self-contained-apartment-all-on-ample-grounds-in-iyaganku-gra-detached-bungalows-for-sale-iyaganku-ibadan-oyo-.JPG',
              ),
            ),
          )
        ],
      ),
    );
  }
}
