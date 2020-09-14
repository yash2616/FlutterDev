import 'package:android_intent/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/models/food_category_list.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/food_category_card.dart';

class FoodScreen extends StatefulWidget {
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  List<dynamic> _listItem = FoodCategoryList().foodItems;
  List imageArray = List();
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;

  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (granted!=true) {
      requestLocationPermission();
    }
    debugPrint('requestContactsPermission $granted');
    return granted;
  }

  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Can't get current location"),
                content:const Text('Please make sure you enable GPS and try again'),
                actions: <Widget>[
                  FlatButton(child: Text('Ok'),
                      onPressed: () {
                        final AndroidIntent intent = AndroidIntent(
                            action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                        intent.launch();
                        Navigator.of(context, rootNavigator: true).pop();
                        _gpsService();
                      })],
              );
            });
      }
    }
  }
  /*Check if gps service is enabled or not*/
  Future _gpsService() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      _checkGps();
      return null;
    } else
      return true;
  }
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    _gpsService();
    print("Food screen");
    getImages();
  }

  Future<void> getImages() async {
    final User user = FirebaseAuth.instance.currentUser;
    var auth = FirebaseFirestore.instance;
    await auth
        .collection('displayImages')
        .doc('VRxueMwcdcW4VmDR721r')
        .get()
        .then((value) {
          imageArray = value.data()['foodMenu'];
        });
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    getImages();
    return Scaffold(
      appBar: UniversalAppBar(context, true, "Food Category"),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: _listItem
                    .map((item) => FoodCategoryCard(
                          image: item["image"],
                          index: item["index"],
                          foodName: item["foodName"],
                        ))
                    .toList(),
              ),
              SizedBox(height: 10,),
              Expanded(
                flex: 1,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    //pauseAutoPlayOnTouch: Duration(seconds: 10),
                    aspectRatio: 2.0,
                  ),
                  items: imageArray.map((url) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.grey[300],
                          child: CachedNetworkImage(
                            imageUrl: url,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                CircularProgressIndicator(value: downloadProgress.progress),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover
                          )
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
