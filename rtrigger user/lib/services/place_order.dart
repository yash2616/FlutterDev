import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceOrder{

  void placeFoodOrder(String vendorID, Map order) async{
    final _firestore = FirebaseFirestore.instance;

    try{
      await _firestore.collection("vendorOrder").doc(vendorID).update({
        "newOrder": FieldValue.arrayUnion([order]),
      });
    }
    catch(e){
      print(e);
    }
  }


  void placeLiquorOrder(String vendorID, Map order) async{
    final _firestore = FirebaseFirestore.instance;

    try{
      await _firestore.collection("vendorOrder").doc(vendorID).update({
        "newOrder": FieldValue.arrayUnion([order]),
      });
    }
    catch(e){
      print(e);
    }
  }

  void placeMedicineOrder(String vendorID, Map order) async{
    final _firestore = FirebaseFirestore.instance;

    try{
      await _firestore.collection("vendorOrderMedical").doc(vendorID).update({
        "active": FieldValue.arrayUnion([order]),
      });
    }
    catch(e){
      print(e);
    }
  }


  void placeSalonOrder(String vendorID, Map order) async{
    final _firestore = FirebaseFirestore.instance;

    try{

    }
    catch(e){
      print(e);
    }
  }


  void placeSanitizationOrder(String vendorID, Map order) async{
    final _firestore = FirebaseFirestore.instance;

    try{
      await _firestore.collection("vendorSanitize").doc(vendorID).set({
        "latitude": order["latitude"],
        "longitude": order["longitude"],
        "location": order["location"],
        "name": order["name"],
        "phone": order["phone"],
        "pricePerFeet": order["pricePerFeet"],
        "uid": order["uid"],
      });
    }
    catch(e){
      print(e);
    }
  }


}