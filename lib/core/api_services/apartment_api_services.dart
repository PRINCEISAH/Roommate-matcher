import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:roommatematcher/core/models/house.dart';
import 'package:roommatematcher/core/api_services/user_api_services.dart';

final apartmentDBReference = Firestore.instance.collection('apartments');

class ApartmentApiService {
  static Future<Apartment> getApartment(String id) async {
    try {
      DocumentSnapshot apartmentDoc =
          await apartmentDBReference.document(id).get();
      if (!apartmentDoc.exists) {
        throw "Apartment not found";
      }
      return Apartment.fromSnapshot(
          apartmentDoc,
          (await UserApiService.getUserFromReference(
              apartmentDoc.data['owner'])));
    } on PlatformException {
      throw "Failed to get apartment because of poor network connection";
    }
  }

  static Future<Apartment> updateApartment(
      Apartment apartment, Map<String, dynamic> updateData) async {
    await apartment.reference.updateData(updateData);

    return getApartment(apartment.apartmentId);
  }

  static Future<Apartment> saveApartment(Apartment apartment) async {
    DocumentReference newApartmentRef = apartmentDBReference.document();
    await newApartmentRef.setData(apartment.toMap());
    return getApartment(newApartmentRef.documentID);
  }

  static Future<List<Apartment>> getAllApartments(
      {String apartmentId, List<String> apartmentIds}) async {
    QuerySnapshot apartmentSnapshot;
    apartmentSnapshot = await apartmentDBReference.getDocuments();
    final apartmentSnaplist = apartmentSnapshot.documents;
    List<Apartment> apartments;
    if (apartmentId != null) {
      apartments = await Future.wait((apartmentSnaplist
            ..removeWhere((docSnap) => docSnap.documentID == apartmentId))
          .map((docSnap) async => Apartment.fromSnapshot(
                docSnap,
                (await UserApiService.getUserFromReference(
                    docSnap.data['owner'])),
              )));
    } else if (apartmentIds != null) {
      apartments = await Future.wait((apartmentSnaplist
            ..removeWhere(
                (docSnap) => apartmentIds.contains(docSnap.documentID)))
          .map((docSnap) async => Apartment.fromSnapshot(
                docSnap,
                (await UserApiService.getUserFromReference(
                    docSnap.data['owner'])),
              )));
    } else {
      apartments = await Future.wait(
          apartmentSnaplist.map((docSnap) async => Apartment.fromSnapshot(
                docSnap,
                (await UserApiService.getUserFromReference(
                    docSnap.data['owner'])),
              )));
    }
    return apartments;
  }

  static Future<List<Apartment>> getAllApartmentsWithFilter(
      {GeoPoint location, num maxPrice, num minPrice}) async {
    List<Apartment> apartments = await getAllApartments();
    return apartments.where((element) {
      if (minPrice == null || minPrice < 0) {
        minPrice = 0;
      }
      if (maxPrice == null || minPrice < 0) {
        maxPrice = double.infinity;
      }

      // TODO: Add location conditional

      return element.price <= maxPrice && element.price >= minPrice;
    }).toList();
  }
}
