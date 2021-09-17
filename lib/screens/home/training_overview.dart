import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/current_assignment_database_services.dart';
import 'package:soteriax/database/training_operations_database_services.dart';
import 'package:soteriax/models/lifeguardSingleton.dart';
import 'package:soteriax/screens/custom_widgets/list_widgets/tiles/info_tile.dart';
import 'package:soteriax/screens/custom_widgets/navigate_button.dart';
import 'package:soteriax/screens/custom_widgets/trainingOverview_button_section.dart';
import 'package:soteriax/screens/home/training_operation.dart';
class TrainingOverview extends StatefulWidget {
  const TrainingOverview({Key? key}) : super(key: key);

  @override
  _TrainingOverviewState createState() => _TrainingOverviewState();
}


class _TrainingOverviewState extends State<TrainingOverview> {
  Timestamp? trainingTimeStamp;
  bool isTrainingTime=false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text("Training Overview"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text("Next Training Assignment"),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              FutureBuilder<DocumentSnapshot?>( //get the latest assignment for display (next most assignment)
                future: CurrentAssignmentDB().getLatestAssignment(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if(snapshot.hasError){
                        return Text('Error getting latest Training assignment');
                      }else if(snapshot.hasData){
                        // print(snapshot.data!.data());
                        if(snapshot.data==null || snapshot.data!.data()==null){
                          return Text("No current assignments");
                        }else{
                          var assignment=snapshot.data!;
                          var roleNo=assignment.get('participantIDs').indexOf(LifeguardSingleton().uid);
                          trainingTimeStamp=snapshot.data!.get('dateTime');  //get the training start timestamp
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                InfoTile(title: assignment.get('date'), subtitle: "Date",image: "calendar"),
                                InfoTile(title: assignment.get('startTime'), subtitle: "Time",image: "clock"),
                                InfoTile(
                                  title:  roleNo== 0 ? "Mobile Handler" : roleNo==1 ? "Drone Pilot" : roleNo==2 ? "Swimmer" : "No Role",
                                  subtitle: "Role",image: "role"),
                                SizedBox(height: 5),
                                if(roleNo==0) //only show if the user is the mobile handler only that assigned user can engage
                                  TrainingButtonSection(trainingOpID: assignment.id,trainingTimeStamp: trainingTimeStamp!),
                                Text("Button will be automatically activated at the aforementioned time",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          );
                        }
                    }else{
                        return Text("No current assignments");
                      }
                  }
                }
              ),
              SizedBox(height: 20,),
              NavigationButton(title: "Current Assignments", image: "swimming-trainer", onPressedFunFlag: 1,),
              SizedBox(height: 5,),
              NavigationButton(title: "Past Assignments", image: "stat",  onPressedFunFlag: 2,),
            ],
          ),
        ),
      ),
    );
  }
}
