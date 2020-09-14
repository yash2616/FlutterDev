/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user/auth/auth.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/models/profile.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'dart:math' as Math;
import 'package:user/widgets/loading_bar.dart';
class SanitizeConfirmScreen extends StatefulWidget {
  final String uid;
  final vendorPrice;
  final pricePerFeet;
  final Cards category;
  final String vendorName;
  final String location;
  SanitizeConfirmScreen(
      {@required this.uid,
      @required this.vendorPrice,
      @required this.pricePerFeet,
      @required this.category,
      @required this.vendorName,
      @required this.location});
  @override
  _SanitizeConfirmScreenState createState() => _SanitizeConfirmScreenState();
}
class _SanitizeConfirmScreenState extends State<SanitizeConfirmScreen> {
  final _myPriceTextController = TextEditingController(text: '0');
  final _orderId = Math.Random().nextInt(1000000000);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _collectionName;
  DocumentReference _firestore;
  Auth auth = Auth();
  UserProfile profile;
  Razorpay _razorpay;
  bool isLoading = true;
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
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    String category;
    if (widget.category == Cards.cockroach)
      category = 'Cockroach';
    else if (widget.category == Cards.sanitize)
      category = 'Sanitize';
    else if (widget.category == Cards.mosquito)
      category = 'Mosquito';
    else
      category = 'Others';
    _collectionName = 'SanitizerVendorTemp';
    _firestore =
        FirebaseFirestore.instance.collection(_collectionName).doc(widget.uid);
    _firestore.set({
      'date': DateTime.now(),
      'id': _orderId,
      'vPrice': widget.vendorPrice,
      'name': widget.vendorName,
      'status': 'open',
      'location': widget.location,
      'cPrice': 0,
      'category': category,
    });
  }
  Future<void> makePayment() async {
    var options = {
      'key': 'rzp_test_Fs6iRWL4ppk5ng',
      'amount': widget.vendorPrice * 100, //in paise so * 100
      'name': 'Rtiggers',
      'description': 'Order Payment for id - ' +
          profile.username +
          widget.vendorPrice.toString(),
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
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(context, false, 'Order'),
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () async {
          await _firestore.update({
            'status': 'closed',
          });
          return true;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              elevation: 7,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                        stream: _firestore.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingBar();
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                    snapshot.data.data()['name'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                    snapshot.data.data()['location'] == null
                                        ? 'Unknown'
                                        : snapshot.data.data()['location'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Order ID : ${snapshot.data.data()['id']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  child: Text(
                                    'Current Price : ${snapshot.data.data()['vPrice']} Rs',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Text(
                                    snapshot.data.data()['cPrice'] == null
                                        ? 'Your Price : 0 Rs'
                                        : 'Your Price : ${snapshot.data.data()['cPrice']} Rs',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Your Price - Rs',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: TextField(
                                        controller: _myPriceTextController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            focusColor:
                                                Color.fromRGBO(00, 44, 64, 1.0),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)))),
                                      )),
                                      IconButton(
                                        tooltip: 'Tap for Update',
                                        icon: Icon(Icons.check),
                                        onPressed: () async {
                                          await _firestore.update({
                                            'cPrice':
                                                _myPriceTextController.text
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      MaterialButton(
                                        textColor: Colors.white,
                                        color: Color.fromRGBO(00, 44, 64, 1.0),
                                        onPressed: snapshot.data
                                                        .data()['cPrice']
                                                        .toString() !=
                                                    snapshot.data
                                                        .data()['vPrice']
                                                        .toString() &&
                                                snapshot.data
                                                        .data()['cPrice']
                                                        .toString() !=
                                                    '0'
                                            ? () async {
                                                if (_myPriceTextController
                                                    .text.isNotEmpty) {
                                                  await _firestore.update({
                                                    'cPrice': double.tryParse(
                                                        _myPriceTextController
                                                            .text),
                                                  });
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Please Wait for Vendor Response'),
                                                  ));
                                                } else {
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                      'Please Enter a Price to Bargain',
                                                    ),
                                                  ));
                                                }
                                              }
                                            : null,
                                        child: Text(
                                          'Bargain',
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      MaterialButton(
                                        color: Color.fromRGBO(00, 44, 64, 1.0),
                                        onPressed: snapshot.data
                                                    .data()['vPrice']
                                                    .toString() ==
                                                _myPriceTextController.text
                                            ? () {
                                                if (snapshot.data
                                                        .data()['vPrice']
                                                        .toString() ==
                                                    _myPriceTextController
                                                        .text) {
                                                  makePayment();
                                                } else {
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Your Entered Price and Current Price must be Same'),
                                                  ));
                                                }
                                              }
                                            : null,
                                        textColor: Colors.white,
                                        child: Text('Accept'),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Status - ${snapshot.data.data()['status']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user/auth/auth.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/models/profile.dart';
import 'package:user/screens/prepayment_screen.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'dart:math' as Math;

import 'package:user/widgets/loading_bar.dart';

class SanitizeConfirmScreen extends StatefulWidget {
  final String uid;
  final vendorPrice;
  final double pricePerFeet;
  final Cards category;
  final String vendorName;
  final String location;
  final String phone;

  SanitizeConfirmScreen(
      {@required this.uid,
      @required this.vendorPrice,
      @required this.pricePerFeet,
      @required this.category,
      @required this.vendorName,
      @required this.location,
      @required this.phone});

  @override
  _SanitizeConfirmScreenState createState() => _SanitizeConfirmScreenState();
}

class _SanitizeConfirmScreenState extends State<SanitizeConfirmScreen> {
  final _myPriceTextController = TextEditingController(text: '0');
  final _orderId = Math.Random().nextInt(1000000000);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _collectionName;
  DocumentReference _firestore;
  Auth auth = Auth();
  UserProfile profile;
  Razorpay _razorpay;
  bool isLoading = true;

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
    String category;
    if (widget.category == Cards.cockroach)
      category = 'Cockroach';
    else if (widget.category == Cards.sanitize)
      category = 'Sanitize';
    else if (widget.category == Cards.mosquito)
      category = 'Mosquito';
    else
      category = 'Others';

    final time =
        DateTime.now().millisecondsSinceEpoch.toString().substring(0, 6);
    final otp = int.parse(time);

//    while (otp.toString().length < 5) {
//      otp = Math.Random().nextInt(100000);
//    }

    _firestore.set({
      'date': DateTime.now(),
      'id': _orderId,
      'vPrice': widget.vendorPrice,
      'vName': widget.vendorName,
      'status': 'open',
      'vLocation': widget.location,
      'vCategory': category,
      'pricePerFeet': widget.pricePerFeet,
      'cName': profile.username,
      'cMobile': profile.phone,
      'cAddress': profile.address,
      'otp': otp
    });
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
    auth.getProfile().then((value) {
      profile = auth.profile;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
    _collectionName = 'SanitizerVendorTemp';
    _firestore =
        FirebaseFirestore.instance.collection(_collectionName).doc(widget.uid);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> makePayment() async {
    var options = {
      'key': 'rzp_live_LAc1m0adUgWrmv',
      'amount': widget.vendorPrice * 100, //in paise so * 100
      'name': 'Rtiggers',
      'description': 'Order Payment for id - ' +
          profile.username +
          widget.vendorPrice.toString(),
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

  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(context, false, 'Order'),
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () async {
          await _firestore.update({
            'status': 'closed',
          });
          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        child: Text(
                          widget.vendorName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        child: Text(
                          widget.location == null ? 'Unknown' : widget.location,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          'Order ID : $_orderId',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          'Shop Phone : ${widget.phone}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          'Total Price : ${widget.vendorPrice} Rs',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(
                              color: Color.fromRGBO(00, 44, 64, 1.0),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              textColor: Colors.white,
                              child: Text('Cancel'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            MaterialButton(
                              color: Color.fromRGBO(00, 44, 64, 1.0),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => PrePayment(
                                            total: widget.vendorPrice)));
                              },
                              textColor: Colors.white,
                              child: Text('Confirm'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
