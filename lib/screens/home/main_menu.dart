import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soteriax/models/lifeguard.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';
import 'package:soteriax/screens/home/emergency_call.dart';
import 'package:soteriax/screens/home/engage_mission.dart';
import 'package:soteriax/screens/home/live_operation.dart';
import 'package:soteriax/screens/home/profiles.dart';
import 'package:flutter/services.dart';
import 'package:soteriax/screens/home/training_overview.dart';
import 'package:soteriax/screens/home/view_operation.dart';
import 'package:soteriax/screens/initialization/init_loading.dart';
import 'package:soteriax/screens/shared/timeline.dart';
import 'package:soteriax/screens/shared/timer.dart';
import 'package:soteriax/services/auth_services.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // final _formkey=GlobalKey<FormState>();
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  Lifeguard? lifeguard;
  late Future<String?> _lifeguardString;
  late Map<String, dynamic> _lifeguardMap;
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();

  AuthService _auth=AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lifeguardString=_prefs.then((SharedPreferences prefs){
      return (prefs.getString("lifeguardData"));
    });
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
      ),
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: _lifeguardString,
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return const LoadingSpinner();
              default:
                if(snapshot.hasError){
                  return Text("Error: ${snapshot.error}");
                }else{
                  print(snapshot.data);
                  _lifeguardMap=jsonDecode(snapshot.data!) as Map<String, dynamic>;
                  lifeguard=Lifeguard.fromJson(_lifeguardMap);
                  lifeguardSingleton.uid=lifeguard!.uid!;
                  lifeguardSingleton.email=lifeguard!.email!;
                  lifeguardSingleton.company=lifeguard!.company!;
                  lifeguardSingleton.firstname=lifeguard!.firstname!;
                  lifeguardSingleton.lastname=lifeguard!.lastname!;
                  return Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
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
                                      offset: Offset(0, 3), // changes position of shadow
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
                                    bottomLeft: Radius.circular(120),
                                  )),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Main Menu',
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
                            padding: const EdgeInsets.all(30),
                            crossAxisSpacing: 25,
                            mainAxisSpacing: 25,
                            crossAxisCount: 2,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(6),
                                child: (MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EngageMission()),
                                    );
                                  },
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
                                          'assets/icons/quadrocopter.png',
                                        ),
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
                                padding: const EdgeInsets.all(8),
                                child: (MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context)=>ViewOperation()),
                                    );
                                  },
                                  height: 20,
                                  minWidth: 20,
                                  elevation: 10,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    child: Column(children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Image(
                                        image: AssetImage('assets/icons/binoculars.png'),
                                        width: 200,
                                        height: 70,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'View Operation',
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
                                  padding: const EdgeInsets.all(8),
                                  child: (MaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context)=>CountUpTimerPage()),
                                      );
                                    },
                                    height: 20,
                                    minWidth: 20,
                                    elevation: 10,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      child: Column(children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Image(
                                          image: AssetImage('assets/icons/target.png'),
                                          width: 200,
                                          height: 70,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Training',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ))),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: (MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EmergencyCall()),
                                    );
                                  },
                                  height: 20,
                                  minWidth: 20,
                                  elevation: 10,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    child: Column(children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Image(
                                        image: AssetImage('assets/icons/emergency_call.png'),
                                        width: 200,
                                        height: 70,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Emergency Call',
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
                                padding: const EdgeInsets.all(8),
                                child: (MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Profiles()),
                                    );
                                  },
                                  height: 20,
                                  minWidth: 20,
                                  elevation: 10,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    child: Column(children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Image(
                                        image: AssetImage('assets/icons/user.png'),
                                        width: 200,
                                        height: 70,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'User Profile',
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
                                padding: const EdgeInsets.all(8),
                                child: (MaterialButton(
                                  onPressed: () async{
                                    await _auth.signOut();
                                  },
                                  height: 20,
                                  minWidth: 20,
                                  elevation: 10,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    child: Column(children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Image(
                                        image: AssetImage('assets/icons/log-out.png'),
                                        width: 300,
                                        height: 70,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Logout',
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
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
