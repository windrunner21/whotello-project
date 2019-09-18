import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

String buttonName = 'Pick Date and Time';

class ReservationFormPage extends StatefulWidget {
  @override
  _ReservationFormPageState createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  var _index = 0;
  String hotelName;
  String onlyDate;

  // getting info from the steps
  final TextEditingController _numberOfPeopleController =
      TextEditingController();
  String dropdownValue = 'The North Shield Restaurant';
  String dateAndTime;
  String onlyTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservation Form"),
      ),
      body: new Center(
          child: new Stepper(
        steps: [
          Step(
            title: Text("Choose an activity"),
            subtitle: Text("List of available activities is provided below"),
            content: DropdownButton<String>(
              value: dropdownValue,
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              isExpanded: true,
              items: <String>[
                'The North Shield Restaurant',
                'Akdeniz Mutfagi Restaurant',
                'Alis Patisserie Restaurant',
                'Sanitas SPA'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            isActive: _index >= 0,
          ),
          Step(
            title: Text("Enter number of people"),
            subtitle: Text("Provide number of people involved"),
            content: TextField(
              controller: _numberOfPeopleController,
              keyboardType: TextInputType.number,
            ),
            isActive: _index >= 1,
          ),
          Step(
            title: Text("Pick a time slot"),
            subtitle: Text("Pick an available date and time for you activity"),
            isActive: _index >= 2,
            content: FlatButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onChanged: (date) {
                    dateAndTime = date.toString().split(".")[0].split(":")[0] +
                        ":" +
                        date.toString().split(".")[0].split(":")[1];
                    onlyDate = dateAndTime.split(" ")[0];
                    onlyTime = dateAndTime.split(" ")[1];
                    setState(() {
                      buttonName = "Date: " + onlyDate + "\nTime: " + onlyTime;
                    });
                  }, onConfirm: (date) {
                    dateAndTime = date.toString().split(".")[0].split(":")[0] +
                        ":" +
                        date.toString().split(".")[0].split(":")[1];
                    onlyDate = dateAndTime.split(" ")[0];
                    onlyTime = dateAndTime.split(" ")[1];
                    setState(() {
                      buttonName = "Date: " + onlyDate + "\nTime: " + onlyTime;
                    });
                  }, currentTime: DateTime.now());
                },
                child: Text(
                  buttonName,
                  style: TextStyle(color: Colors.blue),
                )),
          ),
        ],
        currentStep: _index,
        onStepTapped: (index) {
          setState(() {
            _index = index;
          });
        },
        onStepCancel: () {
          setState(() {
            if (_index != 0) {
              _index--;
            }
          });
        },
        onStepContinue: () {
          setState(() {
            if (_index != 2) {
              _index++;
            }
          });
        },
      )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (dropdownValue != null &&
              _numberOfPeopleController.text != null &&
              onlyDate != null &&
              onlyTime != null) {
            _reservation(dropdownValue, _numberOfPeopleController.text,
                onlyDate, onlyTime);
            Navigator.of(context).pop();
          }
        },
        label: Text('Complete reservation'),
        icon: Icon(Icons.library_add),
        backgroundColor: Colors.green,
      ),
    );
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

  void _reservation(
      String option, String number, String date, String time) async {
    try {
      // get current user
      FirebaseUser user = await _auth.currentUser();
      // set up correct path to the user in the database
      DatabaseReference _userRequestRef = _firebaseDatabase
          .reference()
          .child("hotels")
          .child(await _getHotelName())
          .child("reservations")
          .child(user.uid)
          .child(option);

      await _userRequestRef.set({
        "number_of_people": "" + number,
        "requested_date": "" + date,
        "requested_time": "" + time,
      }).then((_) {
        print('Transaction committed.');
      });
    } catch (e) {
      print(e);
    }
  }
}
