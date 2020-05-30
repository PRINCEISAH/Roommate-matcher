import 'package:flutter/material.dart';
import 'package:roommatematcher/ui/apartment_create/step_5.dart';

class ApartmentCreate extends StatefulWidget {
  @override
  _ApartmentCreateState createState() => _ApartmentCreateState();
}

class _ApartmentCreateState extends State<ApartmentCreate> {
  final PageController _pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView(
              children: <Widget>[
                ApartmentCreateStep5(),
              ],
              controller: _pageViewController,
            ),
            Positioned(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('Page ${_pageViewController.hasClients ? _pageViewController.page : 0}')),
                ],
              ),
              top: 10,
              right: 0,
              left: 0,
            ),
          ],
        ),
      ),
    );
  }
}
