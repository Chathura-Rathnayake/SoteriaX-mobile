import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/live_operations_database_services.dart';
import 'package:soteriax/database/training_operations_database_services.dart';
import 'package:soteriax/services/raspberryPi/drop_package.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class DropRTDrawer extends StatefulWidget {
  DropRTDrawer({this.title, this.type, required this.operationId, required this.operationType, this.stopWatchTimer }){
    if(operationType=='live'){
      liveOpDB=LiveOperationDBServices(operationId: operationId);
    }else{
      trainingOpDB=TrainingOperationsDBServices(operationId: operationId);
    }
  }
  LiveOperationDBServices? liveOpDB;
  TrainingOperationsDBServices? trainingOpDB;
  StopWatchTimer? stopWatchTimer;
  final String operationType;
  final String operationId;
  String? title = '';
  int? type;

  @override
  _DropRTDrawerState createState() => _DropRTDrawerState();
}

class _DropRTDrawerState extends State<DropRTDrawer> {
  DropPackageRPI lock = DropPackageRPI();
  int? dropVal;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<DocumentSnapshot?>(
            stream: widget.operationType=='live' ? widget.liveOpDB!.getOperation : widget.trainingOpDB!.getTrainingOp,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Container(
                  child: Text("Error retrieving current operation", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                );
              }else if(snapshot.hasData){
                if(snapshot.data!=null){
                  return Column(
                    children: [
                      Container(
                        color: Colors.orange.shade600,
                        height: 80,
                        padding: EdgeInsets.only(top: 40),
                        width: double.infinity,
                        child: Text(
                          "Drop Package",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.arrowtriangle_right_fill,
                              color: Colors.lightGreen[100],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              CupertinoIcons.arrowtriangle_right_fill,
                              color: Colors.lightGreen[300],
                              size: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              CupertinoIcons.arrowtriangle_right_fill,
                              color: Colors.lightGreen[600],
                              size: 40,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Drop",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightGreen[900]),
                            ),
                          ],
                        ),
                      ),
                      Slider(
                          min: 100,
                          max: 900,
                          divisions: 8,
                          activeColor: Colors.lightGreen[dropVal ?? 100],
                          inactiveColor: Colors.lightGreen,
                          value: (dropVal ?? 100).toDouble(),
                          onChanged: (val) {
                            setState(() {
                              dropVal = val.round();
                              print(dropVal);
                            });
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      if (dropVal == 900)
                        RaisedButton.icon(
                            onPressed: () {
                              lock.RPiUnlock();
                              widget.operationType == 'live' ? widget.liveOpDB!.dropPackage() : widget.trainingOpDB!.dropPackage(widget.stopWatchTimer!.rawTime.value);
                            },
                            color: Colors.lightGreen[900],
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                              color: Colors.white,
                            ),
                            label: Text(
                              "DROP",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      SizedBox(
                        height: 20,
                      ),
                      if(snapshot.data!.get("currentStage")>2)
                        Text("Rest-tube has already been dropped", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[900]),),
                        SizedBox(height: 20,),
                      MaterialButton(
                        child: Text(
                          "BACK",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        minWidth: 125,
                        color: Colors.red[900],
                      ),
                    ],
                  );
                }else{
                  return Container(
                    child: Text("Operation has ended", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  );
                }
              }else{
                return Container(
                  child: Text("Error retrieving current operation", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                );
              }
            }
          ),
        ),
      ),
    );
  }
}
