import 'package:flutter/material.dart';
import 'package:user/widgets/vendor_card.dart';
import 'package:user/services/Food/vendor_fetching.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';

class VendorScreen extends StatefulWidget {
  @override
  _VendorScreenState createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {

  VendorFetching vendorFetching = VendorFetching();
  List<dynamic> vendorData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVendorData();
  }

  void getVendorData() async{
    var fetchedData = await vendorFetching.getVendors();
    setState(() {
      vendorData = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(context,true,'All Vendors',),
      body: SafeArea(
          child: ListView.builder(
            itemBuilder: (context, index){
              return VendorCard(
                vendorID: vendorData[index]["userId"],
                type: vendorData[index]["desc"],
                name: vendorData[index]["name"],
                distance: vendorData[index]["distance"],
                image: vendorData[index]["imageUrl"],
              );
            },
            itemCount: vendorData.length,
          )
      ),
    );
  }
}
