import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommatematcher/ui/apartment_create/state/apartment_provider.dart';
import 'package:roommatematcher/ui/apartment_create/step_1.dart';
import 'package:roommatematcher/ui/apartment_create/step_2.dart';
import 'package:roommatematcher/ui/apartment_create/step_3.dart';
import 'package:roommatematcher/ui/apartment_create/step_4.dart';
import 'package:roommatematcher/ui/apartment_create/step_5.dart';

class ApartmentCreate extends StatefulWidget {
  @override
  _ApartmentCreateState createState() => _ApartmentCreateState();
}

class _ApartmentCreateState extends State<ApartmentCreate> {
  Widget _buildProgressBar(BuildContext context, ApartmentProvider apartmentProvider, Widget child) {
    num currPage = apartmentProvider.currentPage;
    return Row(
      children: List.generate(9, (index) {
        if (index % 2 != 0) {
          return Expanded(
            child: Divider(),
          );
        }
        int prog = index ~/ 2 + 1;
        return CircleAvatar(
          radius: 10,
          child: Text('$prog'),
          backgroundColor: prog <= currPage ? Colors.green : Colors.grey,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final apartmentProvider = Provider.of<ApartmentProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView(
              children: <Widget>[
                ApartmentCreateStep1(),
                ApartmentCreateStep2(),
                ApartmentCreateStep3(),
                ApartmentCreateStep4(),
                ApartmentCreateStep5(),
              ],
              controller: apartmentProvider.pageViewController,
            ),
            Positioned(
              child: Consumer<ApartmentProvider>(builder: _buildProgressBar),
              top: 15,
              right: 10,
              left: 10,
            ),
            
          ],
        ),
      ),
    );
  }
}
