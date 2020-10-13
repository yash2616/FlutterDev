import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user/models/categories_enum.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';
import 'package:user/widgets/gridtile.dart';

class SaloonScreen extends StatefulWidget {
  @override
  _SaloonScreenState createState() => _SaloonScreenState();
}

class _SaloonScreenState extends State<SaloonScreen> {
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
      appBar: UniversalAppBar(context,false,"Saloon/Beauty Parlour Category"),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                        height: MediaQuery.of(context).size.width * 0.35,
                        width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                        child: CustomGridTile(title:'Male', loc:'assets/img/male.jpg', card:Cards.male,  type:CardType.Saloon)),
                Container(
                        height: MediaQuery.of(context).size.width * 0.35,
                        width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                        child: CustomGridTile(title:'Female', loc:'assets/img/female.jpg', card:Cards.female,type:CardType.Saloon)),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                        height: MediaQuery.of(context).size.width * 0.35,
                        width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                        child: CustomGridTile(title:'Unisex', loc:'assets/img/unisex.png', card:Cards.unisex,type: CardType.Saloon)),
                Container(
                        height: MediaQuery.of(context).size.width * 0.35,
                        width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                        child: CustomGridTile(title:'Spa', loc:'assets/img/spa.jpg', card:Cards.spa,type: CardType.Saloon)),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width*0.34,),
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
    );
  }
}

