import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ApartmentCreateStep5 extends StatefulWidget {
  @override
  _ApartmentCreateStep5State createState() => _ApartmentCreateStep5State();
}

class _ApartmentCreateStep5State extends State<ApartmentCreateStep5> {
  List<Asset> _selectedPhotos = <Asset>[];

  Radius _containerRadius = Radius.circular(10);

  Future<void> _uploadImages() async {
    List downloadUrls = [];

    for (Asset asset in _selectedPhotos) {
      ByteData imageByteData = await asset.getByteData();
      List<int> uploadData = imageByteData.buffer.asUint8List();
      StorageReference uploadReference = FirebaseStorage.instance.ref().child('images').child('im-${asset.name}');
      StorageUploadTask uploadTask = uploadReference.putData(uploadData);


      await uploadTask.onComplete;
      var downloadUrl = await uploadReference.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
  }

  void _pickImages() async {
    List<Asset> _pickedImages = await MultiImagePicker.pickImages(
      maxImages: 100,
      selectedAssets: this._selectedPhotos,
    );

    if (_pickedImages != null) {
      setState(() {
        _selectedPhotos = _pickedImages;
      });
    }
  }

  void _removeImage(int index) {
    if (_selectedPhotos.length > index && index >= 0) {
      setState(() {
        _selectedPhotos.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 64,
        horizontal: 20,
      ),
      children: <Widget>[
        Text(
          'Now the final and probably most important step. '
          'PHOTOS of the apartment. Upload admirable '
          'shots of the apartment. (Add blue, I like blue 😋)',
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.blueGrey.shade700,
                height: 1.4,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 50,
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: buildGridItem,
          shrinkWrap: true,
          itemCount: _selectedPhotos.length + 1,
          primary: false,
        )
      ],
    );
  }

  Widget buildGridItem(BuildContext context, int index) {
    if (index == this._selectedPhotos.length) {
      return Container(
        child: DottedBorder(
          strokeWidth: 3,
          color: Colors.blueGrey.shade200,
          borderType: BorderType.RRect,
          radius: _containerRadius,
          dashPattern: [10, 5],
          child: Material(
            child: InkWell(
              onTap: _pickImages,
              child: Container(
                child: Icon(
                  Icons.add_a_photo,
                  size: 40,
                  color: Colors.blueGrey.shade200,
                ),
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      child: IconButton(
        icon: Icon(
          Icons.cancel,
          color: Colors.grey.shade100,
        ),
        onPressed: () {
          _removeImage(index);
        },
      ),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetThumbImageProvider(_selectedPhotos[index],
              height: 300, width: 300),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(_containerRadius),
      ),
      alignment: Alignment.topRight,
    );
  }
}
