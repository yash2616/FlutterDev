import 'package:flutter/material.dart';
import 'package:user/screens/food_items.dart';
import 'package:user/screens/vendor_screen.dart';

class FoodCategoryCard extends StatelessWidget {
  FoodCategoryCard({this.index, this.foodName, this.image});

  final String image;
  final String foodName;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index == 14) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return VendorScreen();
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FoodItems(
              title: foodName,
              index: index,
            );
          }));
        }
      },
      child: Card(
        elevation: 10,
        child: index == 14
            ? Center(
                child: Text(foodName,
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.bold,
                    )))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 5,
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 33,
                        child: ClipOval(
                            child: Image.asset(
                          index == 13 ? 'assets/img/oo.png' : image,
                          fit: BoxFit.cover,
                        ))),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(foodName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'RobotoCondensed',
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ),
                ],
              ),
      ),
    );
  }
}
