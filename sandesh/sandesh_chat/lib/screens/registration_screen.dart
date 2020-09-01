import 'package:sandesh/components/welcome_screen_buttons.dart';
import 'package:sandesh/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandesh/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {

  static String route = '/register';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String name, email, password, cpassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      backgroundColor: Colors.white,
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
                  hintText: 'Enter your email',
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
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  cpassword = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Confirm your password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              WelcomeScreenButton(
                buttonColor: Colors.blueAccent,
                buttonText: 'Register',
                onButtonPressed:  () async {
                  print("$name\n$email\n$password\n$cpassword");
                  setState(() {
                    showSpinner = true;
                  });

                  if(password==cpassword){
                    try{
                      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                      if(newUser!=null){
                        Navigator.pushNamed(context, ChatScreen.route);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    }
                    catch(e){
                      print(e);
                    }
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
