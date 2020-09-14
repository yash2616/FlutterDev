import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/gridtile.dart';

class SanitizerAndSprayScreen extends StatefulWidget {
  @override
  _SanitizerAndSprayScreenState createState() => _SanitizerAndSprayScreenState();
}

class _SanitizerAndSprayScreenState extends State<SanitizerAndSprayScreen> {
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
      appBar: UniversalAppBar(context,false,"Sanitize and Spray Category"),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                        height: MediaQuery.of(context).size.width * 0.35,
                        width: MediaQuery.of(context).size.width * 0.35,
                        margin: EdgeInsets.all(10),
                        child: CustomGridTile(
                            title: 'Sanitize',
                            loc: 'assets/img/sanitise.jpg',
                            card: Cards.sanitize,
                            type: CardType.Sanitizer),
                      ),
                  Container(
                        height: MediaQuery.of(context).size.width * 0.35,
                        width: MediaQuery.of(context).size.width * 0.35,
                        margin: EdgeInsets.all(10),
                        child: CustomGridTile(
                            title: 'Mosquito',
                            loc: 'assets/img/mosquito.jpg',
                            card: Cards.mosquito,
                            type: CardType.Sanitizer),
                      ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                        height: MediaQuery.of(context).size.width * 0.35,
                        width: MediaQuery.of(context).size.width * 0.35,
                        margin: EdgeInsets.all(10),
                        child: CustomGridTile(
                            title: 'Cockroach',
                            loc: 'assets/img/cockroch.jpg',
                            card: Cards.cockroach,
                            type: CardType.Sanitizer),
                      ),
                  Container(),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.width*0.35,),
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
