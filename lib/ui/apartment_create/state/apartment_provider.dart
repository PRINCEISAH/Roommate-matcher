import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:roommatematcher/core/api_services/apartment_api_services.dart';
import 'package:roommatematcher/core/models/house.dart';
import 'package:roommatematcher/core/repository/user_repository.dart';
import 'package:roommatematcher/ui/roommate_matcher/apartment_details_page.dart';

class ApartmentProvider with ChangeNotifier {
  UserRepository _userRepository = UserRepository();
  num _currentPage = 0;
  PageController pageViewController = PageController();
  List<Asset> selectedPhotos = <Asset>[];
  String titleText, description;
  num price;
  List<String> amenities = [], rules = [];

  Future<List<String>> _uploadImages(String apartmentId) async {
    List<String> downloadUrls = [];

    for (var i = 0; i < selectedPhotos.length; i++) {
      Asset asset = selectedPhotos[i];
      ByteData imageByteData = await asset.getByteData();
      List<int> uploadData = imageByteData.buffer.asUint8List();
      StorageReference uploadReference = FirebaseStorage.instance.ref().child('images').child('$apartmentId-$i');
      StorageUploadTask uploadTask = uploadReference.putData(uploadData);


      await uploadTask.onComplete;
      var downloadUrl = await uploadReference.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }

  Future<void> completeCreation(BuildContext context) async {
    print('Completing creation here');
    Apartment newApartment = Apartment(
      price: price,
      amenities: amenities,
      dateTime: DateTime.now(),
      owner: await _userRepository.getCurrentUser(),
      titleText: titleText,
      description: description,
      rules: rules,
    );

    newApartment = await ApartmentApiService.saveApartment(newApartment);

    newApartment = await ApartmentApiService.updateApartment(newApartment, {
      'imageUrls': await _uploadImages(newApartment.apartmentId),
    });
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Completed");
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return DetailPage(apartment: newApartment,);
    }),);
  }

  Future goToPrevious() async {
    await pageViewController.previousPage(duration: Duration(milliseconds: 500,), curve: Curves.easeInOut);
    _currentPage =  pageViewController.page;
    notifyListeners();
  }

  Future goToNext() async {
    await pageViewController.nextPage(duration: Duration(milliseconds: 500,), curve: Curves.easeInOut);
    _currentPage =  pageViewController.page;
    notifyListeners();
  }

  num get currentPage => _currentPage;
}