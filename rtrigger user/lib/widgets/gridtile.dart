import 'package:flutter/material.dart';
import 'package:user/screens/food_screen.dart';
import 'package:user/screens/food_screen.dart';
import 'package:user/screens/liquor_screen.dart';
import 'package:user/screens/medicine_vendor_list_screen.dart';
import 'package:user/widgets/custom_page_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/screens/saloon_vendor_list_screen.dart';
import 'package:user/screens/sanitizer_vendor_list_screen.dart';
import 'package:user/screens/navigating_home_screen.dart';
import 'package:user/widgets/homedrawer.dart';
import 'package:user/screens/medicine_screen.dart';
import 'package:user/screens/saloon_screen.dart';
import 'package:user/screens/sanitizer_spray_screen.dart';
import 'package:user/screens/food_screen.dart';

class CustomGridTile extends StatelessWidget {
  final String title;
  final String loc;
  final Cards card;
  final CardType type;

  CustomGridTile({this.title, this.loc, this.card, this.type});

  /*getNextScreen() {
    switch (type) {
      case CardType.Medicine:
        return MedicineScreen();
        break;
      case CardType.Food:
        return FoodScreen();
        break;
      case CardType.Liqour:
        return LiquorScreen();
        break;
      case CardType.Sanitizer:if(card==Cards.sanitize||card==Cards.mosquito||card==Cards.cockroach){
                                return SaloonVendorListScreen(card);
                              }
                              return SaloonScreen();
                              break;
      case CardType.Saloon:if(card==Cards.male||card==Cards.male||card==Cards.male){
                              return SanitizeVendorListScreen(card);
                            }
                            return SaloonScreen();

        break;

    }
  }*/
  getNextScreen() {
    switch (type) {
      case CardType.Sanitizer:
        return SanitizeVendorListScreen(card);
        break;
      case CardType.Saloon:
        return SaloonVendorListScreen(card);
        break;
      case CardType.Home:
        return goFromHomeTo();
        break;
    }
  }

  goFromHomeTo() {
    switch (card) {
      case Cards.medicine:
        return MedicineVendorListScreen();
        break;

      case Cards.food:
        return FoodScreen();
        break;

      case Cards.liqour:
        return LiquorScreen();
        break;

      case Cards.saloon:
        return SaloonScreen();
        break;

      case Cards.spray:
        return SanitizerAndSprayScreen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 20,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(CupertinoPageRoute(builder: (_) => getNextScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 15,left:2,right: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Container(
                  height: type == CardType.Home?MediaQuery.of(context).size.width / 4.8:MediaQuery.of(context).size.width / 4,
                  width: type == CardType.Home?MediaQuery.of(context).size.width / 4.8:MediaQuery.of(context).size.width / 4,
                  margin: EdgeInsets.only(bottom:10),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(loc), fit: BoxFit.fitHeight)),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
