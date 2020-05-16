import 'package:flutter/material.dart';

class CircularProgressLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularProgressIndicator(),
      alignment: FractionalOffset.center,
    );
  }
}
