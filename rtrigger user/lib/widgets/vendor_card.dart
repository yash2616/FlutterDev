import 'package:flutter/material.dart';
import 'package:user/screens/vendor_food_items_screen.dart';
import 'add_to_cart_button.dart';

class VendorCard extends StatelessWidget {

  VendorCard({this.name,this.image,this.distance,this.type,this.vendorID});

  final String name;
  final String distance;
  final String image;
  final String type;
  final String vendorID;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 60,
                  child: ClipOval(
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ))),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(name.toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Divider(),
                  Text(
                    distance,
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  Divider(),
                  Text(type),
                  FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return VendorFoodItemsScreen(vendorID: vendorID,);
                          }
                      ));
                    },
                    child: CartButton(title: "See items",),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
