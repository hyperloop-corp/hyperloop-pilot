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
  String result = "Scan QR to get user details";
  String sourceLat, sourceLong, destinationLat, destinationLong, price, user_id;
  FirebaseDatabase db = FirebaseDatabase();
  DatabaseReference _userRef;

  void moneyDeduct(int money, String id){

    _userRef.child(id).child('money').once().then((DataSnapshot snapshot){

      if(snapshot.value < money) {
        setState(() {
          result = 'Not enough money';
        });

        return;
      }

      int newValue = snapshot.value - money;

      _userRef.child(id).child('money').set(newValue);

    });

  }

  initState(){
    _userRef = db.reference().child('users');
  }

  Future _scanQR() async {
    //try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        print((result));
        
        List args = result.split(",");
        
        String uid = args[5].split(":")[1];
        uid = uid.substring(0, uid.length - 1);
        uid = uid.trim();

        String price = args[4].split(":")[1];
        price = price.trim();

        print(uid + " " + price);

        int money = int.parse(price);
        moneyDeduct(money, uid);
      });
    /*} on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }*/
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
          style: new TextStyle(fontSize: 15.0),
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