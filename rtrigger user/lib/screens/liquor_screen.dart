import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user/models/apptheme.dart';
import 'package:user/models/liquor_category_list.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/food_category_card.dart';

// ignore: must_be_immutable
class LiquorScreen extends StatefulWidget {
  @override
  _LiquorScreenState createState() => _LiquorScreenState();
}

class _LiquorScreenState extends State<LiquorScreen> {
  List<dynamic> _listItem = LiquorCategoryList().liquorItems;
  List imageArray = List();
  Future<void> getImages() async {
    var auth = FirebaseFirestore.instance;
    await auth
        .collection('displayImages')
        .doc('VRxueMwcdcW4VmDR721r')
        .get()
        .then((value) {
      setState(() {
        imageArray = value.data()['home'];
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(context, true, "Liquor Category"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 30),
                //flex: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (_, index) {
                          //if (index < 4){
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: FoodCategoryCard(
                                image: _listItem[index]["image"],
                                index: _listItem[index]["index"] + 15,
                                foodName: _listItem[index]["foodName"],
                              ),
                            );
                          //}

                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //margin: EdgeInsets.only(bottom: 30),
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.width * 0.35,
                          child: FoodCategoryCard(
                            image: _listItem[4]["image"],
                            index: _listItem[4]["index"] + 15,
                            foodName: _listItem[4]["foodName"],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  //pauseAutoPlayOnTouch: Duration(seconds: 10),
                  aspectRatio: 2.0,
                ),
                items: imageArray.map((url) {
                  return Builder(builder: (BuildContext context) {
                    return Container(
                      margin: EdgeInsets.only(top:10,bottom: 10),
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: Colors.grey[300],
                        child: CachedNetworkImage(
                          imageUrl: url,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),/*Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),*/
                      ),
                    );
                  });
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
