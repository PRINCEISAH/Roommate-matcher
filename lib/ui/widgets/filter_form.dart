import 'package:flutter/material.dart';

class FilterForm extends StatefulWidget {
  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _maxPriceController = TextEditingController();
  TextEditingController _minPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _maxPriceController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    hintText: 'Max Price',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _minPriceController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    hintText: 'Min Price',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
