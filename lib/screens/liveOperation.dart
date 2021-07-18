import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soteriax/screens/mainMenu.dart';

class LiveOperations extends StatefulWidget {
  const LiveOperations({Key? key}) : super(key: key);

  @override
  _LiveOperationsState createState() => _LiveOperationsState();
}

class _LiveOperationsState extends State<LiveOperations> {
  // final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
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
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                color: Colors.black,
              ),
              Container(
                padding: const EdgeInsets.all(2),
                width: MediaQuery.of(context).size.width * 0.35,
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      child: MaterialButton(
                        onPressed: () {},
                        height: MediaQuery.of(context).size.height * 0.20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          child: Row(children: [
                            Image(
                              image: AssetImage('assets/icons/binoculars.png'),
                              width: 60,
                              height: 60,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              'Drop Package',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      child: MaterialButton(
                        onPressed: () {},
                        height: MediaQuery.of(context).size.height * 0.20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          child: Row(children: [
                            Image(
                              image: AssetImage('assets/icons/binoculars.png'),
                              width: 60,
                              height: 60,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Text(
                              'Drop Package',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
