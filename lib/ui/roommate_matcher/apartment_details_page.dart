import 'package:flutter/material.dart';
import 'package:roommatematcher/core/models/user.dart';
import 'package:roommatematcher/core/models/house.dart';

class TopDisplay extends StatefulWidget {
  final String price, imageUrl;

  const TopDisplay({Key key, this.price, this.imageUrl}) : super(key: key);

  @override
  _TopDisplayState createState() => _TopDisplayState();
}

class _TopDisplayState extends State<TopDisplay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.network(
            this.widget.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black38, Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  /*child: Text(
                  '1/15',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black45,
                ),*/
                  ),
              Container(
                child: Text(
                  '\$ ${this.widget.price}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DetailPage extends StatefulWidget {
  final Apartment apartment;
  const DetailPage({Key key, this.apartment}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RaisedButton(
                // TODO: Implement contact function
                onPressed: () {},
                color: Colors.black,
                child: Text('Contact'),
                textColor: Colors.white,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 10,
              ),
            ),
          )
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  //TODO: Perform Favourite action
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: TopDisplay(
                price: 'N ${this.widget.apartment.price}/month',
                imageUrl: this.widget.apartment.imageUrl,
              ),
            ),
            expandedHeight: 240,
            pinned: true,
            backgroundColor: Colors.deepOrange,
            elevation: 0,
          )
        ],
        body: ListView(
          padding: EdgeInsets.all(15),
          children: <Widget>[
            Text(
              this.widget.apartment.titleText,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              // TODO: Change to string to layman format of address
              this.widget.apartment.location.toString(),
              style:
                  Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 17),
            ),
            Divider(
              height: 30,
            ),
            OwnerWidget(
              owner: this.widget.apartment.owner,
              time: '${this.widget.apartment.longAgo} ago',
            ),
            Divider(
              height: 30,
            ),
            ApartmentDescriptionWidget(
              description: this.widget.apartment.description,
            ),
            Divider(
              height: 30,
            ),
            AmenitiesWidget(
              amenities: this.widget.apartment.amenities,
            ),
            Divider(
              height: 30,
            ),
            HouseRulesWidget(
              rules: this.widget.apartment.rules,
            )
          ],
        ),
      ),
    );
  }
}

class ApartmentDescriptionWidget extends StatefulWidget {
  final String description;

  const ApartmentDescriptionWidget({Key key, this.description})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ApartmentDescriptionState();
}

class _ApartmentDescriptionState extends State<ApartmentDescriptionWidget> {
  String description;
  bool _isExpanded = false;

  @override
  void initState() {
    description = this.widget.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            description,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
            maxLines: _isExpanded ? null : 6,
            style: TextStyle(
              height: 1.5,
              fontSize: 15,
            ),
            softWrap: true,
          ),
        )
      ],
    );
  }
}

class AmenitiesWidget extends StatelessWidget {
  final List<String> amenities;

  const AmenitiesWidget({Key key, this.amenities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Amenities',
          style: Theme.of(context).textTheme.headline6,
        ),
        AmenityGridView(
          columnCount: 2,
          children: this
              .amenities
              .map((item) => Row(
                    children: <Widget>[
                      Icon(Icons.check),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 8, top: 8, left: 8),
                        child: Text(item),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class AmenityGridView extends StatelessWidget {
  final List<Widget> children;
  final int columnCount;

  const AmenityGridView({Key key, this.children, this.columnCount: 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _columnChildren = [];

    if (this.children.length % columnCount != 0) {
      this.children.addAll(List.generate(
          this.children.length % columnCount, (index) => Container()));
    }

    for (var i = 0; i < this.children.length; i += this.columnCount) {
      _columnChildren.add(Row(
        children: this
            .children
            .getRange(i, i + columnCount)
            .map((item) => Expanded(child: item))
            .toList(),
      ));
    }

    return Column(
      children: _columnChildren,
    );
  }
}

class HouseRulesWidget extends StatelessWidget {
  final List<String> rules;

  const HouseRulesWidget({Key key, this.rules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'House rules',
          style: Theme.of(context).textTheme.headline6,
        ),
        AmenityGridView(
          children: this
              .rules
              .map((rule) => Row(
                    children: <Widget>[
                      Icon(Icons.priority_high),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(rule),
                      ),
                    ],
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class OwnerWidget extends StatelessWidget {
  final User owner;
  final String time;

  const OwnerWidget({Key key, this.owner, this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(this.owner.displayPic),
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
                this.owner.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 3,
              ),
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
      ],
    );
  }
}
