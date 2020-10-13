import 'package:cloud_firestore/cloud_firestore.dart';

class Cart{

  final _firestore = FirebaseFirestore.instance;


  Future<bool> addToCart({String userID, List item}) async{

    try{
      await _firestore.collection("cart").doc(userID).update({
        "products": FieldValue.arrayUnion(item),
      });
      print("added to cart");
      return true;
    }
    catch(e){
      print(e);
      return false;
    }
  }


  Future<bool> deleteFromCart({String userID, String productID}) async{
    try{
      var products = await _firestore.collection("cart").doc(userID).get();
      List<dynamic> productItems = products.get("products");
      if(productItems!=null){
        for(var product in productItems){
          if(product["productID"]==productID){
            print(product);
            productItems.remove(product);
            break;
          }
        }
      }
      await _firestore.collection("cart").doc(userID).set({
        "products": productItems,
      });
      print("product removed");
      return true;
    }
    catch(e){
      print(e);
      return false;
    }
  }

  Future<List<dynamic>> getCartItems(String userID) async{

    try{
      var cartItems = await _firestore.collection("cart").doc(userID).get();
      List<dynamic> products = cartItems.get("products");
      if(products!=null){
        return products;
      }
      else{
        return [];
      }
    }
    catch(e){
      print(e);
    }

  }

}