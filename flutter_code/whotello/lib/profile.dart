import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

const String _personalPref = "Room Preferences:";
String email;
String fullName;
String hotelName;
String hotelRoom;
String prefTemp;

class _ProfilePageState extends State<ProfilePage> {
  final items = List<String>.generate(1, (i) => "Preference Set #${i + 1}");

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new CircleAvatar(
              radius: 40,
              child: new FutureBuilder(
                  future: _getFullName(),
                  initialData: "You",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return new Text(
                      text.data[0],
                      style: TextStyle(fontSize: 40),
                    );
                  }),
            ),
            SizedBox(height: 12.0),
            FutureBuilder(
                future: _getFullName(),
                initialData: "Loading your full name",
                builder: (BuildContext context, AsyncSnapshot<String> text) {
                  return new Text(
                    text.data,
                    style: TextStyle(fontSize: 20),
                  );
                }),
            SizedBox(height: 40.0),
            Divider(indent: 15, endIndent: 15, height: 5, color: Colors.blue),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 15, right: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.email),
                    SizedBox(width: 10.0),
                    FutureBuilder(
                        future: _getEmail(),
                        initialData: "Loading your e-mail",
                        builder:
                            (BuildContext context, AsyncSnapshot<String> text) {
                          return new Text(text.data);
                        }),
                  ],
                )),
            Divider(indent: 15, endIndent: 15, height: 5, color: Colors.blue),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 15, right: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.home),
                    SizedBox(width: 10.0),
                    FutureBuilder(
                        future: _getHotelName(),
                        initialData: "Loading your e-mail",
                        builder:
                            (BuildContext context, AsyncSnapshot<String> text) {
                          return new Text(text.data);
                        }),
                  ],
                )),
            Divider(indent: 15, endIndent: 15, height: 5, color: Colors.blue),
            Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 15, right: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.hotel),
                    SizedBox(width: 10.0),
                    FutureBuilder(
                        future: _getRoom(),
                        initialData: "Loading your e-mail",
                        builder:
                            (BuildContext context, AsyncSnapshot<String> text) {
                          return new Text(text.data);
                        }),
                  ],
                )),
            Divider(indent: 15, endIndent: 15, height: 5, color: Colors.blue),
            SizedBox(height: 20.0),
            Padding(
                padding: EdgeInsets.only(left: 15, right: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      _personalPref.toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            SizedBox(height: 20.0),
            new Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: Key(item),
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      setState(() {
                        items.removeAt(index);
                      });
                      // Then show a snackbar.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("$item deleted")));
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Remove",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "Remove",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                    child: FutureBuilder(
                        future: _getPreferences(),
                        initialData: "Preference Set",
                        builder:
                            (BuildContext context, AsyncSnapshot<String> text) {
                          return new ListTile(
                            title: Text(text.data),
                            subtitle: Text('Air Conditioner Temperature.'),
                            isThreeLine: true,
                            onTap: () {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Preference applied")));
                            },
                          );
                        }),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> _getFullName() async {
    if (fullName == null) {
      try {
        // get current user
        FirebaseUser user = await _auth.currentUser();
        // set up correct path to the user in the database
        DatabaseReference _userRef =
            _firebaseDatabase.reference().child("users").child(user.uid);

        await _userRef.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> values = snapshot.value;
          fullName = values["full_name"];
        });

        return fullName;
      } catch (e) {
        print('Error while reading full name');
        return 'Try again';
      }
    }
    return fullName;
  }

  Future<String> _getEmail() async {
    try {
      // get current user
      FirebaseUser user = await _auth.currentUser();

      return user.email;
    } catch (e) {
      print('Error while reading email');
      return 'Try again';
    }
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

  Future<String> _getRoom() async {
    try {
      // get current user
      FirebaseUser user = await _auth.currentUser();
      // set up correct path to the user in the database
      DatabaseReference _userRef =
          _firebaseDatabase.reference().child("users").child(user.uid);

      await _userRef.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        hotelRoom = "Room " + values["room_number"].toString();
      });
      return hotelRoom;
    } catch (e) {
      print('Error occured while reading hotel name');
      return null;
    }
  }

  Future<String> _getPreferences() async {
    try {
      // get current user
      FirebaseUser user = await _auth.currentUser();
      // set up correct path to the user in the database
      DatabaseReference _userRef = _firebaseDatabase
          .reference()
          .child("users")
          .child(user.uid)
          .child("preferences")
          .child("air_conditioning");

      await _userRef.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        prefTemp = "Temperature is set to " +
            values["temperature"].toString() +
            " degrees";
      });
      return prefTemp;
    } catch (e) {
      print('Error occured while reading hotel name');
      return null;
    }
  }
}
