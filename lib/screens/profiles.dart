import 'package:flutter/material.dart';
import 'package:soteriax/screens/mainMenu.dart';
import 'package:soteriax/screens/login.dart';
import 'package:flutter/services.dart';

class Profiles extends StatefulWidget {
  const Profiles({Key? key}) : super(key: key);

  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  // final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange.shade800,
                    Colors.orange.shade700,
                  ]),
            ),
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(0),
            color: Colors.white,
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(0),
                      height: 100,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 3,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.orange.shade700,
                                Colors.orange.shade600,
                                // Colors.orange.shade400
                              ]),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(120),
                          )),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "Ashan-LF03",
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.bookmark,
                        size: 30,
                        color: Colors.orange.shade900,
                      ),
                      labelText: 'Username',
                      // border: OutlineInputBorder(
                      // ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "Asanka Silva",
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle,
                          size: 30, color: Colors.orange.shade900),
                      labelText: 'Full Name',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "AsankaSilva@gmail.com ",
                    decoration: InputDecoration(
                      icon: Icon(Icons.email,
                          size: 30, color: Colors.orange.shade900),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "28",
                    decoration: InputDecoration(
                      icon: Icon(Icons.accessibility_outlined,
                          size: 30, color: Colors.orange.shade900),
                      labelText: 'Age',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "14",
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_tree_outlined,
                          size: 30, color: Colors.orange.shade900),
                      labelText: 'Participated Operation count ',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () {},
                  height: 50,
                  minWidth: 220,
                  color: Colors.orange.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
