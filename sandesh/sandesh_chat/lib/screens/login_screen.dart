import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandesh/constants.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/components/welcome_screen_buttons.dart';
import 'package:sandesh/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class LoginScreen extends StatefulWidget {

  static String route = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "Enter your email",
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter you password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              WelcomeScreenButton(
                buttonColor: Colors.lightBlueAccent,
                buttonText: 'Login',
                onButtonPressed: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final loggedUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (loggedUser != null) {
                      Navigator.pushNamed(context, ChatScreen.route);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  }
                  catch(e){
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
