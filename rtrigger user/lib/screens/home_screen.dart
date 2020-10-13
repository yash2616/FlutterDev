import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/auth/auth.dart';
import 'package:user/models/apptheme.dart';
import 'package:user/models/profile.dart';
import 'package:user/widgets/gridtile.dart';
import 'package:user/models/categories_enum.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController tabController;
  List imageArray = List();
  String finalDate = '';
  Auth auth = Auth();
  UserProfile profile;
  String userName = "";

  @override
  void initState() {
    Firebase.initializeApp();
    tabController = TabController(length: 4, vsync: this);
    getImages();
    super.initState();
  }
  getUserName() async {
    await auth.getProfile().whenComplete(() {
      profile = auth.profile;
      userName = profile.username;
    });
  }
  getCurrentDate() {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    finalDate = formattedDate.toString();
  }


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
  Widget build(BuildContext context) {
    getCurrentDate();
    getUserName();
    getImages();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50, backgroundColor: AppTheme.grey,
          title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      finalDate,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey
                      ),
                    ),
                    Text(
                      "Hello " + userName,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
              ]
          ),
        ),
        body:Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.35,
                          width: MediaQuery.of(context).size.width * 0.35,
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          child: CustomGridTile(
                              title: 'Medicine',
                              loc: 'assets/img/medicine.png',
                              card: Cards.medicine,
                              type: CardType.Home),
                        ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.35,
                      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          child: CustomGridTile(
                              title: 'Food',
                              loc: 'assets/img/food.png',
                              card: Cards.food,
                              type: CardType.Home),
                        ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.35,
                      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          child: CustomGridTile(
                              title: 'Liqour',
                              loc: 'assets/img/liquor.png',
                              card: Cards.liqour,
                              type: CardType.Home),
                        ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.35,
                      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          child: CustomGridTile(
                              title: 'Saloon and Beauty Parlour',
                              loc: 'assets/img/salon.png',
                              card: Cards.saloon,
                              type: CardType.Home),
                        ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.38,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: CustomGridTile(
                              title: 'Santizer and Spray',
                              loc: 'assets/img/sanitize.png',
                              card: Cards.spray,
                              type: CardType.Home),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
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
