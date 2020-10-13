import 'dart:math' as Math;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:user/auth/auth.dart';
import 'package:user/models/apptheme.dart';
import 'package:user/models/profile.dart';

class PrePayment extends StatefulWidget {
  final int total;
  final items;

  const PrePayment({this.total, this.items});

  @override
  _PrePaymentState createState() => _PrePaymentState();
}

class _PrePaymentState extends State<PrePayment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TwilioFlutter twilioFlutter; // declare it in class
  Auth auth = Auth();
  UserProfile profile;
  Razorpay _razorpay;
  bool isLoading = true;
  String address;
  String city;
  String state;
  int phoneno;
  int _orderNo;
  Position position;

  void _handlePaymentError(PaymentFailureResponse response) async {
    await showDialog(
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
    twilioFlutter.sendSMS(
        toNumber: '+917080855524',
        messageBody: "Your order has been submitted successfully.");

    for (int i = 0; i < widget.items.length; i++) {
      var orders = await FirebaseFirestore.instance
          .collection("vendorOrder")
          .doc(widget.items[i]['vendorId'])
          .get();
      int min = 100000; //min and max values act as your 6 digit range
      int max = 999999;
      var randomizer = new Random();
      var otp1 = min + randomizer.nextInt(max - min);
      var otp2 = min + randomizer.nextInt(max - min);
      var newOrders =
          orders.data()["newOrder"] != null ? orders.data()["newOrder"] : [];
      var preparingOrders =
          orders.data()["preparing"] != null ? orders.data()["preparing"] : [];
      var readyOrders =
          orders.data()["ready"] != null ? orders.data()["ready"] : [];
      var pickedOrders =
          orders.data()["picked"] != null ? orders.data()["picked"] : [];
      var pastOrders =
          orders.data()["past"] != null ? orders.data()["past"] : [];

      newOrders.add({
        'clat': position.latitude,
        'clong': position.longitude,
        'address': address,
        'city': city,
        'state': state,
        'id': _orderNo.toString(),
        'cid': profile.userId,
        'cphone': phoneno,
        'customer': profile.username,
        'otp1': otp1,
        'otp2': otp2,
        'type': 'New Order',
        'item': widget.items[i]['item'],
        'price': widget.items[i]['price'],
        'quantity': widget.items[i]['quantity']
      });

      await FirebaseFirestore.instance
          .collection("vendorOrder")
          .doc(widget.items[i]['vendorId'])
          .set({
        "preparing": preparingOrders,
        "ready": readyOrders,
        "picked": pickedOrders,
        "newOrder": newOrders,
        "past": pastOrders
      });
    }

    await showDialog(
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
    twilioFlutter = TwilioFlutter(
        // use this is initState
        accountSid: 'ACf92727637c508823923593bdecca8214',
        // replace *** with Account SID
        authToken: '3d485cb371e4c710c683d0445ab487c1',
        // replace xxx with Auth Token
        twilioNumber: '+14063456569' //
        );

    auth.getProfile().whenComplete(() {
      profile = auth.profile;
      address = profile.address;
      phoneno = profile.phone;
      city = profile.city;
      state = profile.state;
      _orderNo = Math.Random().nextInt(100000000);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> makePayment() async {
    var options = {
      'key': 'rzp_live_LAc1m0adUgWrmv',
      'amount': widget.total * 100, //in paise so * 100
      'name': 'Rtiggers',
      'description': 'Order Payment for id - #' + _orderNo.toString(),
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

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void validateAndSave() async {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
      await geolocator.checkGeolocationPermissionStatus();
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position);
      makePayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Order Details",
          style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Customer Name: ",
                              style: TextStyle(fontSize: 18),
                            ),
                            Spacer(),
                            Flexible(
                                child: Text(
                              profile.username,
                              style: TextStyle(fontSize: 18),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Order ID: ",
                              style: TextStyle(fontSize: 18),
                            ),
                            Spacer(),
                            Text(
                              '#' + _orderNo.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Total Amount: ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Text(
                              '₹ ' + widget.total.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            decoration: InputDecoration(labelText: 'Address'),
                            initialValue: address,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.multiline,
                            onSaved: (value) {
                              address = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid address.';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            decoration: InputDecoration(labelText: 'City'),
                            initialValue: city,
                            textCapitalization: TextCapitalization.words,
                            onSaved: (value) {
                              city = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a your city name.';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            decoration: InputDecoration(labelText: 'State'),
                            initialValue: state,
                            textCapitalization: TextCapitalization.words,
                            onSaved: (value) {
                              state = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your state name.';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            decoration: InputDecoration(labelText: 'Phone'),
                            initialValue: phoneno.toString(),
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              setState(() {
                                phoneno = int.parse(value);
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty ||
                                  int.parse(value) < 6000000000 ||
                                  int.parse(value) > 9999999999) {
                                return 'Please enter valid phone number';
                              }
                              return null;
                            }),
                      ],
                    ),
                  ),
          ),
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
              validateAndSave();
            },
            //Implement Route To Payment Here
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Total: ₹ " + widget.total.toString(),
                  style: TextStyle(color: Colors.green),
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Make Payment".toUpperCase()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
