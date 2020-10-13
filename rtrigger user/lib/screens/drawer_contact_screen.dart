import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:user/auth/auth.dart';
import 'package:user/models/apptheme.dart';
import 'package:user/models/profile.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Auth auth = Auth();
  UserProfile profile;
  var orderid = "";
  var subject = "";
  var body = "";
  var name = "";
  var mail = "";
  bool isLoaded = false;
  bool isSent = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> sendIt() async {
    setState(() {
      isSent = false;
    });
    final FormState form = _formKey.currentState;
    form.save();
    String platformResponse;
    String username = 'rtiggersapp@gmail.com';
    String password = 'Rtiggersapp@1';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, mail)
      ..recipients.add('support@rtiggersapp.com')
      ..subject = 'User Feedback!'+ orderid
      ..text = body
      ..html = "<h1>Customer FeedBack</h1>\n" +
          "<p>" +
          body +
          "</p>\n<p>The user email is - " +
          mail +
          "</p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      platformResponse = 'Sent';
    } catch (error) {
      print("Error occured");
      print(error);
      platformResponse = error.toString();
    } finally {
      setState(() {
        isSent = true;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(platformResponse),
      ));
    }
  }

  @override
  void initState() {
    auth.getProfile().whenComplete(() {
      profile = auth.profile;
      name = profile.username;
      mail = profile.email;
      setState(() {
        isLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
        title: Text("Contact Us"),
        backgroundColor: AppTheme.grey,
      ),
      body: isLoaded
          ? SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      height: MediaQuery.of(context).size.height - 120,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(children: <Widget>[
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.rectangle,
                                    border: new Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new TextFormField(
                                      initialValue: name,
                                      decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Full Name',
                                          labelStyle:
                                              TextStyle(color: Colors.black)),
                                      onChanged: (value) {
                                        name = value;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.rectangle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new TextFormField(
                                onChanged: (value) {
                                  mail = value;
                                },
                                initialValue: mail,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Email Address',
                                    labelStyle: TextStyle(color: Colors.black)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.rectangle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Order Id',
                                    labelStyle: TextStyle(color: Colors.black)),
                                onChanged: (value) {
                                  orderid = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.rectangle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Contact Reason',
                                    labelStyle: TextStyle(color: Colors.black)),
                                onChanged: (value) {
                                  subject = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.rectangle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Description of Query',
                                      labelStyle: TextStyle(color: Colors.black)),
                                  onChanged: (value) {
                                    body = value;
                                  },
                                )),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 35, horizontal: 50),
                          child: RaisedButton(
                            onPressed: () {
                              sendIt();
                            },
                            child: Container(
                              height: 50,
                              child: isSent
                                  ? Column(
                                      children: <Widget>[
                                        Container(
                                          height: 10,
                                        ),
                                        Text("Send",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      ],
                                    )
                                  : Center(child: CircularProgressIndicator()),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color.fromRGBO(00, 44, 64, 1.0),
                                )),
                            color: Color.fromRGBO(00, 44, 64, 1.0),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
          )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
