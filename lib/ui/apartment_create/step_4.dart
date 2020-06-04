import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommatematcher/ui/apartment_create/state/apartment_provider.dart';

class ApartmentCreateStep4 extends StatefulWidget {
  @override
  _ApartmentCreateStep4State createState() => _ApartmentCreateStep4State();
}

class _ApartmentCreateStep4State extends State<ApartmentCreateStep4> {
  TextEditingController _entryController;

  ApartmentProvider apartmentProvider;

  @override
  initState() {
    super.initState();
    apartmentProvider = Provider.of<ApartmentProvider>(context);
    _entryController = TextEditingController();
  }

  bool validate() {
    if (apartmentProvider.rules.isNotEmpty) {
      return true;
    }

    return false;
  }
  @override
  Widget build(BuildContext context) {
    final apartmentProvider = Provider.of<ApartmentProvider>(context);
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
            Wrap(
              runSpacing: 10,
              children: List.generate(
                apartmentProvider.rules.length,
                (index) => Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        apartmentProvider.rules[index],
                        softWrap: true,
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          apartmentProvider.rules.removeAt(index);
                        },
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
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
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          String content = _entryController.text.trim();
                          if (content != '') {
                            setState(() {
                              apartmentProvider.rules.add(content);
                              _entryController.clear();
                            });
                          }
                        },
                      ),
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
