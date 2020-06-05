import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommatematcher/ui/apartment_create/state/apartment_provider.dart';

class ApartmentCreateStep1 extends StatefulWidget {
  final BuildContext context;

  const ApartmentCreateStep1({Key key, this.context}) : super(key: key);
  @override
  _ApartmentCreateStep1State createState() => _ApartmentCreateStep1State();
}

class _ApartmentCreateStep1State extends State<ApartmentCreateStep1> {
  TextEditingController _entryController;
  num _maxPriceToAllow = 1000000;

  ApartmentProvider apartmentProvider;
  double value;

  @override
  initState() {
    super.initState();
    apartmentProvider = Provider.of<ApartmentProvider>(widget.context);
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
    apartmentProvider = Provider.of<ApartmentProvider>(context);
    value = apartmentProvider.price ?? 0;
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
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
                    child: TextFormField(
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
                      Text("$value"),
                    ],
                  ),
                  Slider(value: value, onChanged: (value) {
                    setState(() {
                      value = value;
                      apartmentProvider.price = value;
                    });
                  }, min: 0, max: _maxPriceToAllow.toDouble(), divisions: _maxPriceToAllow ~/ 10,),
                  
                ],
              ),
            ],
          ),
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
