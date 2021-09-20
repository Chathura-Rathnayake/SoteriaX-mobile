
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soteriax/database/past_assignments_database_services.dart';
import 'package:soteriax/screens/shared/display_timeline.dart';

class PastAssignmentReport extends StatefulWidget {
  PastAssignmentReport({required this.assignmentId});

  String assignmentId;

  @override
  _PastAssignmentReportState createState() => _PastAssignmentReportState();
}

class _PastAssignmentReportState extends State<PastAssignmentReport> {

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(child: DisplayTimeline()),
        appBar: AppBar(
          title: Text("Assignment"),
          backgroundColor: Colors.orange.shade700,
          elevation: 0,
        ),
      body: FutureBuilder(
        future: PastAssignmentDB().getPastAssignment(widget.assignmentId),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if(snapshot.hasError){
                return Container(child: Text("Error getting assignment: ${snapshot.error}"),);
              }else if(snapshot.hasData){
                if(snapshot.data==null){
                  return Container(child: Text("No data retrieved"),);
                }else{
                  var assignment=snapshot.data!;
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Assignment Id: ${assignment.id}"),
                          ],
                        ),
                        SizedBox(height: 30,),

                      ],
                    ),
                  );
                }
              }else{
                return Container(child: Text("No data retrieved"),);
              }
          }
        },
      ),
    );
  }
}


