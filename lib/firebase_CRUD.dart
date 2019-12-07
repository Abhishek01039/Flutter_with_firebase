import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription<DocumentSnapshot> streamSubscription;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DocumentReference documentReference =
      Firestore.instance.document("mydata/dummy");
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  @override
  void initState() {
    super.initState();
    streamSubscription = documentReference.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          data = snapshot.data['Name'];
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription.cancel();
  }

  void _signOut() {
    _googleSignIn.signOut();
    print("User Sign OUT");
  }

//  Insert data into database

  _adddata() {
    Map<String, String> data = <String, String>{
      "Name": "Abhishek kumar",
      "Desc": "Flutter Devloper"
    };

    documentReference
        .setData(data)
        .whenComplete(() => print("Added data"))
        .catchError((e) => print(e));
  }

// delete from database

  _deletedata() {
    documentReference
        .delete()
        .whenComplete(() => print("Deleted"))
        .catchError((e) => print(e));
  }

  // update database

  _updatedata() {
    Map<String, String> data = <String, String>{
      "Name": "Abhishek kumar Updated",
      "Desc": "Flutter Devloper Updated"
    };

    documentReference
        .updateData(data)
        .whenComplete(() => print("Updated data"))
        .catchError((e) => print(e));
  }

// get data from database

  var data;
  _fetch() {
    documentReference.get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          data = snapshot.data['Name'];
        });
      }
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter with FireBase"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text(
                  "Sign In",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () => _handleSignIn()
                    .then((result) => print(result))
                    .catchError((e) => print(e)),
                color: Colors.red,
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                child: Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: _signOut,
                color: Colors.blue,
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                child: Text(
                  "Insert",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: _adddata,
                color: Colors.cyan,
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                child: Text(
                  "Update",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: _updatedata,
                color: Colors.orange,
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                child: Text(
                  "Delete",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: _deletedata,
                color: Colors.teal,
              ),
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                child: Text(
                  "Show",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: _fetch,
                color: Colors.deepPurple,
              ),
              SizedBox(
                height: 30,
              ),
              data == null
                  ? Container()
                  : Text(
                      data,
                      style: TextStyle(fontSize: 20),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
