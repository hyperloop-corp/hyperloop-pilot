import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

import 'barcode.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase db = FirebaseDatabase();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hyperloop Pilot'),
        //leading: Icon(Icons.menu),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                  child: Text("Your Current Bus Details", textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(textStyle: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))),
            ),
            Card(
                color: Colors.blue[300],
                elevation: 6,
                child: Container(
                    width: 450,
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      busHead("Bus Code - 4A"),
                      busRoute("ISBT-43", "ISBT-43"),
                      busNo("CH 03 A 3487"),
                      driver("Bla bla"),
                      //conductor("Bla bla"),
                    ])))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Center(child: Text('Scan QR')),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext flutter) => BarCode()))),
    );
  }

  Widget busHead(String title) {
    return Container(
        padding: const EdgeInsets.all(0),
        child: Text(title,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white))));
  }

  Widget busRoute(String start, String stop) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(start,
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white70,
                ))),
            Icon(Icons.compare_arrows, color: Colors.white70,),
            Text(
              stop,
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white70,
              )),
            )
          ],
        ));
  }

  Widget busNo(number) => Center(
        child: Container(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Text(
            number,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.yellow[800]),
          ),
          ),
        ),
      );

  Widget driver(String name){
    return Container(padding: const EdgeInsets.all(10),
    child: Text("Driver : " + name, style: GoogleFonts.openSans(textStyle: TextStyle( fontSize: 25, color: Colors.white)),),);
  }

}
