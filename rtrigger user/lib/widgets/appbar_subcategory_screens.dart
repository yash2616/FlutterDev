import 'package:flutter/material.dart';
import 'package:user/screens/drawer_cart_screen.dart';

Widget UniversalAppBar(final context,bool isCart,String title) {
  return AppBar(
    backgroundColor: Colors.blueGrey,
    elevation: 0.0,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
          fontSize: 18),
    ),
    actions: <Widget>[
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(height: 10,),
          ],
        ),
      ),
      isCart?IconButton(
        icon: Icon(Icons.add_shopping_cart,color: Colors.white,),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return FoodCart(true);
              }));
        },
        color: Colors.black,
      ):
          SizedBox(width: 1,)
    ],
  );
}
