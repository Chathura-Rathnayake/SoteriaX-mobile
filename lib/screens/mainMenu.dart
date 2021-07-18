import 'package:flutter/material.dart';
import 'package:soteriax/screens/profiles.dart';
import 'package:soteriax/screens/liveOperation.dart';
import 'package:flutter/services.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // final _formkey=GlobalKey<FormState>();

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
        child: Container(
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
                      padding: const EdgeInsets.all(8),
                      child: (MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LiveOperations()),
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
                              'Start Operation',
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
                            SizedBox(
                              height: 20,
                            ),
                            Image(
                              image: AssetImage('assets/icons/analytics.png'),
                              width: 200,
                              height: 70,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Statistics',
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
        ),
      ),
    );
  }
}
