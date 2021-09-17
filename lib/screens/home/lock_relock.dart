import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soteriax/models/lifeguard.dart';
import 'package:soteriax/screens/initialization/init_loading.dart';

class Lock extends StatefulWidget {
  @override
  _LockState createState() => _LockState();
}

class _LockState extends State<Lock> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Lifeguard? lifeguard;
  late Future<String?> _lifeguardString;
  late Map<String, dynamic> _lifeguardMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lifeguardString = _prefs.then((SharedPreferences prefs) {
      print("hellllo");
      return (prefs.getString("lifeguardData"));
    });

    print(_lifeguardString);
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
          child: FutureBuilder<String?>(
            future: _lifeguardString,
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const LoadingSpinner();
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    print(snapshot.data);
                    _lifeguardMap =
                        jsonDecode(snapshot.data!) as Map<String, dynamic>;
                    lifeguard = Lifeguard.fromJson(_lifeguardMap);
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(0),
                      color: Colors.white,
                      child: Container(
                        child: Column(
                          children: [
                            Card(
                              elevation: 0,
                              margin: EdgeInsets.zero,
                              child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.all(0),
                                  height: 80,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          spreadRadius: 3,
                                          blurRadius: 3,
                                          offset: Offset(0,
                                              3), // changes position of shadow
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
                                        bottomLeft: Radius.circular(120),
                                      )),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Re-arming',
                                        style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: GridView.count(
                                primary: false,
                                padding: const EdgeInsets.only(
                                    top: 30, left: 80, right: 80, bottom: 10),
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 20,
                                crossAxisCount: 1,
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 10, right: 10, bottom: 0),
                                    child: (MaterialButton(
                                      onPressed: () {},
                                      height: 20,
                                      minWidth: 20,
                                      elevation: 10,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        child: Column(children: <Widget>[
                                          Image(
                                            image: AssetImage(
                                              'assets/icons/lock.png',
                                            ),
                                            height: 20,
                                          ),
                                          Text(
                                            'Engage Mission',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 10, right: 10, bottom: 0),
                                    child: (MaterialButton(
                                      onPressed: () {},
                                      height: 10,
                                      minWidth: 20,
                                      elevation: 10,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        child: Column(children: <Widget>[
                                          Image(
                                            image: AssetImage(
                                              'assets/icons/unlock.png',
                                            ),
                                            height: 100,
                                            alignment: Alignment.center,
                                          ),
                                          Text(
                                            'Engage Mission',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              }
            },
          ),
        ));
  }
}
