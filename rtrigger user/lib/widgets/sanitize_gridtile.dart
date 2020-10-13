import 'package:flutter/material.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/screens/sanitizer_vendor_list_screen.dart';

class SanitizeGridTile extends StatelessWidget {
  final String title;
  final String loc;
  final Cards category;
  SanitizeGridTile(this.title, this.loc, this.category);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 20,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SanitizeVendorListScreen(category)));
        },
        child: Container(
          padding: EdgeInsets.all(7),
          height: screenHeight / 5,
          child: FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (loc != null)
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius:
                          title == 'Medicine' || title == 'Liquor' ? 40 : 33,
                      child: ClipOval(
                          child: Image.asset(
                        loc,
                        fit: BoxFit.cover,
                      ))),
                Text(title,
                    style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
