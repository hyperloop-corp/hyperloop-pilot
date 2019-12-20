import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hyperloop_pilot/services/authentication.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:convert';


class BarCode extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
  String result = "Scan Ticket QR to record user payment.";
  String sourceLat, sourceLong, destinationLat, destinationLong, price, user_id;
  FirebaseDatabase db = FirebaseDatabase();
  DatabaseReference _userRef;

  void moneyDeduct(int money){

   /* _userRef.child(id).child('money').once().then((DataSnapshot snapshot){

      if(snapshot.value < money) {
        setState(() {
          result = 'Not enough money';
        });

        return;
      }

      int newValue = snapshot.value - money;

      _userRef.child(id).child('money').set(newValue);*/

      showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Payment Successful"),
          content: Text("$money rupees deducted from the user account"),
        );
      });
  }

  initState(){
    _userRef = db.reference().child('users');
    super.initState();
  }

  Future _scanQR() async {
    //try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        /*result = qrResult;*/
        print((qrResult));
        
        List args = qrResult.split(",");
      
        String price = args[4].split(":")[1];
        price = price.trim();

        print(price);

        int money = int.parse(price);
        moneyDeduct(money);
      });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Center(
        child: Text(
          result,
          style: new TextStyle(fontSize: 20.0),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: () => _scanQR(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}