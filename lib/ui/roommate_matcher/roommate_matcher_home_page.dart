import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roommatematcher/core/blocs/auth_bloc.dart';
import 'package:roommatematcher/core/models/house.dart';
import 'package:roommatematcher/ui/roommate_matcher/apartment_details_page.dart';
import 'package:roommatematcher/ui/roommate_matcher/search_results.dart';

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
                        ),
                      ),
                    ),
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
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 200,
              child: Container(
                child: TopDisplay(
                  price: "200,00",
                  imageUrl:
                      "https://q-cf.bstatic.com/images/hotel/max1024x768/162/162892055.jpg",
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
