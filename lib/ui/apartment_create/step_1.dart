import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommatematcher/ui/apartment_create/state/apartment_provider.dart';

class ApartmentCreateStep1 extends StatefulWidget {
  @override
  _ApartmentCreateStep1State createState() => _ApartmentCreateStep1State();
}

class _ApartmentCreateStep1State extends State<ApartmentCreateStep1> {
  TextEditingController _entryController;

  ApartmentProvider apartmentProvider;
  RangeValues _rangeValues;

  @override
  initState() {
    super.initState();
    apartmentProvider = Provider.of<ApartmentProvider>(context);
    _rangeValues = RangeValues(0, apartmentProvider.price ?? 0);
    _entryController = TextEditingController(text: apartmentProvider.titleText);
  }

  bool validate() {
    String content = _entryController.text.trim();
    if (content != '') {
      apartmentProvider.titleText = content;
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
                    controller: _entryController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text('Price'),
                Row(
                  children: <Widget>[
                    Text(
                      'N',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationStyle: TextDecorationStyle.double,
                      ),
                    ),
                    Text("${_rangeValues.end}"),
                  ],
                ),
                RangeSlider(
                  values: _rangeValues,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _rangeValues = values;
                      apartmentProvider.price = values.end;
                    });
                  },
                  max: 1000000,
                ),
              ],
            ),
          ],
        ),
        Row(
          children: <Widget>[
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
