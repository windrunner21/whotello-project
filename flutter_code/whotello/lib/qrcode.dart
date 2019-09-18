import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'themewidget.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  String barcode = "";
  var _sharedCodeController = TextEditingController();
  var choicesList = ["Appearance", "Logout"];

  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(
          title: Text('QR Code Scanner'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (context) {
                return choicesList.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              child: Icon(Icons.settings),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              "assets/logo.png",
              height: 150,
              width: 150,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  onPressed: () {
                    _settingModalBottomSheet(context);
                  },
                  child: const Text('SHARED CODE')),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('QR Code Scanner'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (context) {
                return choicesList.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              child: Icon(Icons.settings),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              "assets/logo.png",
              height: 150,
              width: 150,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: scan,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  child: const Text('QR-CODE SCAN')),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                barcode,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 40),
                  child: new TextField(
                    textCapitalization: TextCapitalization.characters,
                    controller: _sharedCodeController,
                    decoration: InputDecoration(
                        labelText: "Shared Code",
                        icon: Icon(
                          Icons.supervisor_account,
                          color: Colors.blue,
                        )),
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 40, right: 40, bottom: 40),
                  child: new ButtonBar(
                    children: <Widget>[
                      new FlatButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      new FlatButton(
                        color: Colors.blue,
                        child: new Text(
                          "ACCEPT",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (/*_sharedCodeController.text == "IMRAN"*/ true) {
                            _pushRoomCode("Bilkent Hotel", "102",
                                _sharedCodeController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuPage()),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void showChooser() {
    showDialog<void>(
        context: context,
        builder: (context) {
          return BrightnessSwitcherDialog(
            onSelectedTheme: (brightness) {
              DynamicTheme.of(context).setBrightness(brightness);
            },
          );
        });
  }

  void _signOut() async {
    await _auth.signOut();
  }

  void choiceAction(String choice) {
    if (choice == "Logout") {
      _signOut();
      Navigator.popUntil(
          context, ModalRoute.withName(Navigator.defaultRouteName));
    }

    if (choice == "Appearance") {
      showChooser();
    }
  }

  void _pushRoomCode(String name, String number, String code) async {
    try {
      // get current user
      FirebaseUser user = await _auth.currentUser();
      // set up correct path to the user in the database
      DatabaseReference _userRef =
          _firebaseDatabase.reference().child("users").child(user.uid);

      await _userRef.update({
        "current_hotel": "" + name,
        "room_number": "" + number,
        "room_code": "" + code,
      }).then((_) {
        print('Transaction  committed.');
      });
    } catch (e) {
      print('Error occurred while pushing code');
    }
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
      var array = barcode.split("|");
      String hotelName = array[0];
      String roomNumber = array[1];
      String roomCode = array[2];
      _pushRoomCode(hotelName, roomNumber, roomCode);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MenuPage()));
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Returned without scanning');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
