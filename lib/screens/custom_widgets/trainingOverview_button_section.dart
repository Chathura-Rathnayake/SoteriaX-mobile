import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/training_operations_database_services.dart';
import 'package:soteriax/screens/home/training_operation.dart';

class TrainingButtonSection extends StatefulWidget {
  TrainingButtonSection(
      {required this.trainingOpID, required this.trainingTimeStamp});
  Timestamp trainingTimeStamp; //when does training start
  String trainingOpID;

  @override
  _TrainingButtonSectionState createState() => _TrainingButtonSectionState();
}

class _TrainingButtonSectionState extends State<TrainingButtonSection> {
  Timer? trainingTimeChecker;
  Timestamp currentTimeStamp = Timestamp.now();
  bool isTrainingTime = false;

  Timer? rpiStatusCheckTimer;
  bool waitingForRpiStatus = false;
  String rpiStatus = 'off-line';

  void checkRPIStatus() {
    rpiStatusCheckTimer?.cancel();
    rpiStatusCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!waitingForRpiStatus) {
        waitingForRpiStatus = true;
        int rpiLastOnlineTimestamp =
            await TrainingOperationsDBServices().getRPILastTimestamp();
        if (Timestamp.now().millisecondsSinceEpoch - rpiLastOnlineTimestamp <
            25000) {
          if (rpiStatus == 'off-line') {
            setState(() {
              rpiStatus = 'live';
            });
          }
        } else {
          if (rpiStatus == 'live') {
            setState(() {
              rpiStatus = 'off-line';
            });
          }
        }
        waitingForRpiStatus = false;
      }
    });
  }

  void checkIfTrainingTimeReached() {
    trainingTimeChecker = Timer.periodic(Duration(seconds: 5), (timer) {
      currentTimeStamp = Timestamp.now();
      if (currentTimeStamp.seconds - widget.trainingTimeStamp.seconds >= 0) {
        //no difference training time has come
        if (!isTrainingTime) {
          setState(() {
            isTrainingTime = true;
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkRPIStatus();
    checkIfTrainingTimeReached();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    trainingTimeChecker?.cancel();
    rpiStatusCheckTimer?.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    trainingTimeChecker?.cancel();
    rpiStatusCheckTimer?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (isTrainingTime) {
      if (rpiStatus == 'live') {
        return MaterialButton(
          color: Colors.orange[600],
          onPressed: () {
            this.trainingTimeChecker?.cancel();
            this.rpiStatusCheckTimer?.cancel();
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TrainingOperation(
                          trainingOpId: widget.trainingOpID,
                        )));
          },
          disabledElevation: null,
          disabledTextColor: Colors.black,
          disabledColor: Colors.grey[500],
          child: Text(
            "Initiate Exercise",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        );
      } else {
        return Container(
          child: Text(
            'Drone Module is not activated',
            style:
                TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
          ),
        );
      }
    } else {
      return Container(
        child: Text(
            'You can start the Training after ${widget.trainingTimeStamp.toDate()}'),
      ); //not yet reached
    }
  }
}

// return MaterialButton(
// onPressed: () async {
// Map operation=await _opDB.getOperation();
// print('button op: $operation');
// if(operation['opId']==null){//no current live operations so we can add one
// rpiResponse = await _engageHTTP.checkRPiAvailability();
// String? opId=await _opDB.addLiveOperation();
// if(opId==null){
// setState(() {
// feedbackMessage="Something went wrong Couldn't create operation..";
// });
// }else{
// Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: opId,)));
// }
// }else{
// if(operation['engaged']){
// //already engaged(at the split second window)... check time difference and go inside(can do a async time)
// bool ifDisengaged=await _opDB.checkDisengagement();
// if(ifDisengaged){
// String? opId=await _opDB.addLiveOperation();
// if(opId==null){
// setState(() {
// feedbackMessage="Something went wrong Couldn't create operation..";
// });
// }else{
// Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: opId,)));
// }
// }else{
// setState(() {
// feedbackMessage="Currently engaged";
// });
// }
// }else{
// //not engaged... released.. disengaged..
// print('you can engage continuing engagement');
// Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: operation['opId'])));
// }
// }
// },
// color: Colors.orange[800],
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 18),
// child: Text("ENGAGE MISSION", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
// ),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10)
// ),
// );
// }
// }else{
// return MaterialButton(
// onPressed: () async {
// Map operation=await _opDB.getOperation();
// print('button op: $operation');
// if(operation['opId']==null){//no current live operations so we can add one
// rpiResponse = await _engageHTTP.checkRPiAvailability();
// String? opId=await _opDB.addLiveOperation();
// if(opId==null){
// setState(() {
// feedbackMessage="Something went wrong Couldn't create operation..";
// });
// }else{
// Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: opId,)));
// }
// }else{
// if(operation['engaged']){
// //already engaged(at the split second window)... check time difference and go inside(can do a async time)
// bool ifDisengaged=await _opDB.checkDisengagement();
// if(ifDisengaged){
// String? opId=await _opDB.addLiveOperation();
// if(opId==null){
// setState(() {
// feedbackMessage="Something went wrong Couldn't create operation..";
// });
// }else{
// Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: opId,)));
// }
// }else{
// setState(() {
// feedbackMessage="Currently engaged";
// });
// }
// }else{
// //not engaged... released.. disengaged..
// print('you can engage continuing engagement');
// Navigator.push(context, MaterialPageRoute(builder: (context)=>LiveOperations(operationID: operation['opId'])));
// }
// }
// },
// color: Colors.orange[800],
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 18),
// child: Text("ENGAGE MISSION", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
// ),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10)
// ),
// );
// }
