import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:roommatematcher/core/api_services/apartment_api_services.dart';
import 'package:roommatematcher/core/models/house.dart';

class ApartmentProvider with ChangeNotifier {
  Apartment _createApartment;
  int _currentPage = 0;
  ApartmentProvider();
  final PageController _pageViewController = PageController();
  List<Asset> selectedPhotos = <Asset>[];
  String titleText, description;
  num price;
  List<String> amenities, rules;

  PageController get pageViewController => _pageViewController;

  Future<void> _uploadImages() async {
    for (Asset asset in selectedPhotos) {
      ByteData imageByteData = await asset.getByteData();
      List<int> uploadData = imageByteData.buffer.asUint8List();
      StorageReference uploadReference = FirebaseStorage.instance.ref().child('images').child('im-${asset.name}');
      StorageUploadTask uploadTask = uploadReference.putData(uploadData);


      await uploadTask.onComplete;
      var downloadUrl = await uploadReference.getDownloadURL();
      _createApartment.imageUrls.add(downloadUrl);
    }
  }

  Future<void> completeCreation() async {
    print('Completing creation here\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Completed');
    // await _uploadImages();
    // await ApartmentApiService.saveApartment(_createApartment);
  }

  Future goToPrevious() async {
    await _pageViewController.previousPage(duration: Duration(milliseconds: 500,), curve: Curves.easeInOut);
    _currentPage =  _pageViewController.page as int;
    notifyListeners();
  }

  Future goToNext() async {
    await _pageViewController.nextPage(duration: Duration(milliseconds: 500,), curve: Curves.easeInOut);
    _currentPage =  _pageViewController.page as int;
    notifyListeners();
  }

  int get currentPage => _currentPage;
}