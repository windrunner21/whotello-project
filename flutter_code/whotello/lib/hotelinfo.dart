import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

class HotelInfoPage extends StatefulWidget {
  @override
  _HotelInfoPageState createState() => _HotelInfoPageState();
}

String hotelName;
String hotelInfo;
String hotelWiFi;
String hotelBreakfast;
String hotelParking;
String hotelAccessibility;
String hotelAC;
String hotelFitness;
String hotelLaundry;
String hotelPool;
String hotelSpa;
String hotelTransportation;
String hotelHighlight1;
String hotelHighlight2;

class _HotelInfoPageState extends State<HotelInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new FutureBuilder(
              future: _getHotelName(),
              initialData: "Loading text..",
              builder: (BuildContext context, AsyncSnapshot<String> text) {
                return RichText(
                  text: TextSpan(
                      text: "About ",
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: " ${text.data}",
                            style: TextStyle(fontStyle: FontStyle.italic))
                      ]),
                );
              }),
        ),
        body: Center(
            child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: Text(
                "Details:",
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: new FutureBuilder(
                  future: _getHotelInfo(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Text(
                      text.data,
                      style: TextStyle(fontSize: 17),
                    );
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: Text(
                "Highlights:",
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelHightlight1(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.local_dining),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelHighlight2(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.room_service),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: Text(
                "Amenities:",
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelBreakfast(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.free_breakfast),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelWiFi(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.wifi),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelParking(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.local_parking),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelAccessibility(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.accessible),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelAC(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.ac_unit),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelFitness(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.fitness_center),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelLaudnry(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.local_laundry_service),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelPool(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.pool),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelSpa(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.spa),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              child: new FutureBuilder(
                  future: _getHotelTransportation(),
                  initialData: "Loading information...",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Row(children: <Widget>[
                      Icon(Icons.airport_shuttle),
                      SizedBox(width: 10),
                      Text(
                        text.data,
                        style: TextStyle(fontSize: 15),
                      )
                    ]);
                  }),
            ),
          ],
        )));
  }

  Future<String> _getHotelName() async {
    try {
      // get current user
      FirebaseUser user = await _auth.currentUser();
      // set up correct path to the user in the database
      DatabaseReference _userRef =
          _firebaseDatabase.reference().child("users").child(user.uid);

      await _userRef.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        hotelName = values["current_hotel"];
      });

      return hotelName;
    } catch (e) {
      print('Error occured while reading hotel name');
      return "Error";
    }
  }

  Future<String> _getHotelInfo() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("common_info");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelInfo = snapshot.value;
      });

      return hotelInfo;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelWiFi() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("internet");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelWiFi = snapshot.value;
      });

      return hotelWiFi;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelBreakfast() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("food");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelBreakfast = snapshot.value;
      });

      return hotelBreakfast;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelParking() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("parking");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelParking = snapshot.value;
      });

      return hotelParking;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelAccessibility() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("accessibility");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelAccessibility = snapshot.value;
      });

      return hotelAccessibility;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelAC() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("air_conditioning");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelAC = snapshot.value;
      });

      return hotelAC;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelFitness() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("fitness");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelFitness = snapshot.value;
      });

      return hotelFitness;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelLaudnry() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("laundry");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelLaundry = snapshot.value;
      });

      return hotelLaundry;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelPool() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("pool");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelPool = snapshot.value;
      });

      return hotelPool;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelSpa() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("spa");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelSpa = snapshot.value;
      });

      return hotelSpa;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelTransportation() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("transportation");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelTransportation = snapshot.value;
      });

      return hotelTransportation;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelHightlight1() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("highlights")
          .child("dining");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelHighlight1 = snapshot.value;
      });

      return hotelHighlight1;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }

  Future<String> _getHotelHighlight2() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("information")
          .child("highlights")
          .child("service");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        hotelHighlight2 = snapshot.value;
      });

      return hotelHighlight2;
    } catch (e) {
      print('Error occured while reading hotel info');
      return "Error";
    }
  }
}
