import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:roommatematcher/ui/apartment_create/state/apartment_provider.dart';

class ApartmentCreateStep5 extends StatefulWidget {
  @override
  _ApartmentCreateStep5State createState() => _ApartmentCreateStep5State();
}

class _ApartmentCreateStep5State extends State<ApartmentCreateStep5> {
  Radius _containerRadius = Radius.circular(10);

  ApartmentProvider apartmentProvider;

  bool validate() {
    if (apartmentProvider.selectedPhotos.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  initState() {
    super.initState();
  }

  void _pickImages() async {
    List<Asset> _pickedImages = await MultiImagePicker.pickImages(
      maxImages: 100,
      selectedAssets: apartmentProvider.selectedPhotos,
    );

    if (_pickedImages != null) {
      setState(() {
        apartmentProvider.selectedPhotos = _pickedImages;
      });
    }
  }

  void _removeImage(int index) {
    if (apartmentProvider.selectedPhotos.length > index && index >= 0) {
      setState(() {
        apartmentProvider.selectedPhotos.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    apartmentProvider = Provider.of<ApartmentProvider>(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 64,
              horizontal: 20,
            ),
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
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
                itemCount: apartmentProvider.selectedPhotos.length + 1,
                primary: false,
              )
            ],
          ),
        ),
        Row(
          children: <Widget>[
            FlatButton(
              onPressed: apartmentProvider.goToPrevious,
              child: Text(
                '< Prev',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                if (this.validate()) {
                  apartmentProvider.completeCreation(context);
                }
              },
              color: Colors.deepOrange,
              textColor: Colors.white,
              child: Text('Let\'s go'),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGridItem(BuildContext context, int index) {
    if (index == this.apartmentProvider.selectedPhotos.length) {
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
          image: AssetThumbImageProvider(
              apartmentProvider.selectedPhotos[index],
              height: 300,
              width: 300),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(_containerRadius),
      ),
      alignment: Alignment.topRight,
    );
  }
}
