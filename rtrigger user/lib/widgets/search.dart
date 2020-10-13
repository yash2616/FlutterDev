import 'package:flutter/material.dart';

class Search extends StatelessWidget {

  /*void update() async {
    await Firestore.instance
        .collection('user-activity')
        .document('9108650970')
        .collection('search')
        .document('userSearch')
        .updateData({
      'search': null,
    });
  }*/


  /*onPressed(value) async {
    await Firestore.instance
        .collection('user-activity')
        .document('9108650970')
        .collection('search')
        .document('userSearch')
        .updateData({
      'search': value,
    });
  }*/

  @override
  Widget build(BuildContext context)
  {
    //update();
    return Container(
      decoration: ShapeDecoration(
        color: Colors.teal.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width / 3.5,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.04,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 1,
          maxLength: 16,
          maxLengthEnforced: true,
          style: TextStyle(
            fontSize: MediaQuery
                .of(context)
                .size
                .height * 0.02,
            color: Color.fromRGBO(00, 44, 64, 1),
          ),
          decoration: InputDecoration(
              filled: false,
              //fillColor: Colors.teal.withOpacity(0.2),
              hintText: "Search",
              counterText: "",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintStyle: TextStyle(
                color: Color.fromRGBO(00, 44, 64, 1),
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Color.fromRGBO(00, 44, 64, 1),
                size: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02,
              )),
          //onChanged: onPressed,
        ),
      ),
    );
  }
}
