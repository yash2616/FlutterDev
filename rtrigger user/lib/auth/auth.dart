// // import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/services.dart';
// import 'dart:async';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// abstract class BaseAuth {
//   Future<String> loginAndSignin(String email, String password);
//   Future<String> createUserEmailPass(String email, String password);
// }

// class Auth implements BaseAuth {
//   final _auth = FirebaseAuth.instance;
//   Future<String> loginAndSignin(String email, String password) async {
//     AuthResult user = await _auth.signInWithEmailAndPassword(
//         email: email, password: password);

//     return user.user.uid;
//   }

//   Future<String> createUserEmailPass(String email, String password) async {
//     AuthResult user = await _auth.createUserWithEmailAndPassword(
//         email: email, password: password);

//     return user.user.uid;
//   }

//   Future<String> currentUser() async {
//     FirebaseUser user = await FirebaseAuth.instance.currentUser();
//     return user.uid;
//   }
// }

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user/models/profile.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String username,int phone);

  Future<String> currentUser();

  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserProfile profile;

  Future<void> getProfile() async {
    final User user = FirebaseAuth.instance.currentUser;
    var auth = FirebaseFirestore.instance;
    await auth.collection('users').doc(user.uid).get().then((value) {
      profile = UserProfile(
        state: value.data()['state'],
          city: value.data()['city'],
          username: value.data()['username'],
          email: value.data()['email'],
          userId: value.data()['userId'],
          phone: value.data()['phone'],
          address: value.data()['address'],
          imageUrl: value.data()['imageUrl']);
    });
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    final User user = _firebaseAuth.currentUser;
    var auth1 = FirebaseFirestore.instance;
    var _db = auth1.collection('users').doc(user.uid);
    try {
      await _db.update({
        'username': newProfile.username,
        'email': newProfile.email,
        'userId': newProfile.userId,
        'phone': newProfile.phone,
        'city': newProfile.city,
        'state': newProfile.state,
        'address': newProfile.address,
        'imageUrl': newProfile.imageUrl
      });
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await getProfile();
      if (user.user.emailVerified) {
        return user.user?.uid;
      } else {
        return "Not verified";
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String username,int phone) async {
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await user.user.sendEmailVerification();
        await addUserDetails(email, username, user.user.uid,phone);
        await setCart();
        return user.user?.uid;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return e.code;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> setCart() async {
    final _firestore = FirebaseFirestore.instance;
    final userID = FirebaseAuth.instance.currentUser.uid;
    await _firestore.collection("cart").doc(userID).set({"products": []});
  }

  @override
  Future<String> currentUser() async {
    final User user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  Future<void> addUserDetails(String email, String username, String uid,int phone) async {
    var auth1 = FirebaseFirestore.instance;
    var _db = auth1.collection('users').doc(uid);
    _db.set({
      'username': username,
      'email': email,
      'userId': uid,
      'phone': phone,
      'address': "Address",
      'city':"Delhi",
      'state':"Delhi",
      'imageUrl':
          "https://icon-library.com/images/default-user-icon/default-user-icon-4.jpg"
    });
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
