import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/loading_bar.dart';
import 'package:user/widgets/saloon_vendor_listtile.dart';

class SaloonVendorListScreen extends StatefulWidget {
  final Cards category;
  SaloonVendorListScreen(this.category);

  @override
  _SaloonVendorListScreenState createState() => _SaloonVendorListScreenState();
}

class _SaloonVendorListScreenState extends State<SaloonVendorListScreen> {
  String _collectionName;
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
    // TODO: implement initState
    super.initState();
    requestLocationPermission();
    _gpsService();
  }
  @override
  Widget build(BuildContext context) {
    switch (widget.category) {
      case Cards.male:
        _collectionName = 'vendorSaloonMen';
        break;

      case Cards.female:
        _collectionName = 'vendorSaloonFemale';
        break;

      case Cards.unisex:
        _collectionName = 'vendorSaloonUnisex';
        break;

      case Cards.spa:
        _collectionName = 'vendorSaloonSpa';
        break;
    }

    return Scaffold(
      appBar: UniversalAppBar(context,false,"Vendor List"),
      body: FutureBuilder<List<Map>>(
        future: listOfVendors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingBar();
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  if (snapshot.data[index]['distance'] < 10) {
                    return SaloonVendorListTile(
                        category: widget.category,
                        vendorName: snapshot.data[index]['name'],
                        kmFar: snapshot.data[index]['distance'],
                        location: snapshot.data[index]['location'],
                        uid: snapshot.data[index]['uid'],
                        servicesList: snapshot.data[index]['services']);
                  }
                  else {
                    return null;
                  }
                }
            );
          }
        },
      ),
    );
  }

  Future<List<Map>> listOfVendors() async {
    final myLocation = await Geolocator().getCurrentPosition();
    final myLatitude = myLocation.latitude;
    final myLongitude = myLocation.longitude;
    List<Map> list = [];

    final snapshot =
        await FirebaseFirestore.instance.collection(_collectionName).get();

    for (var saloonVendor in snapshot.docs) {
      final latitude = saloonVendor.data()['latitude'] as double;
      final longitude = saloonVendor.data()['longitude'] as double;

      final distanceInMeter =
          await getDistance(myLatitude, myLongitude, latitude, longitude);
      final distance = distanceInMeter / 1000;
      final item = {
        'uid': saloonVendor.data()['uid'],
        'latitude': saloonVendor.data()['latitude'],
        'longitude': saloonVendor.data()['longitude'],
        'distance': distance,
        'name': saloonVendor.data()['name'],
        'location': saloonVendor.data()['location'],
        'services': saloonVendor.data()['services'] as List,
      };
      list.add(item);
    }
    return list;
  }

  Future<double> getDistance(
      myLatitude, myLongitude, latitude, longitude) async {
    final distance = await Geolocator()
        .distanceBetween(myLatitude, myLongitude, latitude, longitude);
    return distance;
  }
}
