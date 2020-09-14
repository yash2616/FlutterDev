import 'package:flutter/material.dart';
import 'package:user/models/categories_enum.dart';
import '../screens/area_screen.dart';
import '../screens/area_screen.dart';

class SanitizerVendorListItem extends StatelessWidget {
  final String vendorName;
  final String location;
  final String pricePerFeet;
  final Cards category;
  final String uid;
  final String phone;
  SanitizerVendorListItem(
      {@required this.vendorName,
      @required this.location,
      @required this.pricePerFeet,
      @required this.category,
      @required this.uid,
      @required this.phone});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(4),
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
              child: Text(
                vendorName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                '$location',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                'Price Per Sq. Foot : ${pricePerFeet.toString()} Rs',
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
              height: screenHeight / 22,
              minWidth: screenWidth,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AreaScreen(
                          uid: uid,
                          vendorName: vendorName,
                          pricePerFeet: pricePerFeet,
                          location: location,
                          category: category,
                          phone: phone,
                        )));
              },
              child: Text('ORDER NOW'),
            )
          ]),
        ),
      ),
    );
  }
}
