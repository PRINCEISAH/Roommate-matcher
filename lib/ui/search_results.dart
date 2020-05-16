import 'package:flutter/material.dart';

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
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20,),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                // Yet to implement the function
                // TODO: Implement the filter function
                  icon: Icon(Icons.filter_list), onPressed: () => Container()),
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
          SizedBox(height: 20,),

          // Using static data here
          // TODO: Replace with results from actual search
          ApartmentCard(
            textStmt: 'Looking for a student housemate.',
          ),
          ApartmentCard(
            textStmt: 'Looking for three housemates.',
          ),
          ApartmentCard(
            textStmt: 'Looking for a student housemate.',
          ),
          ApartmentCard(
            textStmt: 'Looking for a student housemate.',
          ),
        ],
      ),
    );
  }
}

class ApartmentCard extends StatelessWidget {
  // TODO: Change variable to Apartment model instance
  final String distance, price, imageUrl, textStmt, time;

  const ApartmentCard(
      {Key key,
        this.distance,
        this.price,
        this.imageUrl,
        this.textStmt,
        this.time})
      : super(key: key);

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
                    this.imageUrl,
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
                              this.distance,
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
                          '\$ ${this.price}',
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
              this.textStmt,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Row(
            children: <Widget>[
              CircleAvatar(
                // TODO: Use appropriate user avatar here
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
                radius: 18,
                backgroundColor: Color(0xffcccccc),
              ),
              SizedBox(width: 8,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      // TODO: Use appropriate user name here
                      'Nathaniel Sanders',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 3,),
                    Text(
                      this.time,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffaaaaaa),
                      ),
                    )
                  ],
                ),
              ),
              // TODO: Implement more button function
              IconButton(icon: Icon(Icons.more_vert), onPressed: () => {})
            ],
          )
        ],
      ),
      margin: EdgeInsets.only(bottom: 20,),
    );
  }
}
