import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

String time = "";
String timeString = "Select Time";
String hotelName;

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  var gridIndex = 0;

  List<bool> _requestBoolean = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  var _requestList = [
    "Breakfast",
    "Dinner",
    "Drinks",
    "Cleaning",
    "Medicine",
    "Doctor",
    "Help",
  ];

  var _requestPhoto = [
    'assets/breakfast.jpg',
    'assets/dinner.jpg',
    'assets/drinks.jpg',
    'assets/cleaning.jpg',
    'assets/medicine.jpg',
    'assets/doctor.jpg',
    'assets/logo.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Requests",
        ),
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
          child: Row(
            children: <Widget>[
              Icon(Icons.filter_1),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Please pick a service you require:",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
        GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: _requestList.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return new GestureDetector(
                  child: new Card(
                    color: _requestBoolean[index]
                        ? Colors.greenAccent
                        : Theme.of(context).cardColor,
                    clipBehavior: Clip.antiAlias,
                    elevation: 5.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 18.0 / 11.0,
                          child: Image.asset(
                            _requestPhoto[index],
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                _requestList[index],
                                style: TextStyle(letterSpacing: 1),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'To room delivery',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    gridIndex = index;
                    _requestBoolean[index] = !_requestBoolean[index];

                    for (int i = 0; i < _requestBoolean.length; i++) {
                      if (i != index) {
                        _requestBoolean[i] = false;
                      }
                      if (i == index) {
                        _requestBoolean[i] = true;
                      }
                    }
                    setState(() {});
                  });
            }),
        Padding(
            padding: EdgeInsets.only(top: 10, left: 5, right: 5),
            child: Center(
              child: Text(
                "Hint: You are requesting ${_requestList[gridIndex]}",
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
          child: Row(
            children: <Widget>[
              Icon(Icons.filter_2),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Please pick service arrival time:",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
                child: Wrap(
              direction: Axis.vertical,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Arrival Time:",
                        style: TextStyle(fontSize: 18),
                      ),
                      FlatButton(
                          onPressed: () {
                            DatePicker.showTimePicker(context,
                                showTitleActions: true,
                                onChanged: (date) {}, onConfirm: (date) {
                              time = date
                                      .toString()
                                      .split(" ")[1]
                                      .split(".")[0]
                                      .split(":")[0] +
                                  ":" +
                                  date
                                      .toString()
                                      .split(" ")[1]
                                      .split(".")[0]
                                      .split(":")[1];

                              setState(() {
                                timeString = time;
                              });
                            }, currentTime: DateTime.now());
                          },
                          child: Text(
                            timeString,
                            style: TextStyle(fontSize: 18),
                          ))
                    ],
                  ),
                )
              ],
            )),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
          child: Row(
            children: <Widget>[
              Icon(Icons.filter_3),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Complete your request:",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
        new RaisedButton(
          color: Colors.green,
          child: Text(
            'SEND REQUEST',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _request(_requestList[gridIndex], time);
          },
        ),
      ]),
    );
  }

  Future<String> _getHotelName() async {
    if (hotelName == null) {
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
        return null;
      }
    }
    return hotelName;
  }

  void _request(String option, String time) async {
    try {
      // get current user
      FirebaseUser user = await _auth.currentUser();
      // set up correct path to the user in the database
      DatabaseReference _userRequestRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("requests")
          .child(user.uid)
          .child(option);

      await _userRequestRef.set({
        "requested_time": "" + time,
      }).then((_) {
        print('Transaction committed.');
      });
    } catch (e) {
      print(e);
    }
  }
}
