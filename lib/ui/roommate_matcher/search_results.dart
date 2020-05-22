import 'package:flutter/material.dart';
import 'package:roommatematcher/core/api_services/apartment_api_services.dart';
import 'package:roommatematcher/core/models/house.dart';
import 'package:roommatematcher/utils/circular_progress_loading.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Search Results'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('There was an error trying to get apartments');
          }

          if (snapshot.hasData) {
            return ListView(
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
                  height: 20,
                ),
              ],
            );
          }

          return CircularProgressLoading();
        },
        future: ApartmentApiService.getAllApartments(),
      ),
    );
  }
}

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentCard({Key key, this.apartment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.network(
                    this.apartment.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              size: 16,
                            ),
                            Text(
                              this.apartment.distance,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        child: Text(
                          '\$ ${this.apartment.price}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          // TODO: Use appropriate color
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  right: 15,
                  top: 15,
                )
              ],
            ),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.hardEdge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              this.apartment.titleText,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(this.apartment.owner.displayPic),
                radius: 18,
                backgroundColor: Color(0xffcccccc),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      // TODO: Use appropriate user name here
                      this.apartment.owner.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      '${this.apartment.longAgo} ago',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffaaaaaa),
                      ),
                    )
                  ],
                ),
              ),
              // TODO: Properly Implement more button function
              PopupMenuButton(
                onSelected: (value) {
                  // TODO: Properly implement favourite function
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text('$value added to favourites')));
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Text('Add to favourites'),
                      value: this.apartment.owner.userId,
                    )
                  ];
                },
              ),
            ],
          )
        ],
      ),
      margin: EdgeInsets.only(
        bottom: 20,
      ),
    );
  }
}
