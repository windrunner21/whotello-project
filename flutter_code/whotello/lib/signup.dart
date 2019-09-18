import 'package:flutter/material.dart';
import 'qrcode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberContoller = TextEditingController();

  bool _success;
  String _userEmail;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Center(
            child: new ListView(children: <Widget>[
          Center(
              child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(children: <Widget>[
                    TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                          labelText: "Full Name", icon: Icon(Icons.person)),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: "E-mail", icon: Icon(Icons.email)),
                    ),
                    TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: "Password", icon: Icon(Icons.lock)),
                    ),
                    TextField(
                      controller: _phoneNumberContoller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Phone Number", icon: Icon(Icons.phone)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('SIGN UP'),
                      onPressed: () {
                        _register();
                      },
                      elevation: 8.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          _success == null
                              ? ''
                              : (_success
                                  ? 'Successfully registered ' + _userEmail
                                  : 'Registration failed'),
                          style: TextStyle(color: Colors.red),
                        ))
                  ])))
        ])));
  }

  void _register() async {
    try {
      final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
        });

        DatabaseReference _userRef =
            _firebaseDatabase.reference().child("users").child(user.uid);

        await _userRef.set({
          "full_name": "" + _fullNameController.text,
          "phone_number": "" + _phoneNumberContoller.text,
          "current_hotel": "Currently you are not staying in a hotel",
          "room_number": "Currently you are not staying in a hotel",
        }).then((_) {
          print('Transaction  committed.');
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BasePage()),
        );
      }
    } catch (e) {
      setState(() {
        _success = false;
      });
    }
  }
}
