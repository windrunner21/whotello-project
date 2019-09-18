import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
String hotelName;

class Event {
  String name;
  String date;
  String information;
  String url;
  bool isExpanded;

  Event({
    this.name,
    this.date,
    this.information,
    this.url,
    this.isExpanded = false,
  });

  Event.fromDB(MapEntry key) {
    this.name = key.key;
    this.date = key.value["date"];
    this.information = key.value["information"];
    this.url = key.value["url"];
    this.isExpanded = false;
  }
}

List<Event> globalList = new List<Event>();

Future<List<Event>> generateItems() async {
  List<Event> list = new List<Event>();
  return _getEventsInfo(list);
}

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
      ),
      body: ListView(padding: const EdgeInsets.all(8.0), children: <Widget>[
        FutureBuilder(
            future: generateItems(),
            initialData: new List<Event>(),
            builder: (BuildContext context, AsyncSnapshot<List<Event>> _data) {
              return new Padding(
                  padding: EdgeInsets.all(8),
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _data.data[index].isExpanded = !isExpanded;
                      });
                    },
                    children: _data.data.map<ExpansionPanel>((Event item) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                              leading: Icon(Icons.weekend),
                              title: Text(
                                item.name,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: item.isExpanded
                                        ? Colors.purple
                                        : Colors.black),
                              ));
                        },
                        isExpanded: item.isExpanded,
                        body: Column(children: <Widget>[
                          Padding(
                            child: Image.network(
                              item.url,
                              height: 100,
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                          ListTile(
                              leading: Icon(Icons.date_range),
                              title: Text(item.date),
                              onTap: () {}),
                          ListTile(
                              leading: Icon(Icons.info),
                              title: Text(item.information),
                              onTap: () {}),
                        ]),
                      );
                    }).toList(),
                  ));
            })
      ]),
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

Future<List<Event>> _getEventsInfo(List<Event> listEvent) async {
  try {
    // set up correct path to the user in the database
    DatabaseReference _hotelRef = _firebaseDatabase
        .reference()
        .child("hotels")
        .child(await _getHotelName())
        .child("events");

    await _hotelRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      for (var key in values.entries) {
        Event event = new Event.fromDB(key);
        listEvent.add(event);
      }
    });

    if (listEvent.length != globalList.length) {
      globalList = listEvent;
    }

    return globalList;
  } catch (e) {
    print('Error occured while reading hotel\'s events');
    return null;
  }
}
