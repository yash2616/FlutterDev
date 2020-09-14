import 'package:flutter/material.dart';
import 'package:user/widgets/add_to_cart_button.dart';

class CartItemCard extends StatefulWidget {
  CartItemCard(
      {this.image,
      this.foodTitle,
      this.time,
      this.distance,
      this.price,
      this.vendorName,
      this.quantity,
      this.productID,
      this.onTap});

  final String image;
  final String foodTitle;
  final int price;
  final String time;
  final String vendorName;
  final int distance;
  final int quantity;
  final String productID;
  final Function onTap;

  @override
  _CartItemCardState createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {

  @override
  void initState() {
    super.initState();
    print(widget.image);
  }


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
                    widget.image,
                    fit: BoxFit.cover,
                  ))),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(widget.foodTitle.toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontWeight: FontWeight.bold,
                          fontSize: 20), textAlign: TextAlign.center,),
                  Divider(),
                  Text(
                    "Rs. ${widget.price} | ${widget.distance} KM",
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(widget.time),
                      Text("(${widget.vendorName})"),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Qty : ${widget.quantity}",
                        style: TextStyle(fontSize: 16),
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: widget.onTap,
                        child: CartButton(
                          title: "Remove",
                        ),
                      ),
                    ],
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
