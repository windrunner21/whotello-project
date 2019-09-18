import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'qrcode.dart';
import 'menu.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
bool _obscureText = true;
bool _obscureIcon = true;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              primarySwatch: Colors.blue,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'Whotello',
            theme: theme,
            home: new MyHomePage(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  bool _success;
  String _userEmail;

  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuPage()),
        );
      }
    });
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: new ListView(shrinkWrap: true, children: <Widget>[
      Center(
        child: new Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/logo.png",
                height: 150,
                width: 150,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "E-mail", icon: Icon(Icons.email)),
              ),
              Row(
                children: <Widget>[
                  new Flexible(
                      child: TextField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: "Password", icon: Icon(Icons.lock)),
                  )),
                  IconButton(
                    icon: Icon(
                      _obscureIcon ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                        _obscureIcon = !_obscureIcon;
                      });
                    },
                  ),
                ],
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text('CANCEL'),
                    onPressed: () {},
                  ),
                  RaisedButton(
                    child: Text('NEXT'),
                    onPressed: () {
                      _signInWithEmailAndPassword();
                    },
                    elevation: 8.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    color: Colors.blue,
                    textColor: Colors.white,
                  )
                ],
              ),
              FlatButton(
                child: Text("Do not have an account?"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _success == null
                      ? ''
                      : (_success
                          ? 'Successfully signed in ' + _userEmail
                          : 'E-mail or Password is incorrect'),
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    ])));
  }

  void _signInWithEmailAndPassword() async {
    try {
      final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
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
