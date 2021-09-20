import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/training_operations_database_services.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimeLapDrawer extends StatefulWidget {
  TimeLapDrawer({this.stopWatchTimer, required this.operationId});
  StopWatchTimer? stopWatchTimer;
  String operationId;

  @override
  _TimeLapDrawerState createState() => _TimeLapDrawerState();
}

class _TimeLapDrawerState extends State<TimeLapDrawer> {

  List<String> stages=['Mission Initiated', 'Reached Victim', 'Dropped Package', 'Lifeguard Arrived', 'Mission Completed'] ;

  final _scrollController=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Colors.orange.shade600,
                height: 80,
                padding: EdgeInsets.only(top: 40),
                width: double.infinity,
                child: Text("Time Lap", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), ),
              ),
              Container(
                height: MediaQuery.of(context).size.height-80,
                margin: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                child: StreamBuilder<DocumentSnapshot?>(
                  stream: TrainingOperationsDBServices(operationId: widget.operationId).getTrainingOp,
                  builder: (context, snap){
                    if(snap.hasError){
                      return Container(child: Text("Error occurred while connecting to db"));
                    }else if(snap.hasData){
                      if(snap.data==null){
                        return Container();
                      }else{
                        var trainingTimes=snap.data!.get('trainingTimes');
                        return ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index){
                            final data=trainingTimes[index];
                            if(data!=""){
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Text(
                                        '${index+1}. ${stages[index]} ${StopWatchTimer.getDisplayTime(data, hours: false)}',
                                      ),
                                    ),
                                    const Divider(height: 1,),
                                  ],
                                ),
                              );
                            }else{
                              return Container();
                            }
                          },
                          itemCount: trainingTimes.length,
                        );
                      }
                    }else{
                      return Container();
                    }
                    // Future.delayed(const Duration(microseconds: 100), (){
                    //   _scrollController.animateTo(
                    //     _scrollController.position.maxScrollExtent,
                    //     duration: const Duration(microseconds: 200),
                    //     curve: Curves.easeOut
                    //   );
                    // });
                    // return Container();

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
