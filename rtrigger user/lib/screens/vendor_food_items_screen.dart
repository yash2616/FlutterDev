import 'package:flutter/material.dart';
import 'package:user/services/Food/vendor_fetching.dart';
import 'package:user/widgets/food_item_card.dart';

class VendorFoodItemsScreen extends StatefulWidget {

  VendorFoodItemsScreen({this.vendorID});

  final String vendorID;

  @override
  _VendorFoodItemsScreenState createState() => _VendorFoodItemsScreenState();
}

class _VendorFoodItemsScreenState extends State<VendorFoodItemsScreen> {

  List<dynamic> foodItems = [];
  VendorFetching vendorFetching = VendorFetching();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFoodItems();
    print(foodItems);
  }

  void getFoodItems() async{
    var fetchedData = await vendorFetching.getVendorItems(widget.vendorID);
    setState(() {
      foodItems = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index){
            return FoodItemCard(
              image: foodItems[index]["img"],
              distance: foodItems[index]["distance"],
              time: foodItems[index]["prep"],
              foodTitle: foodItems[index]["item"],
              price: int.parse(foodItems[index]["price"]),
              vendorName: foodItems[index]["shop"],
            );
          },
          itemCount: foodItems.length,
        ),
      ),
    );
  }
}
