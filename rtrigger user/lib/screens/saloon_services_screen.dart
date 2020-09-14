import 'package:flutter/material.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/saloon_services_list_tile.dart';

class SaloonServicesScreen extends StatelessWidget {
  final List services;
  final Cards category;
  final String uid;
  final String location;
  final String vendorName;
  SaloonServicesScreen(
      this.services, this.category, this.uid, this.location, this.vendorName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(context, false, " "),
      body: ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            return SaloonServiceListTile(services[index]['serviceType'],
                services[index]['price'], uid, location, vendorName, category);
          }),
    );
  }
}
