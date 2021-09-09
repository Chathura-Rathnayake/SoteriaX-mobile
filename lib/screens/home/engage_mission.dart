import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/operations_database_services.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';
import 'package:soteriax/services/engageMission_httpServices.dart';

import 'live_operation.dart';

class EngageMission extends StatefulWidget {
  const EngageMission({Key? key}) : super(key: key);

  @override
  _EngageMissionState createState() => _EngageMissionState();
}

class _EngageMissionState extends State<EngageMission> {
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();
  OperationDatabaseService _opDB=OperationDatabaseService();
  EngageMissionHttp _engageHTTP=EngageMissionHttp();
  Timer? timer;
  Timer? engageCheckTimer;
  Map? rpiResponse;
  String rpiStatus='live';
  bool waitingForRpiResponse=false;
  bool waitingForEngagementCheck=false;
  String? feedbackMessage="";


  void rpiStatusCheck(){
    timer?.cancel();
    timer=Timer.periodic(Duration(seconds: 10), (timer) async {
      if(!waitingForRpiResponse){
        waitingForRpiResponse=true;
        rpiResponse = await _engageHTTP.checkRPiAvailability();
        print('response this is: ${rpiResponse!['status']}');
        waitingForRpiResponse=false;
        if(mounted){
          if (rpiResponse!['status'] == 200) {
            setState(() {
              rpiStatus = 'live';
            });
          } else {
            print("here");
            setState(() {
              rpiStatus = 'off-line';
            });
          }
        }
      }
    });
  }



  void engageChecker(){
    engageCheckTimer?.cancel();
    engageCheckTimer=Timer.periodic(Duration(seconds: 10), (timer) async{
      if(!waitingForEngagementCheck){
          waitingForEngagementCheck=true;
          await _opDB.checkDisengagement();
          waitingForEngagementCheck=false;
      }
    });
  }


  @override
  // TODO: implement mounted
  bool get mounted => super.mounted;

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpiStatusCheck();
    engageChecker();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    this.timer?.cancel();
    this.engageCheckTimer?.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("canceled");
    this.timer?.cancel();
    this.engageCheckTimer?.cancel();
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    print('rpi status $rpiStatus');
    _opDB.checkDisengagement();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text("Engage Mission"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Image(
                image: AssetImage("assets/icons/try_connection.png"),
                width: 200,
              ),
              SizedBox(height: 30,),
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                        child: Text(
                          "Drone Module Status: ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        color: rpiStatus=='live'? Colors.green[300] : Colors.red[300] ,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                          child: Text(
                            rpiStatus=='live'? "Live" : "Off-Line",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              if(rpiStatus=='live')
                Container(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image(image: AssetImage("assets/icons/mobile_engagement.png"),),
                        title: Text("No-Engagement"),
                        subtitle: Text("Engagement Status"),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 30,),
              if(rpiStatus=='live')
                StreamBuilder<QuerySnapshot?>(
                  stream:OperationDatabaseService().EngagementStatus,
                  builder: (context, snapshot) {
                    print('triggered');
                    if(snapshot.hasData){
                      if(snapshot.data!.size>0){
                        return MaterialButton(
                          onPressed: () async {
                            Map operation=await _opDB.getOperation();
                            print('button op: $operation');
                            if(operation['opId']==null){//no current live operations so we can add one
                              rpiResponse = await _engageHTTP.checkRPiAvailability();
                              if(rpiResponse!['status']==200){
                                String? opId=await _opDB.addLiveOperation();
                                if(opId==null){
                                  setState(() {
                                    feedbackMessage="Something went wrong Couldn't create operation..";
                                  });
                                }else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: opId,)));
                                }
                              }else{
                                setState(() {
                                  feedbackMessage="Drone module unresponsive please try again";
                                });
                                return;
                              }
                            }else{
                              if(operation['engaged']){
                                //already engaged(at the split second window)... check time difference and go inside(can do a async time)
                                bool ifDisengaged=await _opDB.checkDisengagement();
                                if(ifDisengaged){
                                  rpiResponse = await _engageHTTP.checkRPiAvailability();
                                  if(rpiResponse!['status']==200){
                                    String? opId=await _opDB.addLiveOperation();
                                    if(opId==null){
                                      setState(() {
                                        feedbackMessage="Something went wrong Couldn't create operation..";
                                      });
                                    }else{
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: opId,)));
                                    }
                                  }else{
                                    setState(() {
                                      feedbackMessage="Drone module unresponsive please try again";
                                    });
                                    return;
                                  }
                                }else{
                                  setState(() {
                                    feedbackMessage="Currently engaged";
                                  });
                                }
                              }else{
                                //not engaged... released.. disengaged..
                                rpiResponse = await _engageHTTP.checkRPiAvailability();
                                if(rpiResponse!['status']==200){
                                  print('you can engage continuing engagement');
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: operation['opId'])));
                                }else{
                                  setState(() {
                                    feedbackMessage="Drone module unresponsive please try again";
                                  });
                                  return;
                                }
                              }
                            }
                          },
                          color: Colors.orange[800],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Text("ENGAGE MISSION", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                           ),
                          );
                        }else{
                          return Container();
                        }
                      }else{
                        return Container();
                      }
                    }
                ),
              SizedBox(height: 20,),
              if(feedbackMessage!="")
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5 ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: ListTile(
                    title: Text(feedbackMessage.toString(), style: TextStyle(color: Colors.red[900], fontSize: 14), overflow: TextOverflow.visible, ),
                    leading: Icon(Icons.error, color: Colors.red[900],),
                    trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: (){
                        setState(() {
                          feedbackMessage="";
                        });
                      },
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
