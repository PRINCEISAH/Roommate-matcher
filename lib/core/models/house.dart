import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roommatematcher/core/models/user.dart';

// TODO: Implement fromSnapshot, fromMap and toMap methods

class Apartment {
  final String titleText, description;
  String apartmentId;
  final num price;

  // TODO: Change to location instance so distance can be calculated
  final GeoPoint location;
  final User owner;
  final DateTime dateTime;
  final List<String> amenities, rules, imageUrls;
  final DocumentReference reference;

  Apartment(
      {this.reference,
      this.apartmentId,
      this.price,
      this.location: const GeoPoint(1, 1),
      this.amenities: const [],
      this.dateTime,
      this.owner,
      this.titleText: '-',
      this.description,
      this.rules: const [],
      this.imageUrls});

  Apartment.fromMap(Map data, {this.apartmentId, this.reference, this.owner})
      : price = data['price'],
        location = data['location'] ?? GeoPoint(1, 1),
        amenities = List<String>.from(data['amenities']),
        dateTime = data['dateTime'].toDate(),
        titleText = data['titleText'],
        description = data['description'],
        rules = List<String>.from(data['rules']),

        // TODO: Change field name in database
        imageUrls = List<String>.from(data['imageUrls']);

  Apartment.fromSnapshot(DocumentSnapshot snapshot,User owner)
      : this.fromMap(snapshot.data,
            apartmentId: snapshot.documentID,
            reference: snapshot.reference,
            owner: owner);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['price'] = this.price;
    data['location'] = this.location;
    data['amenities'] = this.amenities;
    data['dateTime'] = Timestamp.fromDate(this.dateTime);
    data['titleText'] = this.titleText;
    data['description'] = this.description;
    data['rules'] = this.rules;

    // TODO: Change field name in database
    data['imageUrls'] = this.imageUrls;
    data['owner'] = this.owner.reference;

    return data;
  }

  // TODO: Properly implement distance getter
  get distance => '1.5 miles';

  get imageUrl => this.imageUrls == null ? null : this.imageUrls[0];

  // TODO: Properly implement longAgo getter
  get longAgo => '18 hours';
}

