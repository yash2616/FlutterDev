import 'package:flutter/cupertino.dart';

class CategoryModel {
  String title;
  String imgpath;
  CategoryModel({@required this.title,this.imgpath});
}

List<CategoryModel> categoryItems = [
  CategoryModel(title: "Medicine", imgpath:"assets/img/medicine.png"),
  CategoryModel(title: "Food", imgpath:"assets/img/food.png"),
  CategoryModel(title: "Liquor", imgpath:"assets/img/liquor.png"),
  CategoryModel(title: "Salon and Beauty Parlor", imgpath:"assets/img/salon.png"),
  CategoryModel(title: "Sanitizer and Spray", imgpath:"assets/img/sanitizer.png"),
  CategoryModel(title: "View All"),
];