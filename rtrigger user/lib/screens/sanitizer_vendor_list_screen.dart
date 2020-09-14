import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/loading_bar.dart';
import 'package:user/widgets/sanitizer_vendor_list_item.dart';

class SanitizeVendorListScreen extends StatefulWidget {
  final Cards category;
  SanitizeVendorListScreen(this.category);

  @override
  _SanitizeVendorListScreenState createState() =>
      _SanitizeVendorListScreenState();
}

class _SanitizeVendorListScreenState extends State<SanitizeVendorListScreen> {
  String collectionName = '';

  final PermissionHandler permissionHandler = PermissionHandler();

  Map<PermissionGroup, PermissionStatus> permissions;

  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (granted != true) {
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
                title: Text("Can't get gurrent location"),
                content:
                    const Text('Please make sure you enable GPS and try again'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        final AndroidIntent intent = AndroidIntent(
                            action:
                                'android.settings.LOCATION_SOURCE_SETTINGS');
                        intent.launch();
                        Navigator.of(context, rootNavigator: true).pop();
                        _gpsService();
                      })
                ],
              );
            });
      }
    }
  }

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
    if (widget.category == Cards.sanitize)
      collectionName = 'vendorSanitize';
    else if (widget.category == Cards.cockroach)
      collectionName = 'vendorCockroach';
    else if (widget.category == Cards.mosquito)
      collectionName = 'vendorMosquito';

    return Scaffold(
      appBar: UniversalAppBar(context, false, "Vendor List"),
      body: FutureBuilder<List<Map>>(
        future: listOfVendors(),//FirebaseFirestore.instance.collection(collectionName).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return LoadingBar();
          else {
            return ListView.builder(
                itemCount: snapshot.data.length == 0
                    ? 0
                    : snapshot.data.length,
                itemBuilder: (context, index) {
                  return SanitizerVendorListItem(
                    vendorName: snapshot.data[index]['name'],
                    location: snapshot.data[index]['location'],
                    pricePerFeet: snapshot.data[index]['pricePerFeet']
                        .toString(),
                    category: widget.category,
                    uid: snapshot.data[index]['uid'],
                    phone: snapshot.data[index]['phone'].toString(),
                  );
                });
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
    await FirebaseFirestore.instance.collection(collectionName).get();

    for (var sanitizerVendor in snapshot.docs) {
      final latitude = sanitizerVendor.data()['latitude'] as double;
      final longitude = sanitizerVendor.data()['longitude'] as double;

      final distanceInMeter =
      await getDistance(myLatitude, myLongitude, latitude, longitude);

      final distance = distanceInMeter / 1000;
      final item = {
        'uid': sanitizerVendor.data()['uid'],
        'distance': distance,
        'name': sanitizerVendor.data()['name'],
        'location': sanitizerVendor.data()['location'],
        'pricePerFeet': sanitizerVendor.data()['pricePerFeet'],
        'phone': sanitizerVendor.data()['phone'],
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
