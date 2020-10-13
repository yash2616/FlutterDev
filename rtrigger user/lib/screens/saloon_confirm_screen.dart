import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user/auth/auth.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/models/profile.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/loading_bar.dart';
import 'dart:math' as Math;

class SaloonConfirmScreen extends StatefulWidget {
  final String name;
  final String location;
  final String service;
  final price;
  final uid;
  final DateTime dateTime;
  final Cards category;
  SaloonConfirmScreen(this.service, this.price, this.uid, this.dateTime,
      this.name, this.location, this.category);

  @override
  _SaloonConfirmScreenState createState() => _SaloonConfirmScreenState();
}

class _SaloonConfirmScreenState extends State<SaloonConfirmScreen> {
  Auth auth = Auth();
  UserProfile profile;
  Razorpay _razorpay;
  String username;
  int number;
  bool isLoading = true;
  final _collectionName = 'vendorSaloonTemp';
  DocumentReference _firestore;
  final _orderId = Math.Random().nextInt(1000000000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(context, false, 'Confirm Appointment'),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingBar();
          } else {
            final extractedDateTime =
                (snapshot.data.data()['cDate'] as Timestamp).toDate();
            final customerDateTime =
                DateFormat.yMMMEd().add_jm().format(extractedDateTime);

            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 18,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            child: Text(
                              snapshot.data.data()['name'].toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                              'Order ID : ${snapshot.data.data()['orderID']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              'Price : ${snapshot.data.data()['price']} Rs',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              'Service : ${snapshot.data.data()['service']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              'Your Date and Time : $customerDateTime',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              snapshot.data.data()['vDate'] ==
                                      'Waiting For Response'
                                  ? '${snapshot.data.data()['name'].toString()} Time : Waiting For Response'
                                  : '${snapshot.data.data()['name'].toString()} Time : ${DateFormat.yMMMEd().add_jm().format((snapshot.data.data()['vDate'] as Timestamp).toDate())}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await _firestore
                                        .update({'status': 'Closed'});
                                  },
                                  child: Text('Cancel'),
                                  color: Colors.blueGrey,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: snapshot.data.data()['vDate'] ==
                                          'Waiting For Response'
                                      ? null
                                      : () async {
                                           makePayment();
                                        },
                                  child: Text('Accept'),
                                  color: Colors.blueGrey,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Status - ${snapshot.data.data()['status']}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

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
    auth.getProfile().whenComplete(() {
      profile = auth.profile;
      username = profile.username;
      number = profile.phone;
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

    if (widget.category == Cards.male)
      category = 'Male';
    else if (widget.category == Cards.female)
      category = 'Female';
    else if (widget.category == Cards.unisex)
      category = 'Unisex';
    else if (widget.category == Cards.spa) category = 'Spa';

    _firestore =
        FirebaseFirestore.instance.collection(_collectionName).doc(widget.uid);
    _firestore.set({
      'name': widget.name,
      'service': widget.service,
      'location': widget.location,
      'price': widget.price,
      'cDate': widget.dateTime,
      'orderID': _orderId,
      'status': 'Open',
      'vDate': 'Waiting For Response',
      'category': category,
      'cname': username,
      'phone': number,
    });
  }

  Future<void> makePayment() async {
    var options = {
      'key': 'rzp_live_LAc1m0adUgWrmv',
      'amount': widget.price * 100, //in paise so * 100
      'name': 'Rtiggers',
      'description': 'Order Payment for id - ' +
          profile.username +
          widget.price.toString(),
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
}
