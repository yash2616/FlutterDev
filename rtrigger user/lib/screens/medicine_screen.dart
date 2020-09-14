import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:user/screens/medical_bargain_screen.dart';
import 'package:user/screens/upload_prescription.dart';
import 'package:user/widgets/appbar_subcategory_screens.dart';

final Color _color = Color.fromRGBO(0, 44, 64, 1);

class MedicineScreen extends StatefulWidget {
  final String vendorName;
  final double kmFar;
  final String location;
  final String uid;

  MedicineScreen(
      {@required this.vendorName,
      @required this.kmFar,
      @required this.location,
      @required this.uid});

  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String imageUrl;
  final instructionController = TextEditingController();
  bool imageUploaded = false;

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    double y = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: UniversalAppBar(context, false, "Medicine"),
      body: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width / 8),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.vendorName,
                  style: TextStyle(
                      color: _color,
                      fontSize: y * 0.033,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: y * 0.02),
                child: Text(
                  '${widget.kmFar.toStringAsFixed(2)} km from your location',
                  style: TextStyle(color: _color, fontSize: y * 0.018),
                ),
              ),
              Text(
                'Home Delivery available',
                style: TextStyle(
                    color: _color,
                    fontWeight: FontWeight.w600,
                    fontSize: y * 0.018),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: y * 0.02),
                child: Text(
                  'Upload the picture or the document list of things needed',
                  style: TextStyle(color: _color, fontSize: y * 0.019),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: y * 0.02),
                alignment: Alignment.center,
                child: Container(
                  width: x * 0.6,
                  height: y * 0.07,
                  padding: EdgeInsets.symmetric(horizontal: x * 0.02),
                  //width: 275,
                  decoration: ShapeDecoration(
                    color: Colors.teal.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Upload Prescription',
                        style: TextStyle(
                          color: _color,
                          fontSize: y * 0.022,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final data = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => AddImages()));
                          if (data['status'] == true)
                            setState(() {
                              imageUploaded = true;
                              imageUrl = data['downloadUrl'];
                            });
                        },
                        child: Icon(Icons.attachment, color: _color, size: 25),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: y * 0.05, bottom: 0.0),
                  child: Text('Extra Instructions (If Any)'),
                ),
              ),
              TextField(
                controller: instructionController,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
              ),
              Padding(
                padding: EdgeInsets.only(top: y * 0.011),
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    height: y * 0.08,
                    width: x / 2,
                    margin: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      onPressed: imageUrl != null && imageUploaded == true
                          ? submit
                          : null,
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Color.fromRGBO(00, 44, 64, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    if (imageUploaded == true && imageUrl != null)
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MedicalBargainScreen(
              name: widget.vendorName,
              location: widget.location,
              url: imageUrl,
              description: instructionController.text,
              uid: widget.uid)));
    else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please Upload an Image First'),
      ));
    }
  }
}
