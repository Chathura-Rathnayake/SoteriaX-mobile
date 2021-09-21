import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/operations_database_services.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';

import 'live_operation.dart';

class EngageMission extends StatefulWidget {
  const EngageMission({Key? key}) : super(key: key);

  @override
  _EngageMissionState createState() => _EngageMissionState();
}

class _EngageMissionState extends State<EngageMission> {
  LifeguardSingleton lifeguardSingleton=LifeguardSingleton();
  OperationDatabaseService _opDB=OperationDatabaseService();
  Timer? rpiStatusCheckTimer;
  Timer? engageCheckTimer;
  String rpiStatus='off-line';
  bool loading=true;
  bool waitingForRpiStatus=false;
  bool waitingForEngagementCheck=false;
  String? feedbackMessage="";



  void checkRPIStatus(){
    rpiStatusCheckTimer?.cancel();
    rpiStatusCheckTimer=Timer.periodic(Duration(seconds: 3), (timer) async{
      if(!waitingForRpiStatus){
        waitingForRpiStatus=true;
        int rpiLastOnlineTimestamp=await _opDB.getRPILastTimestamp();
        print('diff: ${Timestamp.now().millisecondsSinceEpoch-rpiLastOnlineTimestamp}');
        if(Timestamp.now().millisecondsSinceEpoch-rpiLastOnlineTimestamp<20000){
          if(rpiStatus=='off-line'){
            setState(() {
              rpiStatus='live';
            });
          }
        }else{
          if(rpiStatus=='live'){
            setState(() {
              rpiStatus='off-line';
            });
          }
        }
        waitingForRpiStatus=false;
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
    engageChecker();
    checkRPIStatus();
    Future.delayed(Duration(milliseconds: 3500), (){
      setState(() {
        loading=false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    this.engageCheckTimer?.cancel();
    this.rpiStatusCheckTimer?.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("canceled");
    this.engageCheckTimer?.cancel();
    this.rpiStatusCheckTimer?.cancel();
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
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 40,),
                Image(
                  image: AssetImage("assets/icons/try_connection.png"),
                  width: 200,
                ),
                SizedBox(height: 30,),
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
                      color: rpiStatus=='live'? Colors.green[300] : loading ? Colors.transparent : Colors.red[300] ,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        child: loading ? CircularProgressIndicator() : Text(
                          rpiStatus=='live'? "Live" : "Off-Line",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
                if(rpiStatus=='live')
                  StreamBuilder<QuerySnapshot?>(
                    stream: OperationDatabaseService().getLiveOperationData,
                    builder: (context, liveOpSnapshot) {
                      if(liveOpSnapshot.hasError){
                        return Container(); //some error while retrieving
                      } else if(liveOpSnapshot.hasData){
                        if(liveOpSnapshot.data!=null){
                          print(liveOpSnapshot.data!.docs.toString());
                          print(liveOpSnapshot.data!.docs.isEmpty);
                          return Container(
                             child: Column(
                               children: [
                                 Container(
                                   child: Card(
                                     margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: ListTile(
                                         leading: Image(image: AssetImage("assets/icons/mobile_engagement.png"),),
                                         title: Text(liveOpSnapshot.data!.docs.isEmpty ? "No Current live operations" :
                                                        liveOpSnapshot.data!.docs[0].get('engaged') ? "Engaged"
                                                            : "Not Engaged" ),
                                         subtitle: Text("Engagement Status"),
                                       ),
                                     ),
                                   ),
                                 ),
                                 SizedBox(height: 30,),
                                 if(liveOpSnapshot.data!.docs.isEmpty)
                                   MaterialButton(
                                      onPressed: () async{
                                        String? opId=await _opDB.addLiveOperation();
                                        if(opId==null){
                                          setState(() {
                                            feedbackMessage="Something went wrong Couldn't create operation..";
                                          });
                                        }else{
                                          _opDB.endExistingTrainingOps();
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: opId,)));
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
                                   ),
                                 if(liveOpSnapshot.data!.docs.isNotEmpty)  //existing live operations
                                   liveOpSnapshot.data!.docs[0].get('engaged')==false ?  //not engaged
                                   MaterialButton( // not engaged
                                     onPressed: ()async{
                                       Map operation=await _opDB.getOperation();
                                       if(operation['engaged']){
                                         feedbackMessage="Currently Engaged";
                                       }else{
                                         print('you can engage continuing engagement');
                                         _opDB.endExistingTrainingOps();
                                         Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: operation['opId'])));
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
                                   ): Container(),
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
                                   ),
                               ],
                             ) ,
                          ); //real stuff
                        }else{
                          return Container();  //no live op
                        }
                      }else{
                        return Container();//no data
                      }
                      // return ;
                    }
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
