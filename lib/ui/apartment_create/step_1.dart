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
  num _maxPriceToAllow = 100;

  ApartmentProvider apartmentProvider;
  double value = 0.0;

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
              SizedBox(
                height: 20,
              ),
              Text(
                'What\'s the title and price per '
                'month you want to display for your apartment listing?',
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
                    child: Container(
                      color: Colors.grey.shade300,
                      child: TextFormField(
                        controller: _entryController,
                        decoration: InputDecoration(
                          focusColor: Colors.grey,
                          border: OutlineInputBorder(),
                          hintText: 'Title',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Price',
                    style: TextStyle(
                        fontSize: 20, color: Colors.blueGrey.shade700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'N',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 30,
                          decoration: TextDecoration.lineThrough,
                          decorationStyle: TextDecorationStyle.double,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              "${value.round()},000",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        value = value;
                        apartmentProvider.price = value;
                      });
                    },
                    min: 0,
                    max: 500,
                    divisions: _maxPriceToAllow ~/ 10,
                  ),
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
              child: Text(
                'Next >',
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
