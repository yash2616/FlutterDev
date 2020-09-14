import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/loading_bar.dart';
import 'package:user/widgets/medicine_vendor_list_tile.dart';

class MedicineVendorListScreen extends StatefulWidget {
  @override
  _MedicineVendorListScreenState createState() =>
      _MedicineVendorListScreenState();
}

class _MedicineVendorListScreenState extends State<MedicineVendorListScreen> {
  final _collectionName = 'Medical';

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
                title: Text("Can't get current location"),
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
    return Scaffold(
      appBar: UniversalAppBar(context, false, 'Shops Near You'),
      body: FutureBuilder<List<Map>>(
        future: listOfVendors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingBar();
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  if(snapshot.data[index]['distance']<10){
                    return MedicineVendorListTile(
                      uid: snapshot.data[index]['uid'],
                      vendorName: snapshot.data[index]['name'],
                      location: snapshot.data[index]['location'],
                      kmFar: snapshot.data[index]['distance'],
                    );
                  }
                  return null;
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
        await FirebaseFirestore.instance.collection(_collectionName).get();

    for (var medicineVendor in snapshot.docs) {
      final latitude = medicineVendor.data()['latitude'] as double;
      final longitude = medicineVendor.data()['longitude'] as double;

      final distanceInMeter =
          await getDistance(myLatitude, myLongitude, latitude, longitude);

      final distance = distanceInMeter / 1000;
      final item = {
        'uid': medicineVendor.data()['uid'],
        'distance': distance,
        'name': medicineVendor.data()['name'],
        'location': medicineVendor.data()['location'],
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
