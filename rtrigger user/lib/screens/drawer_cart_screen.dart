import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/auth/auth.dart';
import 'package:user/models/profile.dart';
import 'package:user/screens/prepayment_screen.dart';
import 'package:user/widgets/cart_item_card.dart';
import 'package:user/models/apptheme.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user/services/Food/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodCart extends StatefulWidget {
  final bool isAppbar;

  FoodCart(this.isAppbar);

  @override
  _FoodCartState createState() => _FoodCartState();
}

class _FoodCartState extends State<FoodCart> {
  Auth auth = Auth();
  UserProfile profile;
  Razorpay _razorpay;
  final _userID = FirebaseAuth.instance.currentUser.uid;
  Cart cart = Cart();
  var cartItems = [];
  int totalCart = 0;
  int totalDelivery = 0;
  int totalPay = 0;
  bool isLoading = true;
  int _perKmCharge = 1;
  final _firestore = FirebaseFirestore.instance;

  void _handlePaymentError(PaymentFailureResponse response) async {
    return await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('An Error occured!'),
              content:
                  Text(response.code.toString() + ' - ' + response.message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(_).pop();
                  },
                ),
              ],
            ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {

    return await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Payment Successful.'),
              content: Text(response.paymentId),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(_).pop();
                  },
                ),
              ],
            ));
  }

  @override
  void initState() {
    auth.getProfile().whenComplete(() {
      profile = auth.profile;
      setState(() {
        isLoading = false;
      });
    });
    actualAwaitInit();
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void actualAwaitInit() async{
    await getPerKmCharge();
    getCartData();
  }

  void getPerKmCharge() async {
    // Fetching per km charges for delivery charge calculation.
    var temp = await _firestore.collection("deliveryRate").doc("rates").get();
    _perKmCharge = temp.get("rate");
  }

  Future<void> makePayment() async {
    var options = {
      'key': 'rzp_test_Fs6iRWL4ppk5ng',
      'amount': totalCart * 100, //in paise so * 100
      'name': 'Rtiggers',
      'description':
          'Order Payment for id - ' + profile.username + totalCart.toString(),
      'prefill': {'contact': profile.phone.toString(), 'email': profile.email},
      "method": {
        "netbanking": true,
        "card": true,
        "wallet": false,
        "upi": true,
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void calculateTotal() {
    
    // totalCart => Food total
    // totalDelivery => Delivery charges
    // totalPay => Payable amount
    totalCart = 0;
    totalDelivery = 0;
    print("calculating Total");

    for (int i = 0; i < cartItems.length; i++) {
      setState(() {
        totalCart = totalCart + cartItems[i]["price"] * cartItems[i]["quantity"];
        totalDelivery = totalDelivery + cartItems[i]["distance"] * _perKmCharge;
      });
    }
    totalPay = totalCart+totalDelivery;
  }

  void getCartData() async {
    var temp = await cart.getCartItems(_userID);
    print(temp);
    setState(() {
      cartItems = temp;
      calculateTotal();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isAppbar
          ? AppBar(
              backgroundColor: Colors.blueGrey,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                "Your Cart",
                style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            )
          : AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        title: Text("My Cart"),
        backgroundColor: AppTheme.grey,
      ),
      body:isLoading
            ? Center(child: CircularProgressIndicator())
            : totalCart == 0
                ? Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Nice to have you here..\nFirst add something in cart",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 15),
                    ),
                  )
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return CartItemCard(
                                  vendorName: cartItems[index]["vendor"],
                                  price: cartItems[index]["price"],
                                  foodTitle: cartItems[index]["name"],
                                  distance: cartItems[index]["distance"],
                                  time: "${cartItems[index]["time"]} mins",
                                  image: cartItems[index]["image"],
                                  quantity: cartItems[index]["quantity"],
                                  productID: cartItems[index]["productID"],
                                  onTap: () async {
                                    Cart cart = Cart();
                                    var deleteResult =
                                        await cart.deleteFromCart(
                                            userID: _userID,
                                            productID: cartItems[index]
                                                ["productID"]);
                                    if (deleteResult == true) {
                                      getCartData();
                                      //calculateTotal();
                                    }
                                  },
                                );
                              },
                              itemCount: cartItems.length,
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          color: Colors.orange,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Cart total : ₹ $totalCart"),
                              Text("Delivery charge : ₹ $totalDelivery"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      bottomNavigationBar: BottomAppBar(
        color: AppTheme.dark_grey,
        elevation: 5,
        child: Container(
          child: FloatingActionButton.extended(
            splashColor: AppTheme.darkerText,
            elevation: 5,
            backgroundColor: AppTheme.dark_grey,
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => PrePayment(total: totalPay,items: cartItems)));
            },
            //Implement Route To Payment Here
            label: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Total: ₹ $totalPay ".toUpperCase(),
                      style: TextStyle(color: Colors.green),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Order Now".toUpperCase()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
