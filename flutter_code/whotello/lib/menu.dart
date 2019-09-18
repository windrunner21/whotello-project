import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:whotello/request.dart';
import 'profile.dart';
import 'map.dart';
import 'hotelinfo.dart';
import 'request.dart';
import 'reservations.dart';
import 'events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'themewidget.dart';
import 'package:carousel_slider/carousel_slider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
final StorageReference storageRef =
    FirebaseStorage.instance.ref().child("Bilkent Hotel");

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

List<String> imagesList = [];

// first name
const String _bot = "uRobo";
const String _appBarTitle = "My Room";
int temperature = 20;
String roomCode;
String hotelName;
String fullName;
String phoneNumber;
String faxNumber;
String emergencyNumber;

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static const platform = const MethodChannel('com.example.whotello/infrared');

  List<Widget> messagePerson = new List();
  ScrollController _controller = ScrollController();

  List<Icon> iconList = [
    Icon(Icons.event),
    Icon(Icons.info),
    Icon(Icons.map),
    Icon(Icons.assignment),
    Icon(Icons.perm_phone_msg),
    Icon(Icons.restaurant)
  ];

  var _messageController = TextEditingController();

  var choicesList = ["Appearance", "Logout"];

  var hotelGridList = [
    'Events',
    'Hotel Information',
    'Map',
    'Requests',
    'Reservations',
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          // The number of tabs / content sections to display.
          length: 3,
          initialIndex: 1,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                _appBarTitle,
              ),
              automaticallyImplyLeading: true,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: new Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      child: new FutureBuilder(
                          future: _getFullName(),
                          initialData: "Y",
                          builder: (BuildContext context,
                              AsyncSnapshot<String> text) {
                            return new Text(text.data[0]);
                          }),
                    ),
                  )),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.group_add,
                    ),
                    onPressed: () {
                      _settingModalBottomSheet(context);
                    }),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                  ),
                  onPressed: _showDialog,
                ),
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
                  child: Icon(
                    Icons.settings,
                  ),
                ),
              ],
            ),
            body: TabBarView(
              children: [
                Scaffold(
                  body: CustomScrollView(slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Theme.of(context).canvasColor,
                      title: new FutureBuilder(
                          future: _getHotelName(),
                          initialData: "Loading text..",
                          builder: (BuildContext context,
                              AsyncSnapshot<String> text) {
                            return Text(
                              'Welcome to ${text.data}!',
                              style: TextStyle(inherit: true, shadows: [
                                Shadow(
                                    // bottomLeft
                                    offset: Offset(-1.5, -1.5),
                                    color: Colors.black),
                                Shadow(
                                    // bottomRight
                                    offset: Offset(1.5, -1.5),
                                    color: Colors.black),
                                Shadow(
                                    // topRight
                                    offset: Offset(1.5, 1.5),
                                    color: Colors.black),
                                Shadow(
                                    // topLeft
                                    offset: Offset(-1.5, 1.5),
                                    color: Colors.black),
                              ]),
                            );
                          }),
                      floating: true,
                      flexibleSpace: new FutureBuilder(
                          future: _settingList(imagesList),
                          initialData: imgList,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> list) {
                            return CarouselSlider(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              height: 200.0,
                              items: list.data.map(
                                (url) {
                                  return Container(
                                    margin: EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      child: Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                        width: 1000.0,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          }),
                      expandedHeight: 200,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(
                          leading: iconList[index],
                          title: Text(hotelGridList[index]),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventsPage()));
                            }

                            if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HotelInfoPage()),
                              );
                            }

                            if (index == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapPage()),
                              );
                            }

                            if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RequestPage()),
                              );
                            }

                            if (index == 4) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReservationsPage()),
                              );
                            }
                          },
                          onLongPress: () {},
                        ),
                        childCount: hotelGridList.length,
                      ),
                    )
                  ]),
                ),
                ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: <Widget>[
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(
                              Icons.vpn_key,
                            ),
                            title: Text(
                              'Door',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Lock or unlock your hotel room.'),
                          ),
                          ButtonTheme.bar(
                            // make buttons use the appropriate styles for cards
                            child: ButtonBar(
                              children: <Widget>[
                                Text("Lock:"),
                                IconButton(
                                  icon: Icon(
                                    Icons.lock,
                                  ),
                                  onPressed: () {},
                                ),
                                Text("Unlock:"),
                                IconButton(
                                  icon: Icon(
                                    Icons.lock_open,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(
                              Icons.ac_unit,
                            ),
                            title: Text(
                              'Air Conditioner',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                'Remote control Air Conditioner in your room.'),
                          ),
                          ButtonTheme.bar(
                            // make buttons use the appropriate styles for cards
                            child: ButtonBar(
                              children: <Widget>[
                                Text("Power:"),
                                IconButton(
                                  icon: Icon(Icons.power_settings_new),
                                  onPressed: () {
                                    _sendTVIRPower();
                                    if (temperature == 40) {
                                      _sendACIRPower();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          ButtonBar(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  temperature.toString() + " Ce",
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 20),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text("Temperature: "),
                              ButtonTheme.bar(
                                // make buttons use the appropriate styles for cards
                                child: ButtonBar(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_up,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (temperature != 40) {
                                            temperature++;
                                            _sendTVIRChannelUp();
                                          } else {
                                            _sendACIRTempUp();
                                          }
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (temperature != 16) {
                                            temperature--;
                                            _sendTVIRChannelDown();
                                          } else {
                                            _sendACIRTempDown();
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(
                              Icons.lightbulb_outline,
                            ),
                            title: Text(
                              'Lights',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle:
                                Text('Remote control lights in your room.'),
                          ),
                          ButtonTheme.bar(
                            // make buttons use the appropriate styles for cards
                            child: ButtonBar(
                              children: <Widget>[
                                Text("Power:"),
                                IconButton(
                                  icon: Icon(Icons.power_settings_new),
                                  onPressed: () {/* ... */},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(
                              Icons.tv,
                            ),
                            title: Text(
                              'Television',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Remote control TV in your room.'),
                          ),
                          ButtonTheme.bar(
                              // make buttons use the appropriate styles for cards
                              child: ButtonBar(children: <Widget>[
                            Text("Power:"),
                            IconButton(
                              icon: Icon(Icons.power_settings_new),
                              onPressed: _sendTVIRPower,
                            ),
                          ])),
                          ButtonBar(
                            children: <Widget>[
                              Text("Volume:"),
                              IconButton(
                                icon: Icon(
                                  Icons.volume_up,
                                ),
                                onPressed: _sendTVIRVolumeUp,
                              ),
                              Text("Channel:"),
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_up,
                                ),
                                onPressed: _sendTVIRChannelUp,
                              ),
                            ],
                          ),
                          ButtonBar(
                            children: <Widget>[
                              Text("Volume:"),
                              IconButton(
                                icon: Icon(
                                  Icons.volume_down,
                                ),
                                onPressed: _sendTVIRVolumeDown,
                              ),
                              Text("Channel:"),
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                onPressed: _sendTVIRChannelDown,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                        child: new ListView.builder(
                      controller: _controller,
                      itemBuilder: (context, index) {
                        Widget widget = messagePerson.elementAt(index);
                        return widget;
                      },
                      itemCount: messagePerson.length,
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.clear_all,
                          ),
                          onPressed: () {
                            messagePerson.clear();
                            setState(() {});
                          },
                        ),
                        Flexible(
                          child: TextField(
                            decoration:
                                InputDecoration(hintText: "Enter Message"),
                            controller: _messageController,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            messagePerson.add(new Padding(
                                padding: EdgeInsets.all(8.0),
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      margin:
                                          const EdgeInsets.only(right: 16.0),
                                      child: new CircleAvatar(
                                        child: new FutureBuilder(
                                            future: _getFullName(),
                                            initialData: "Y",
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String> text) {
                                              return new Text(text.data[0]);
                                            }),
                                      ),
                                    ),
                                    new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new FutureBuilder(
                                            future: _getFullName(),
                                            initialData: "You",
                                            builder: (BuildContext context,
                                                AsyncSnapshot<String> text) {
                                              return new Text(
                                                  text.data.split(" ")[0],
                                                  style: new TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17));
                                            }),
                                        new Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            margin:
                                                const EdgeInsets.only(top: 5.0),
                                            child: new Text(
                                              _messageController.text,
                                              softWrap: true,
                                            )),
                                      ],
                                    ),
                                  ],
                                )));
                            postRequest();
                            _messageController.clear();
                            setState(() {
                              _controller
                                  .jumpTo(_controller.position.maxScrollExtent);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            bottomNavigationBar: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                ),
                Tab(icon: Icon(Icons.hotel, color: Colors.black)),
                Tab(icon: Icon(Icons.question_answer, color: Colors.black)),
              ],
            ),
          )),
    );
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

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Contact Information:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: new Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              new FutureBuilder(
                  future: _getPhoneNumber(),
                  initialData: "Loading number..",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Text(
                      text.data,
                    );
                  }),
              new FutureBuilder(
                  future: _getFaxNumber(),
                  initialData: "Loading number..",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Text(
                      text.data,
                    );
                  }),
              SizedBox(height: 12),
              Text(
                "Emergency Contacts:",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              new FutureBuilder(
                  future: _getEmergencyNumber(),
                  initialData: "Loading number..",
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return Text(
                      text.data,
                    );
                  }),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _getRoomCode() async {
    if (roomCode == null) {
      try {
        // get current user
        FirebaseUser user = await _auth.currentUser();
        // set up correct path to the user in the database
        DatabaseReference _userRef =
            _firebaseDatabase.reference().child("users").child(user.uid);

        await _userRef.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> values = snapshot.value;
          roomCode = values["room_code"];
        });

        return roomCode;
      } catch (e) {
        print('Error occurred while reading room code');
        return null;
      }
    }
    return roomCode;
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

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new Padding(
                    padding: EdgeInsets.only(
                        left: 40, right: 40, top: 40, bottom: 10),
                    child: new Center(
                      child: new Text(
                        "Add people to your room:",
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                new Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: new Center(
                        child: new FutureBuilder(
                            future: _getRoomCode(),
                            initialData: "Loading text..",
                            builder: (BuildContext context,
                                AsyncSnapshot<String> text) {
                              return new QrImage(
                                data: text.data,
                                size: 200.0,
                                backgroundColor: Colors.white,
                              );
                            }))),
              ],
            ),
          );
        });
  }

  Future<int> postRequest() async {
    var url = 'https://whotello-chatbot-api.herokuapp.com/chatbot-main';

    Map data = {"question_str": _messageController.text, "hotel_name": "Flask"};

    //encode Map to JSON
    var body = json.encode(data);
    print(body);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    final responseJson = json.decode(response.body);
    var botResponse = responseJson['response'];

    messagePerson.add(new Padding(
        padding: EdgeInsets.all(8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                child: new Icon(Icons.face),
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_bot,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17)),
                new Container(
                  width: MediaQuery.of(context).size.width / 2,
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    botResponse,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ],
        )));
    setState(() {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });

    return response.statusCode;
  }

  Future<void> _sendTVIRPower() async {
    try {
      await platform.invokeMethod('sendTVIRPower');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _sendTVIRVolumeUp() async {
    try {
      await platform.invokeMethod('sendTVIRVolumeUp');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _sendTVIRVolumeDown() async {
    try {
      await platform.invokeMethod('sendTVIRVolumeDown');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _sendTVIRChannelUp() async {
    try {
      await platform.invokeMethod('sendTVIRChannelUp');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _sendTVIRChannelDown() async {
    try {
      await platform.invokeMethod('sendTVIRChannelDown');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _sendACIRPower() async {
    try {
      await platform.invokeMethod('sendACIRPower');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _sendACIRTempUp() async {
    try {
      await platform.invokeMethod('sendACIRTempUp');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _sendACIRTempDown() async {
    try {
      await platform.invokeMethod('sendACIRTempDown');
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<List<String>> _settingList(List<String> urls) async {
    if (urls.length == 0) {
      for (int i = 1; i < 5; i++) {
        var url =
            await storageRef.child(i.toString() + ".jpg").getDownloadURL();
        urls.add(url);
      }
    }

    return urls;
  }

  Future<String> _getPhoneNumber() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("contact_information");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        phoneNumber = values["phone_number"];
      });
      return phoneNumber;
    } catch (e) {
      print('Error occured while reading hotel contact info');
      return null;
    }
  }

  Future<String> _getFaxNumber() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("contact_information");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        faxNumber = values["fax_number"];
      });
      return faxNumber;
    } catch (e) {
      print('Error occured while reading hotel contact info');
      return null;
    }
  }

  Future<String> _getEmergencyNumber() async {
    try {
      // set up correct path to the user in the database
      DatabaseReference _hotelRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("contact_information");

      await _hotelRef.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        emergencyNumber = values["emergency_number"];
      });
      return emergencyNumber;
    } catch (e) {
      print('Error occured while reading hotel contact info');
      return null;
    }
  }
}
