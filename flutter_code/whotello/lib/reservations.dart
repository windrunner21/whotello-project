import 'package:flutter/material.dart';
import 'reservationform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
String hotelName;

class Item {
  String expandedValue1;
  String expandedValue2;
  String expandedValue3;
  String headerValue;
  bool isExpanded;

  Item({
    this.expandedValue1,
    this.expandedValue2,
    this.expandedValue3,
    this.headerValue,
    this.isExpanded = false,
  });

  Item.fromDB(MapEntry key) {
    this.headerValue = key.key;
    this.expandedValue1 = "Reservation time: " + key.value['requested_time'];
    this.expandedValue2 = "Reservation date: " + key.value["requested_date"];
    this.expandedValue3 =
        "Number people going: " + key.value["number_of_people"];
    this.isExpanded = false;
  }
}

List<Item> globalList = new List<Item>();

Future<List<Item>> generateItems() async {
  List<Item> list = new List<Item>();
  return _getReservationInfo(list);
}

class ReservationsPage extends StatefulWidget {
  @override
  _ReservationsPageState createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservations"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          FutureBuilder(
              future: generateItems(),
              initialData: new List<Item>(),
              builder: (BuildContext context, AsyncSnapshot<List<Item>> _data) {
                return new ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _data.data[index].isExpanded = !isExpanded;
                    });
                  },
                  children: _data.data.map<ExpansionPanel>((Item item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: Icon(Icons.book),
                          title: Text(
                            item.headerValue,
                            style: TextStyle(
                                fontSize: 17,
                                decoration: TextDecoration.underline),
                          ),
                        );
                      },
                      body: Column(children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.access_time),
                          title: Text(item.expandedValue1),
                        ),
                        ListTile(
                          leading: Icon(Icons.date_range),
                          title: Text(item.expandedValue2),
                        ),
                        ListTile(
                          leading: Icon(Icons.people),
                          title: Text(item.expandedValue3),
                        ),
                        ListTile(
                            subtitle: Text(
                                'To cancel reservation, tap the delete icon'),
                            trailing: Icon(Icons.delete, color: Colors.red),
                            onTap: () {
                              _removeReservation(item.headerValue);
                              setState(() {
                                _data.data.removeWhere(
                                    (currentItem) => item == currentItem);
                              });
                            })
                      ]),
                      isExpanded: item.isExpanded,
                    );
                  }).toList(),
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReservationFormPage()),
          );
        },
        label: Text('Add reservation'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
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
    return null;
  }
}

Future<List<Item>> _getReservationInfo(List<Item> listItems) async {
  try {
    FirebaseUser user = await _auth.currentUser();
    // set up correct path to the user in the database
    DatabaseReference _userRef = _firebaseDatabase
        .reference()
        .child("hotels")
        .child(await _getHotelName())
        .child("reservations")
        .child(user.uid);

    await _userRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      for (var key in values.entries) {
        Item item = new Item.fromDB(key);
        listItems.add(item);
      }
    });

    if (listItems.length != globalList.length) {
      globalList = listItems;
    }

    return globalList;
  } catch (e) {
    print('Error occured while reading reservations info');
    return null;
  }
}

void _removeReservation(String reservationName) async {
  try {
    FirebaseUser user = await _auth.currentUser();
    // set up correct path to the user in the database
    DatabaseReference _userRef = _firebaseDatabase
        .reference()
        .child("hotels")
        .child(await _getHotelName())
        .child("reservations")
        .child(user.uid)
        .child(reservationName);

    _userRef.remove().then((_) {
      print("Delete successful");
    });
  } catch (e) {
    print('Error occured while removing reservation');
  }
}
