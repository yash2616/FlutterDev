import 'package:flutter/material.dart';

class NavigationModel {
  String title;
  IconData icon;
  NavigationModel({this.title,this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(title: "Home" ,icon: Icons.home),
  NavigationModel(title: "Favourites" ,icon: Icons.favorite),
  NavigationModel(title: "Orders" ,icon: Icons.note),
  NavigationModel(title: "My Cart" ,icon: Icons.shopping_cart),
  NavigationModel(title: "Profile" ,icon: Icons.account_circle),
  NavigationModel(title: "Notifications" ,icon: Icons.notifications),
  NavigationModel(title: "Contact Us" ,icon: Icons.contact_mail),
  NavigationModel(title: "Logout" ,icon: Icons.exit_to_app),
];
