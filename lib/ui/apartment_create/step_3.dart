import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommatematcher/ui/apartment_create/state/apartment_provider.dart';

class ApartmentCreateStep3 extends StatefulWidget {
  @override
  _ApartmentCreateStep3State createState() => _ApartmentCreateStep3State();
}

class _ApartmentCreateStep3State extends State<ApartmentCreateStep3> {
  TextEditingController _entryController;

  ApartmentProvider apartmentProvider;

  @override
  initState() {
    super.initState();
    apartmentProvider = Provider.of<ApartmentProvider>(context);
    _entryController = TextEditingController();
  }

  bool validate() {
    if (apartmentProvider.amenities.isNotEmpty) {
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
            Wrap(
              runSpacing: 10,
              children: List.generate(
                apartmentProvider.amenities.length,
                (index) => Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        apartmentProvider.amenities[index],
                        softWrap: true,
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          apartmentProvider.amenities.removeAt(index);
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
                              apartmentProvider.amenities
                                  .add(content);
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
