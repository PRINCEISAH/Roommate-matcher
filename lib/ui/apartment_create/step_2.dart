import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommatematcher/ui/apartment_create/state/apartment_provider.dart';

class ApartmentCreateStep2 extends StatefulWidget {
  @override
  _ApartmentCreateStep2State createState() => _ApartmentCreateStep2State();
}

class _ApartmentCreateStep2State extends State<ApartmentCreateStep2> {
  TextEditingController _descriptionController;

  ApartmentProvider apartmentProvider;

  @override
  initState() {
    super.initState();
    apartmentProvider = Provider.of<ApartmentProvider>(context);
    _descriptionController = TextEditingController(text: apartmentProvider.titleText);
  }

  bool validate() {
    String content = _descriptionController.text.trim();
    if (content != '') {
      apartmentProvider.description = content;
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListView(
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
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Description',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: <Widget>[
            FlatButton(
              onPressed: apartmentProvider.goToPrevious,
              child: Text('< Prev'),
            ),
            Spacer(),
            FlatButton(
              onPressed: () {
                if (this.validate()) {
                  apartmentProvider.goToNext();
                }
              },
              child: Text('Next >'),
            ),
          ],
        ),
      ],
    );
  }
}
