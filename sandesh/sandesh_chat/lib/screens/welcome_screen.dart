import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sandesh/components/welcome_screen_buttons.dart';

class WelcomeScreen extends StatefulWidget {

  static String route = '/';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1), vsync: this,
    );
    animator = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animator.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 100,
                  ),
                ),
                SizedBox(width: 10,),
                TypewriterAnimatedTextKit(
                  isRepeatingAnimation: false,
                  speed: Duration(milliseconds: 500),
                  text: ['Sandesh'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            WelcomeScreenButton(
              buttonColor: Colors.lightBlueAccent,
              buttonText: 'Login',
              onButtonPressed: (){
                Navigator.pushNamed(context, LoginScreen.route);
              },
            ),
            WelcomeScreenButton(
              buttonColor: Colors.blueAccent,
              buttonText: 'Register',
              onButtonPressed: (){
                Navigator.pushNamed(context, RegistrationScreen.route);
              },
            ),
          ],
        ),
      ),
    );
  }
}

