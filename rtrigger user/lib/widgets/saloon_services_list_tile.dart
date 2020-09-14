import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/auth/auth.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/models/profile.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user/screens/saloon_confirm_screen.dart';

class SaloonServiceListTile extends StatefulWidget {
  final String service;
  final price;
  final String uid;
  final String location;
  final String vendorName;
  final Cards category;

  SaloonServiceListTile(this.service, this.price, this.uid, this.location,
      this.vendorName, this.category);

  @override
  _SaloonServiceListTileState createState() => _SaloonServiceListTileState();
}

class _SaloonServiceListTileState extends State<SaloonServiceListTile> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
        elevation: 7,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.service,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.price.toString() + ' Rs'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                elevation: 4,
                color: Color.fromRGBO(00, 44, 64, 1.0),
                textColor: Colors.white,
                height: screenHeight / 24,
                onPressed: () async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 7)));
//                      lastDate: DateTime(DateTime.now().year,
//                          DateTime.now().month + 1, DateTime.now().day));
                  final time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  final finalDate = DateTime(
                      date.year, date.month, date.day, time.hour, time.minute);
                  if (time != null && date != null)
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => SaloonConfirmScreen(
                            widget.service,
                            widget.price,
                            widget.uid,
                            finalDate,
                            widget.vendorName,
                            widget.location,
                            widget.category)));
                },
                child: Text('Book Now'),
              ),
            ),
          ],
        ));
  }
}
