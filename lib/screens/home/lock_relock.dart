import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soteriax/database/operations_database_services.dart';
import 'package:soteriax/database/training_operations_database_services.dart';
import 'package:soteriax/models/lifeguard.dart';
import 'package:soteriax/screens/initialization/init_loading.dart';
import 'package:soteriax/services/raspberryPi/drop_package.dart';

class Lock extends StatefulWidget {
  @override
  _LockState createState() => _LockState();
}

class _LockState extends State<Lock> {
  DropPackageRPI lock = DropPackageRPI();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  Column(
                    children: [
                      StreamBuilder<QuerySnapshot?>(
                          stream:
                              OperationDatabaseService().getLiveOperationData,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Icon(
                                    Icons.not_interested_outlined,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Text(
                                      "Error occurred while connecting to Database",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasData) {
                              if (snapshot.data!.size == 0) {
                                return StreamBuilder<QuerySnapshot?>(
                                    stream: TrainingOperationsDBServices()
                                        .getLiveTrainingOperationData,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 70,
                                            ),
                                            Icon(
                                              Icons.not_interested_outlined,
                                              color: Colors.red,
                                              size: 50,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              child: Text(
                                                "Error occurred while connecting to Database",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else if (snapshot.hasData) {
                                        if (snapshot.data!.size == 0) {
                                          return Expanded(
                                            child: GridView.count(
                                              primary: false,
                                              padding: const EdgeInsets.only(
                                                  top: 30,
                                                  left: 80,
                                                  right: 80,
                                                  bottom: 10),
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 20,
                                              crossAxisCount: 1,
                                              children: <Widget>[
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0,
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 0),
                                                  child: (MaterialButton(
                                                    onPressed: () {
                                                      lock.RPiLock();
                                                    },
                                                    height: 20,
                                                    minWidth: 20,
                                                    elevation: 10,
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Container(
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Image(
                                                              image: AssetImage(
                                                                'assets/icons/lock.png',
                                                              ),
                                                              height: 75,
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              'Engage Mission',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                  )),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0,
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 0),
                                                  child: (MaterialButton(
                                                    onPressed: () {
                                                      lock.RPiUnlock();
                                                    },
                                                    height: 10,
                                                    minWidth: 20,
                                                    elevation: 10,
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Container(
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Image(
                                                              image: AssetImage(
                                                                'assets/icons/unlock.png',
                                                              ),
                                                              height: 75,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              'Engage Mission',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                  )),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 70,
                                              ),
                                              Icon(
                                                Icons.not_interested_outlined,
                                                color: Colors.red,
                                                size: 50,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                child: Text(
                                                  "Ongoing training operation",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      } else {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 70,
                                            ),
                                            Icon(
                                              Icons.not_interested_outlined,
                                              color: Colors.red,
                                              size: 50,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                                child: Text(
                                              "Something went wrong",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )),
                                          ],
                                        );
                                      }
                                    });
                              } else {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 70,
                                    ),
                                    Icon(
                                      Icons.not_interested_outlined,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: Text(
                                        "Ongoing live operation",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            } else {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Icon(
                                    Icons.not_interested_outlined,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      child: Text(
                                    "Something went wrong",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )),
                                ],
                              );
                            }
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
