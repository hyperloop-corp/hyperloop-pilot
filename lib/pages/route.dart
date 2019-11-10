import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'barcode.dart';

class RoutePage extends StatefulWidget {

  final busNumber;

  RoutePage(this.busNumber);

  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {

  FirebaseDatabase db = FirebaseDatabase();
  DatabaseReference _routeRef, _numberRef;
  FirebaseUser _user;

  @override
  void initState() {
    _routeRef = db.reference().child('buses_on_route');
    _numberRef = db.reference().child('bus_route');
    getUser();
    super.initState();
  }

  void getUser() async {
    _user = await FirebaseAuth.instance.currentUser();
  }
  void modifyValues(String Route){

    String prev_route;
    _numberRef.child(widget.busNumber).once().then((DataSnapshot snapshot){
      prev_route = snapshot.value;
      _numberRef.child(widget.busNumber).set(Route);
      try {_routeRef.child(prev_route).child(widget.busNumber).remove();

    }
    catch(e){};
    });

    _routeRef.child(Route).child(widget.busNumber).set(_user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
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
                child: Text('Choose your Current Route', style: TextStyle(fontSize: 20)),
              ),
              Expanded(
                child: FirebaseAnimatedList(
                    query: _routeRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      return RaisedButton(
                        onPressed: () => modifyValues(snapshot.key),
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
      floatingActionButton: FloatingActionButton(
        child: Text('Scan QR'),
          onPressed:
      ()=> Navigator.push(context, MaterialPageRoute(builder: (BuildContext flutter) => BarCode()))),
    );
  }
}
