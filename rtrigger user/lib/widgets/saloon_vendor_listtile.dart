import 'package:flutter/material.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/screens/saloon_services_screen.dart';

class SaloonVendorListTile extends StatelessWidget {
  final String vendorName;
  final double kmFar;
  final String location;
  final String uid;
  final List servicesList;
  final Cards category;

  SaloonVendorListTile(
      {@required this.vendorName,
      @required this.kmFar,
      @required this.location,
      @required this.uid,
      @required this.servicesList,
      @required this.category});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    vendorName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    kmFar.toStringAsFixed(1) + ' Km Far',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                '$location',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              elevation: 4,
              color: Color.fromRGBO(00, 44, 64, 1.0),
              textColor: Colors.white,
              height: screenHeight / 24,
              minWidth: screenWidth,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SaloonServicesScreen(
                        servicesList, category, uid, location, vendorName)));
              },
              child: Text('Tap To See Services'),
            )
          ]),
        ),
      ),
    );
  }
}
