import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/operations_database_services.dart';
import 'package:soteriax/database/view_operations_database_services.dart';
import 'package:soteriax/screens/initialization/init_loading.dart';

class OperationStatusTile extends StatefulWidget {
  String? operationId;
  String? operationFlag;
  OperationStatusTile({this.operationId, this.operationFlag});


  @override
  _OperationStatusTileState createState() => _OperationStatusTileState();
}

class _OperationStatusTileState extends State<OperationStatusTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot?>(
        stream: widget.operationFlag=="live" ? ViewOperationDBServices(operationId: widget.operationId).currentLiveOpdata : ViewOperationDBServices(operationId: widget.operationId).currentTrainingOpdata,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Container(
              child: Row(
                children: [
                  SizedBox(width: 30,),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                        child: Text("CURRENT STATUS: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                        child: Text("${snapshot.data!.get("currentStatus")}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                      )
                    ],
                  ),
                  SizedBox(width: 50,),
                  Image(image: AssetImage("assets/images/process_timeline/status${snapshot.data!.get("currentStage")}.png"), width: 60, height: 60,)
                ],
              ),
            );
          }else{
            return CircularProgressIndicator();
          }
        }
    );
  }
}
