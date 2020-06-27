import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final ThemeData themeData;
  LoginScreen({
    this.themeData,
  });
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _studentNameController = TextEditingController();
  void setdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _studentNameController.text = prefs.getString('name');
  }

  @override
  void initState() {
    super.initState();
    setdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.themeData.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: widget.themeData.accentColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'User Info',
          style: widget.themeData.textTheme.headline,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: widget.themeData.primaryColor,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _studentNameController,
              style: widget.themeData.textTheme.body2,
              decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: widget.themeData.textTheme.body2,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              highlightColor: Colors.white,
              textColor: Colors.grey[700],
              color: Colors.white,
              splashColor: Colors.lightBlueAccent,
              child: Text('Save'),
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                  prefs.setString('name', _studentNameController.text);
                Navigator.pop(context,true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
