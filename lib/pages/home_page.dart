import 'dart:async';
import 'package:hyperloop_pilot/pages/route.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hyperloop_pilot/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';

import 'barcode.dart';

class HomePage extends StatefulWidget {
  /*HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;*/

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase db = FirebaseDatabase();
  DatabaseReference _numbersRef;
  List<String> numbers = [], routes = [];

  @override
  void initState() {
    _numbersRef = db.reference().child('bus_route');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hyperloop Pilot'),
        //leading: Icon(Icons.menu),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text('Choose your Bus', style: TextStyle(fontSize: 20)),
              ),
              Expanded(
                child: FirebaseAnimatedList(
                    query: _numbersRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      numbers.add(snapshot.key);
                      return RaisedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    RoutePage(snapshot.key))),
                        child: Text(snapshot.key,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(

          label: Center(child: Text('Scan QR')),
          onPressed:
              ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext flutter) => BarCode()))),
    );
  }
}
