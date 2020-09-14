/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/loading_bar.dart';

class MedicalBargainScreen extends StatefulWidget {
  final String uid;
  final String name;
  final String location;
  final String url;
  final String description;

  MedicalBargainScreen(
      {@required this.name,
        @required this.location,
        @required this.url,
        @required this.description,
        @required this.uid});

  @override
  _MedicalBargainScreenState createState() => _MedicalBargainScreenState();
}

class _MedicalBargainScreenState extends State<MedicalBargainScreen> {
  final _collectionName = 'MedicalTemp';
  final _orderNo = Math.Random().nextInt(1000000000);
  DocumentReference _firestore;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _myPriceTextController = TextEditingController();

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
                                      snapshot.data.data()['name'].toString(),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    child: Text(
                                      'Current Price : ${snapshot.data.data()['vPrice']} Rs',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Text(
                                      snapshot.data.data()['cPrice'] == null
                                          ? 'Your Price : 0 Rs'
                                          : 'Your Price : ${snapshot.data.data()['cPrice']} Rs',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                                  focusColor: Color.fromRGBO(
                                                      00, 44, 64, 1.0),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20)))),
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
                                          color:
                                          Color.fromRGBO(00, 44, 64, 1.0),
                                          onPressed: snapshot.data
                                              .data()['cPrice']
                                              .toString() !=
                                              snapshot.data
                                                  .data()['vPrice']
                                                  .toString() &&
                                              snapshot.data
                                                  .data()['cPrice']
                                                  .toString() !=
                                                  '0' ||
                                              _myPriceTextController.text !=
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
                                          color:
                                          Color.fromRGBO(00, 44, 64, 1.0),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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

  @override
  void initState() {
    super.initState();
    _firestore =
        FirebaseFirestore.instance.collection(_collectionName).doc(widget.uid);
    _firestore.set({
      'date': DateTime.now(),
      'id': _orderNo,
      'name': widget.name,
      'location': widget.location,
      'url': widget.url,
      'description': widget.description,
      'vPrice': 0,
      'cPrice': 0,
      'status': 'open',
    });
  }
}
*/
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/auth/auth.dart';
import 'package:user/models/profile.dart';
import 'package:user/screens/prepayment_screen.dart';
import 'dart:math' as Math;

import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/loading_bar.dart';

class MedicalBargainScreen extends StatefulWidget {
  final String uid;
  final String name;
  final String location;
  final String url;
  final String description;

  MedicalBargainScreen(
      {@required this.name,
      @required this.location,
      @required this.url,
      @required this.description,
      @required this.uid});

  @override
  _MedicalBargainScreenState createState() => _MedicalBargainScreenState();
}

class _MedicalBargainScreenState extends State<MedicalBargainScreen> {
  String _collectionName;
  final _orderNo = Math.Random().nextInt(1000000000);
  DocumentReference _firestore;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _myPriceTextController = TextEditingController();
  Auth auth = Auth();
  UserProfile profile;
  bool loading = true;

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
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        child: Text(
                                          snapshot.data
                                              .data()['name']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        child: Text(
                                          snapshot.data.data()['location'] ==
                                                  null
                                              ? 'Unknown'
                                              : snapshot.data
                                                  .data()['location'],
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        child: Text(
                                          'Current Price : ${snapshot.data.data()['vPrice']} Rs',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        child: Text(
                                          snapshot.data.data()['cPrice'] == null
                                              ? 'Your Price : 0 Rs'
                                              : 'Your Price : ${snapshot.data.data()['cPrice']} Rs',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                              controller:
                                                  _myPriceTextController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  focusColor: Color.fromRGBO(
                                                      00, 44, 64, 1.0),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(20))),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20))),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(20)))),
                                            )),
                                            IconButton(
                                              tooltip: 'Tap for Update',
                                              icon: Icon(Icons.check),
                                              onPressed: () async {
                                                await _firestore.update({
                                                  'cPrice': int.parse(
                                                      _myPriceTextController
                                                          .text)
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
                                              color: Color.fromRGBO(
                                                  00, 44, 64, 1.0),
                                              onPressed: snapshot.data
                                                                  .data()[
                                                                      'cPrice']
                                                                  .toString() !=
                                                              snapshot.data
                                                                  .data()[
                                                                      'vPrice']
                                                                  .toString() &&
                                                          snapshot.data
                                                                  .data()[
                                                                      'cPrice']
                                                                  .toString() !=
                                                              '0' ||
                                                      _myPriceTextController
                                                              .text !=
                                                          '0'
                                                  ? () async {
                                                      if (_myPriceTextController
                                                          .text.isNotEmpty) {
                                                        await _firestore
                                                            .update({
                                                          'cPrice': double.tryParse(
                                                              _myPriceTextController
                                                                  .text),
                                                        });
                                                        _scaffoldKey
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
                                                          content: Text(
                                                              'Please Wait for Vendor Response'),
                                                        ));
                                                      } else {
                                                        _scaffoldKey
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
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
                                              color: Color.fromRGBO(
                                                  00, 44, 64, 1.0),
                                              onPressed: snapshot.data
                                                              .data()['vPrice']
                                                              .toString() ==
                                                          _myPriceTextController
                                                              .text &&
                                                      snapshot.data.data()[
                                                              'vPrice'] !=
                                                          0
                                                  ? () {
                                                      if (snapshot.data
                                                              .data()['vPrice']
                                                              .toString() ==
                                                          _myPriceTextController
                                                              .text) {
                                                        Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                                builder: (context) =>
                                                                    PrePayment(
                                                                        total: snapshot
                                                                            .data
                                                                            .data()['vPrice'])));
                                                      } else {
                                                        _scaffoldKey
                                                            .currentState
                                                            .showSnackBar(
                                                                SnackBar(
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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

  @override
  void initState() {
    super.initState();
    setState(() {

    });
    _collectionName = 'MedicalTemp';
    auth.getProfile().whenComplete(() {
      profile = auth.profile;
      _firestore = FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(widget.uid);
      _firestore.set({
        'date': DateTime.now(),
        'id': _orderNo,
        'name': widget.name,
        'location': widget.location,
        'url': widget.url,
        'description': widget.description,
        'vPrice': 0,
        'cPrice': 0,
        'status': 'open',
        'cname': profile.username,
        'address': profile.address,
        'cphone': profile.phone
      });
    });
    Timer(Duration(seconds: 2, milliseconds: 200), () {
      setState(() {
        loading = false;
      });
    });
  }
}
