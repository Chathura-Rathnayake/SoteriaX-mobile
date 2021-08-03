import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soteriax/models/lifeguard.dart';
import 'package:soteriax/services/sharedpreference_manager.dart';

class Profiles extends StatefulWidget {
  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  Lifeguard? lifeguard;
  late Map<String, dynamic> lifeguardMap;


  @override
  void initState()  {
    // TODO: implement initState
    // setLifeguard();
    super.initState();
    final String lifeguardString=SharedPreferenceManager.getString("lifeguardData");
    print(lifeguardString);
    lifeguardMap=jsonDecode(lifeguardString) as Map<String, dynamic>;
    lifeguard=Lifeguard.fromJson(lifeguardMap);

  }

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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "${lifeguard!.firstname} ${lifeguard!.lastname}",
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
                    initialValue: "${lifeguard!.email}",
                    decoration: InputDecoration(
                      icon: Icon(Icons.email,
                          size: 30, color: Colors.orange.shade900),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "${lifeguard!.certificateLevel}",
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.bookmark,
                        size: 30,
                        color: Colors.orange.shade900,
                      ),
                      labelText: 'Certification Level',
                      // border: OutlineInputBorder(
                      // ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "${lifeguard!.birthDate}",
                    decoration: InputDecoration(
                      icon: Icon(Icons.accessibility_outlined,
                          size: 30, color: Colors.orange.shade900),
                      labelText: 'Birth Date',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextFormField(
                    readOnly: true,
                    initialValue: "${lifeguard!.noOfOperations}",
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
                // MaterialButton(
                //   onPressed: () {},
                //   height: 50,
                //   minWidth: 220,
                //   color: Colors.orange.shade800,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(5),
                //   ),
                //   child: Text(
                //     "Change Password",
                //     style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.normal,
                //         color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}
